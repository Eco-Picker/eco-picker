import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../main.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';
import '../utils/styles.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Check if the form is valid before attempting login
    if (_formKey.currentState!.validate()) {
      try {
        // Wait for the login process to complete
        await _apiUserService.login(username, password);

        // Assuming the login was successful and the service saves the token
        bool emailVerified = true;
        bool temporaryPassword = false;

        if (!emailVerified) {
          // Show a message if the email is not verified
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'You haven\'t verified your email. Please check your inbox and click the verification URL to start.'),
            ),
          );
        } else {
          // Proceed with the sign-in process
          Provider.of<MyAppState>(context, listen: false).signIn(
            emailVerified: emailVerified,
            temporaryPassword: temporaryPassword,
          );
        }
      } catch (e) {
        // Handle errors, such as network issues or invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login: ${e.toString()}'),
          ),
        );
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
              Image.asset('assets/Icon.png',
                  height: 200), //idk if this is good height but good for now
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
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
