import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import '../api/api_user_service.dart';
import '../utils/styles.dart';
import '../utils/validator.dart';
import 'sign_up_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendTemporaryPassword() async {
    final email = _emailController.text;
    if (_formKey.currentState!.validate()) {
      final result = await _apiUserService.sendTemporaryPassword(email);
      if (result == true) {
        showToast('Temporary password sent to your email.', 'pass');
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showToast(
            'Email not registered. \nPlease try with another email.', 'error');
      }
    }
  }

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your email address';
  //   }
  //   String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
  //   RegExp regex = RegExp(pattern);
  //   if (!regex.hasMatch(value)) {
  //     return 'Please enter a valid email address';
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
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
                Text(
                    'Please enter your email address. \nWe\'ll send you a temporary password.',
                    textAlign: TextAlign.center,
                    style: bodyTextStyle()),
                SizedBox(height: 16),
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
                  validator: validateEmail,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sendTemporaryPassword,
                  style: submitButtonStyle(),
                  child: Text('Send Temporary Password'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?", style: bodyTextStyle()),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
                    Text("Do you want to sign up?", style: bodyTextStyle()),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
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
            ),
          ),
        ),
      ),
    );
  }
}
