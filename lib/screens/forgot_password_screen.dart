import 'package:flutter/material.dart';

import '../styles.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _sendTemporaryPassword() {
    // Perform the logic to send a temporary password (e.g., API call)
    // Show a confirmation message
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('''Please enter your email address. 
We\'ll send you a temporary password.''',
                  textAlign: TextAlign.center, style: bodyTextStyle()),
              SizedBox(height: 16),
              TextField(
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
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendTemporaryPassword,
                style: submitButtonStyle(),
                child: Text('Send Temporary Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
