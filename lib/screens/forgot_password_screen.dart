import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import '../api/api_user_service.dart';
import '../utils/styles.dart';
import '../utils/validator.dart';
import 'sign_up_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _showErrors = false;
  bool _emailError = false;

  Future<void> _sendTemporaryPassword() async {
    final email = _emailController.text;

    _showErrors = true;
    _emailError = email.isEmpty ||
        (_formKey.currentState?.validate() == false && email.isNotEmpty);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final result = await _apiUserService.sendTemporaryPassword(email);
      if (result == true && mounted) {
        showToast('Temporary password sent to your email.', 'pass');
        setState(() {
          _isLoading = false;
        });
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showToast(
            'Email not registered. \nPlease try with another email.', 'error');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        titleTextStyle: headingTextStyle(),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please enter your email address.\nWe\'ll send you a temporary password.',
                      textAlign: TextAlign.center,
                      style: bodyTextStyle(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: inputStyle(
                          'Email', _formKey, _showErrors, _emailError),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sendTemporaryPassword,
                      style: submitButtonStyle(),
                      child: Text('Send Temporary Password'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?",
                            style: bodyTextStyle()),
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
                        Text("Do you want to sign up?", style: bodyTextStyle()),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
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
}
