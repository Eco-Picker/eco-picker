import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:eco_picker/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCameras();

  runApp(const EcoPicker());
}

Future<void> initializeCameras() async {
  _cameras = await availableCameras();
}

class EcoPicker extends StatefulWidget {
  const EcoPicker({Key? key}) : super(key: key);

  @override
  State<EcoPicker> createState() => _EcoPickerState();
}

class _EcoPickerState extends State<EcoPicker> {
  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  void requestCameraPermission() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Picker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
