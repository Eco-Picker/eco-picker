import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<void> _loginFuture;

  @override
  void initState() {
    super.initState();
    _loginFuture = _signIn();
  }

  Future<void> _signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    bool emailVerified = false;

    if (_formKey.currentState == null) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        var loginStatus = await _apiUserService.login(username, password);

        if (loginStatus == "success") {
          await Future.delayed(Duration(seconds: 1));
          final user = await _apiUserService.fetchUserInfo();

          user.onboardingStatus == "COMPLETE"
              ? emailVerified = true
              : emailVerified = false;

          if (!emailVerified) {
            showToast(
                'You haven\'t verified your email.\nPlease check your inbox and click the verification URL to start.',
                'error');
          } else {
            Provider.of<MyAppState>(context, listen: false).signIn(
              emailVerified: emailVerified,
            );
            Provider.of<UserProvider>(context, listen: false).setUser(user);
          }
        } else {
          showToast(loginStatus, 'error');
        }
      } catch (e) {
        showToast(
            'Failed to login: ${e?.toString() ?? 'Unknown error'}', 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Icon.png', height: 200),
              Text('Eco Picker',
                  style: GoogleFonts.quicksand(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF27542A),
                  )),
              SizedBox(height: 40),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          floatingLabelStyle:
                              TextStyle(color: Color(0xFF27542A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF4CAF50)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        cursorColor: Color(0xFF4CAF50),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          floatingLabelStyle:
                              TextStyle(color: Color(0xFF27542A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF4CAF50)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        cursorColor: Color(0xFF4CAF50),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: greyTextStyle(),
                          ),
                        ),
                      ),
                      FutureBuilder<void>(
                        future: _loginFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return ElevatedButton(
                              onPressed: _signIn,
                              style: submitButtonStyle(),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: bodyTextStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: selectTextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
