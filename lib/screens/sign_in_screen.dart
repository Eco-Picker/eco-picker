import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../api/token_manager.dart';
import '../data/user.dart';
import '../main.dart';
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
  final TokenManager _tokenManager = TokenManager();
  bool _isLoading = false;
  bool _showErrors = false;
  bool _usernameError = false;
  bool _passwordError = false;

  Future<void> saveUserId() async {
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(await _tokenManager.getAccessToken() ?? '');
    Provider.of<UserName>(context, listen: false)
        .setUserName(decodedToken['sub']);
  }

  Future<void> _signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    bool emailVerified = false;

    if (_formKey.currentState == null) {
      return;
    }

    setState(() {
      _showErrors = true;
      _usernameError = username.isEmpty ||
          (_formKey.currentState?.validate() == false && username.isNotEmpty);
      _passwordError = password.isEmpty ||
          (_formKey.currentState?.validate() == false && password.isNotEmpty);
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        var loginStatus = await _apiUserService.login(username, password);
        if (loginStatus == "success") {
          await Future.delayed(Duration(seconds: 1));
          try {
            User user = await _apiUserService.fetchUserInfo();
            user.onboardingStatus == "COMPLETE"
                ? emailVerified = true
                : emailVerified = false;

            if (!emailVerified) {
              showToast(
                  'You haven\'t verified your email.\nPlease check your inbox and click the verification URL to start.',
                  'error');
            } else {
              saveUserId();
              Provider.of<MyAppState>(context, listen: false).signIn(
                emailVerified: emailVerified,
              );
            }
          } catch (e) {
            if (e == 'LOG_OUT') {
              showToast('User token expired. Logging out.', 'error');
              final appState = Provider.of<MyAppState>(context, listen: false);
              appState.signOut(context);
            } else {
              showToast('Error fetching user info: $e', 'error');
            }
          }
        } else {
          showToast(loginStatus, 'error');
        }
      } catch (e) {
        showToast('Failed to login: ${e.toString()}', 'error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Icon.png', height: 200),
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
                            decoration: inputStyle('Username', _formKey,
                                _showErrors, _usernameError),
                            cursorColor: Color(0xFF4CAF50),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _usernameError = true;
                                });
                                return 'Please enter your username';
                              }
                              setState(() {
                                _usernameError = false;
                              });
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: inputStyle('Password', _formKey,
                                _showErrors, _passwordError),
                            cursorColor: Color(0xFF4CAF50),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _passwordError = true;
                                });
                                return 'Please enter your password';
                              }
                              setState(() {
                                _passwordError = false;
                              });
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
                                      builder: (context) =>
                                          ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: greyTextStyle(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _signIn,
                            style: submitButtonStyle(),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
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
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
            ),
        ],
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
