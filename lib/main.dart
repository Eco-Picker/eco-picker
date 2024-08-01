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
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  print(firstCamera);
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

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
  final CameraDescription camera;

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
