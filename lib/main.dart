import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'components/navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
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
          useMaterial3: true,
          primaryColor: Color(0xFF4CAF50),
          hintColor: Color(0xFFFFEB3B),
          scaffoldBackgroundColor: Color(0xFFF5F5F5),
          appBarTheme: AppBarTheme(
            color: Color(0xFF388E3C),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF4CAF50),
            textTheme: ButtonTextTheme.primary,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFFFEB3B),
          ),
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
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
          return SignInPage();
        }
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  bool isSignedIn = false;
  bool isEmailVerified = false;
  bool isUsingTemporaryPassword = false;

  void signIn({required bool emailVerified, required bool temporaryPassword}) {
    isSignedIn = true;
    isEmailVerified = emailVerified;
    isUsingTemporaryPassword = temporaryPassword;
    notifyListeners();
  }
}
