import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_screen.dart';
import 'components/navigation_bar.dart';
import 'utils/token_refresher.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokenRefresher = TokenRefresher();
  tokenRefresher.start();

  List<CameraDescription> cameras = [];
  CameraDescription? firstCamera;

  try {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.isNotEmpty ? cameras.first : null;
  } catch (e) {
    print('Error: $e');
  }

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription? camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppState()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Eco Picker',
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Color(0xFF388E3C),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Color(0xFF4CAF50),
            selectionColor: Color(0xFFC8E6C9),
            selectionHandleColor: Color(0xFF4CAF50),
          ),
        ),
        home: AuthWrapper(camera: camera),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final CameraDescription? camera;

  const AuthWrapper({required this.camera});
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, _) {
        if (appState.isSignedIn) {
          return MainBar(camera: camera);
        } else {
          return SignInScreen();
        }
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  bool isSignedIn = false;
  bool isEmailVerified = false;

  void signIn({required bool emailVerified}) {
    isSignedIn = true;
    isEmailVerified = emailVerified;
    notifyListeners();
    print('User signed in: $isSignedIn');
  }

  void signOut() {
    isSignedIn = false;
    isEmailVerified = false;
    notifyListeners();
  }
}

class MainBar extends StatelessWidget {
  final CameraDescription? camera;

  const MainBar({required this.camera});

  @override
  Widget build(BuildContext context) {
    if (camera == null) {
      return Scaffold(
        body: Center(
          child: Text('No camera available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('MainBar'),
      ),
      body: CameraPreviewWidget(camera: camera!),
    );
  }
}

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewWidget({required this.camera});

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
