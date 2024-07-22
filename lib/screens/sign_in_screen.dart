import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Perform the sign-in logic (e.g., API call)
      // Assume we get emailVerified and temporaryPassword from the API response
      bool emailVerified = true; // Example value
      bool temporaryPassword = false; // Example value

      if (!emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You haven\'t verified your email. Please check your inbox and click the verification URL to start.')),
        );
      } else {
        Provider.of<MyAppState>(context, listen: false).signIn(
          emailVerified: emailVerified,
          temporaryPassword: temporaryPassword,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Icon.png', height: 150), // Adjust the height as needed
              SizedBox(height: 16),
              Text(
                'Eco Picker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
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
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text('Forgot password?'),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
