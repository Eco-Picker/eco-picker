import 'package:camera/camera.dart';
import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/geolocator_utils.dart';
import '../utils/toastbox.dart';
import 'post_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription? camera;

  const CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final GeolocatorUtil _geolocatorUtil = GeolocatorUtil();
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.camera != null) {
      _initializeCamera(widget.camera!);
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
        showToast('Unavaliable to load your location info.', 'error');
      }
    } catch (e) {
      showToast('Unavaliable to load your location info.', 'error');
      print("Error getting location: $e");
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isDenied) {
        // Handle permission denial
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
      body: _initializeControllerFuture != null
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: size.width,
                    height: size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                        width: 100, // the actual width is not important here
                        child: CameraPreview(_controller!),
                      ),
                    ),
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
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
