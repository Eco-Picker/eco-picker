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
  bool _showErrors = false;
  bool _usernameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

  Future<void> _signUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _showErrors = true;
      _usernameError = username.isEmpty ||
          (_formKey.currentState?.validate() == false && username.isNotEmpty);
      _emailError = email.isEmpty ||
          (_formKey.currentState?.validate() == false && email.isNotEmpty);
      _passwordError = password.isEmpty ||
          (_formKey.currentState?.validate() == false && password.isNotEmpty);
      _confirmPasswordError = confirmPassword.isEmpty ||
          (_formKey.currentState?.validate() == false &&
              confirmPassword.isNotEmpty);
    });

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
          Navigator.pop(context);
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: inputStyle(
                      'Username', _formKey, _showErrors, _usernameError),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      inputStyle('Email', _formKey, _showErrors, _emailError),
                  cursorColor: Color(0xFF4CAF50),
                  validator: (value) {
                    String? validMsg = validateEmail(value);
                    if (validMsg == null) {
                      setState(() {
                        _emailError = false;
                      });
                      return validMsg;
                    } else {
                      setState(() {
                        _emailError = true;
                      });
                      return validMsg;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: inputStyle(
                      'Password', _formKey, _showErrors, _passwordError),
                  cursorColor: Color(0xFF4CAF50),
                  obscureText: true,
                  validator: (value) {
                    String? validMsg = validatePassword(value);
                    if (validMsg == null) {
                      setState(() {
                        _passwordError = false;
                      });
                      return validMsg;
                    } else {
                      setState(() {
                        _passwordError = true;
                      });
                      return validMsg;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: inputStyle('Confirm Password', _formKey,
                      _showErrors, _confirmPasswordError),
                  cursorColor: Color(0xFF4CAF50),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        _confirmPasswordError = true;
                      });
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      setState(() {
                        _confirmPasswordError = true;
                      });
                      return 'Passwords do not match';
                    }
                    setState(() {
                      _confirmPasswordError = false;
                    });
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
