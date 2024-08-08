import 'dart:io';
import 'package:eco_picker/screens/analyze_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_garbage_service.dart';
import '../data/garbage.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';

class PostPictureScreen extends StatefulWidget {
  final String imagePath;
  final LatLng location;

  const PostPictureScreen(
      {super.key, required this.imagePath, required this.location});

  @override
  _PostPictureScreenState createState() => _PostPictureScreenState();
}

class _PostPictureScreenState extends State<PostPictureScreen> {
  final ApiGarbageService _apiGarbageService = ApiGarbageService();
  bool _isLoading = false;
  Garbage? _garbageResult;
  late Map<String, dynamic> _analyzeGarbageFuture;

  Future<void> analyzeImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final imageFile = File(widget.imagePath);
      final analyzeResult = await _apiGarbageService.analyzeGarbage(imageFile);

      setState(() {
        _analyzeGarbageFuture = analyzeResult;
      });

      if (_analyzeGarbageFuture['code'] == "VALIDATION_FAILED") {
        showToast('Please try again with the valid garbage picture.', 'error');
        Navigator.pop(context);
      } else {
        _garbageResult = Garbage.fromJson(_analyzeGarbageFuture['garbage']);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => AnalyzeResultScreen(
                    imagePath: widget.imagePath,
                    garbageResult: _garbageResult,
                    location: widget.location,
                  )),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Post Picture', style: headingTextStyle())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(
                File(widget.imagePath),
                width: size.width / 1.5,
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: analyzeImage,
                    style: smallButtonStyle(),
                    child: Text('Analyze Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: greyButtonStyle(),
                    child: Text('Take again'),
                  ),
                ],
              ),
              if (_isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              if (_garbageResult != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Analysis Result: $_garbageResult'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
