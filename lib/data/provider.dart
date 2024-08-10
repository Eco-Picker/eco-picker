import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userName;

  String? get userName => _userName;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }
}

class CameraProvider extends ChangeNotifier {
  CameraDescription? _camera;

  CameraDescription? get camera => _camera;

  void setCamera(CameraDescription? camera) {
    _camera = camera;
    notifyListeners();
  }
}
