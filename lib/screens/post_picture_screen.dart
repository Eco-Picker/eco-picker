import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../api/api_garbage_service.dart';
import '../data/garbage.dart';
import '../utils/styles.dart';

class PostPictureScreen extends StatefulWidget {
  final String imagePath;

  const PostPictureScreen({super.key, required this.imagePath});

  @override
  _PostPictureScreenState createState() => _PostPictureScreenState();
}

class _PostPictureScreenState extends State<PostPictureScreen> {
  final ApiGarbageService _apiGarbageService = ApiGarbageService();
  String _selectedCategory = 'Select a category';
  bool _isLoading = false;
  Garbage? _garbageResult;

  Future<void> analyzeImage() async {
    if (_selectedCategory == 'Select a category') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final imageFile = File(widget.imagePath);

      final garbage =
          await _apiGarbageService.analyzeGarbage(_selectedCategory, imageFile);
      setState(() {
        _garbageResult = garbage;
      });
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
              Text('Choose Category of the image:'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: <String>[
                    'Select a category',
                    'Plastic',
                    'Metal',
                    'Glass',
                    'Cardboard',
                    'Food scraps',
                    'Organic yard',
                    'Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Take again'),
                  ),
                  ElevatedButton(
                    onPressed: analyzeImage,
                    child: Text('Analyze Image'),
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
