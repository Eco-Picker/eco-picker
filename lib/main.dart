import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_screen.dart';
import 'components/navigation_bar.dart';
import 'utils/token_refresher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokenRefresher = TokenRefresher();
  tokenRefresher.start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
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
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, _) {
        if (appState.isSignedIn) {
          return Map(); // This should be your main app screen
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
  bool isUsingTemporaryPassword = false;

  void signIn({required bool emailVerified}) {
    isSignedIn = true;
    isEmailVerified = emailVerified;
    notifyListeners();
  }

  void signOut() {
    isSignedIn = false;
    notifyListeners();
  }
}
