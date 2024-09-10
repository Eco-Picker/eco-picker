import 'package:camera/camera.dart';
import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../data/provider.dart';
import '../utils/geolocator_util.dart';
import '../utils/toastbox.dart';
import 'post_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final GeolocatorUtil _geolocatorUtil = GeolocatorUtil();
  LatLng? _currentPosition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> getCamera() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isDenied && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permission Denied'),
            content:
                Text('Please allow camera permissions to use this feature.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }
    }

    CameraDescription? newCamera;
    List<CameraDescription> cameras = [];
    try {
      cameras = await availableCameras();
      newCamera = cameras.isNotEmpty ? cameras.first : null;
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        final cameraProvider =
            Provider.of<CameraProvider>(context, listen: false);
        cameraProvider.setCamera(newCamera);
      }
    }
  }

  Future<void> getLocation() async {
    try {
      final position = await _geolocatorUtil.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      } else {
        showToast('Unable to load your location info.', 'error');
      }
    } catch (e) {
      showToast('Unable to load your location info.', 'error');
      print("Error getting location: $e");
    }
  }

  Future<void> _initializeCamera() async {
    if (Provider.of<CameraProvider>(context, listen: false).camera == null) {
      await getCamera();
    }

    if (mounted) {
      final camera = Provider.of<CameraProvider>(context, listen: false).camera;
      if (camera == null) {
        print('No camera available');
        return;
      }

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller!.initialize().catchError((e) {
        print('Error initializing camera: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to initialize camera: $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      });
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Camera', style: headingTextStyle())),
      body: Stack(
        children: [
          _initializeControllerFuture != null
              ? FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox(
                        width: size.width,
                        height: size.height,
                        child: CameraPreview(_controller!),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        ),
                      );
                    }
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    final image = await _controller!.takePicture();
                    await getLocation();
                    if (!context.mounted) return;
                    if (_currentPosition != null) {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostPictureScreen(
                            imagePath: image.path,
                            location: _currentPosition!,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                backgroundColor: Color(0xFFC8E6C9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.radio_button_unchecked,
                  size: 55,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
    );
  }
}
