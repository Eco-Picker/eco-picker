import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/loading_screen.dart';
import 'screens/sign_in_screen.dart';
import 'components/navigation_bar.dart';
import 'utils/token_refresher.dart';
import '../data/user.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => UserName()),
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
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Color(0xFF4CAF50),
          ),
        ),
        home: AuthWrapper(camera: camera),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final CameraDescription? camera;
  const AuthWrapper({this.camera});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate an initialization delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    } else {
      return Consumer<MyAppState>(
        builder: (context, appState, _) {
          if (appState.isSignedIn) {
            return MainBar(camera: widget.camera);
          } else {
            return SignInScreen();
          }
        },
      );
    }
  }
}

class MyAppState extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool isSignedIn = false;
  bool isEmailVerified = false;

  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 3));

    _isLoading = false;
    notifyListeners();
  }

  void signIn({required bool emailVerified}) {
    isSignedIn = true;
    isEmailVerified = emailVerified;

    // Start the token refresher
    final tokenRefresher = TokenRefresher();
    tokenRefresher.start(this); // Pass the current instance of MyAppState
    notifyListeners();
  }

  void signOut(BuildContext context) {
    isSignedIn = false;
    isEmailVerified = false;
    final tokenRefresher = TokenRefresher();
    tokenRefresher.stop();
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    });
  }
}
