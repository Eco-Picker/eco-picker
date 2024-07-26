import 'package:flutter/material.dart';

import '../styles.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() {
    // Perform the sign-up logic (e.g., API call to send verification email)
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
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
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextField(
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
              ),
              const SizedBox(height: 10),
              TextField(
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
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                style: submitButtonStyle(),
                child: Text('Sign Up'),
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
            ],
          ),
        ),
      ),
    );
  }
}
