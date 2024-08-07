import 'dart:io';
import 'package:eco_picker/screens/post_picture_screen.dart';
import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_garbage_service.dart';
import '../data/garbage.dart';
import '../utils/change_date_format.dart';
import '../utils/styles.dart';

class AnalyzeResultScreen extends StatefulWidget {
  final String imagePath;
  final Garbage? garbageResult;
  final LatLng location;

  AnalyzeResultScreen(
      {required this.imagePath, this.garbageResult, required this.location});

  @override
  _AnalyzeResultScreenState createState() => _AnalyzeResultScreenState();
}

class _AnalyzeResultScreenState extends State<AnalyzeResultScreen> {
  final ApiGarbageService _apiGarbageService = ApiGarbageService();

  Future<void> saveData() async {
    widget.garbageResult?.setPosition(widget.location.latitude.toDouble(),
        widget.location.longitude.toDouble());
    print(widget.garbageResult!.name);
    bool didSave = await _apiGarbageService.saveGarbage(widget.garbageResult!);
    if (didSave) {
      showToast('Saved your garbage data.', 'success');
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      showToast('Failed to save your garbage data. Please try again.', 'error');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(
                File(widget.imagePath),
                width: size.width / 1.7,
              ),
              SizedBox(
                height: 8,
              ),
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
                        Text(changeDateFormat(widget.garbageResult!.pickedUpAt),
                            style: bodyImportantTextStyle()),
                      ],
                    ),
                  ],
                )
              else
                Text('No result'),
              ElevatedButton(
                onPressed: saveData,
                style: smallButtonStyle(),
                child: Text('Save Garbage Data'),
              ),
              ElevatedButton(
                onPressed: analyzeAgain,
                style: greyButtonStyle(),
                child: Text('Analyze Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
