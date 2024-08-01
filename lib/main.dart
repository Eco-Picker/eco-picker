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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          return MainBar();
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
