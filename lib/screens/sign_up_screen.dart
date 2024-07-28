import 'package:eco_picker/api/api_user_service.dart';
import 'package:eco_picker/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';
import '../utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (_formKey.currentState!.validate()) {
      if (username.isEmpty || password.isEmpty || email.isEmpty) {
        showToast('All fields are required', 'error');
        return;
      }

      try {
        final result = await _apiUserService.signUp(username, password, email);
        if (result == 'true') {
          showToast(
              'A verification link has been sent to your email account. Please click on the link that has just been sent to your email account to verify your email to finish sign up process.',
              'pass');
        } else {
          showToast(result, 'error');
        }
      } catch (e) {
        showToast('An error occurred: $e', 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        titleTextStyle: headingTextStyle(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    floatingLabelStyle: TextStyle(color: Color(0xFF27542A)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  cursorColor: Color(0xFF4CAF50),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(color: Color(0xFF27542A)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  cursorColor: Color(0xFF4CAF50),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return validateEmail(value);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(color: Color(0xFF27542A)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  cursorColor: Color(0xFF4CAF50),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return validatePassword(value);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    floatingLabelStyle: TextStyle(color: Color(0xFF27542A)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  cursorColor: Color(0xFF4CAF50),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signUp,
                  style: submitButtonStyle(),
                  child: Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?", style: bodyTextStyle()),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign in',
                        style: selectTextStyle(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Forgot password?", style: bodyTextStyle()),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password',
                        style: selectTextStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
