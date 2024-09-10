import 'dart:io';
import 'package:eco_picker/screens/post_picture_screen.dart';
import 'package:eco_picker/screens/save_result_screen.dart';
import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../api/api_garbage_service.dart';
import '../data/garbage.dart';
import '../main.dart';
import '../utils/change_date_format.dart';
import '../utils/styles.dart';

class AnalyzeResultScreen extends StatefulWidget {
  final String imagePath;
  final Garbage? garbageResult;
  final LatLng location;

  AnalyzeResultScreen(
      {required this.imagePath, this.garbageResult, required this.location});

  @override
  State<AnalyzeResultScreen> createState() => _AnalyzeResultScreenState();
}

class _AnalyzeResultScreenState extends State<AnalyzeResultScreen> {
  final ApiGarbageService _apiGarbageService = ApiGarbageService();
  bool _isLoading = false;

  Future<void> saveData() async {
    setState(() {
      _isLoading = true;
    });

    widget.garbageResult?.setPosition(widget.location.latitude.toDouble(),
        widget.location.longitude.toDouble());
    try {
      bool didSave =
          await _apiGarbageService.saveGarbage(widget.garbageResult!);
      if (didSave) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    SaveResultScreen(garbageResult: widget.garbageResult!)),
          );
        }
      }
    } catch (e) {
      if (e == 'LOG_OUT') {
        showToast('User token expired. Logging out.', 'error');
        if (mounted) {
          final appState = Provider.of<MyAppState>(context, listen: false);
          appState.signOut(context);
        }
      } else {
        showToast(
            'Failed to save your garbage data. Please try again.', 'error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> analyzeAgain() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => PostPictureScreen(
                imagePath: widget.imagePath,
                location: widget.location,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Analyze Result', style: headingTextStyle())),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    File(widget.imagePath),
                    width: size.width / 1.7,
                  ),
                  SizedBox(height: 8),
                  if (widget.garbageResult != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Name: ', style: bodyTextStyle()),
                            Text(widget.garbageResult!.name,
                                style: bodyImportantTextStyle()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Category: ', style: bodyTextStyle()),
                            Text(widget.garbageResult!.category,
                                style: bodyImportantTextStyle()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Picked up at: ', style: bodyTextStyle()),
                            Text(
                                changeDateFormat(
                                    widget.garbageResult!.pickedUpAt),
                                style: bodyImportantTextStyle()),
                          ],
                        ),
                      ],
                    )
                  else
                    Text('No result'),
                  ElevatedButton(
                    onPressed: _isLoading ? null : saveData,
                    style: smallButtonStyle(),
                    child: Text('Save Garbage Data'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : analyzeAgain,
                    style: greyButtonStyle(),
                    child: Text('Analyze Again'),
                  ),
                ],
              ),
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
    );
  }
}
