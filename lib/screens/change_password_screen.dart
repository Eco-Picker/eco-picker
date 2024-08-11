import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../main.dart';
import '../utils/styles.dart';
import '../utils/validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _showErrors = false;
  bool _currentPasswordError = false;
  bool _newPasswordError = false;
  bool _confirmPasswordError = false;

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _showErrors = true;
      _currentPasswordError = currentPassword.isEmpty ||
          (_formKey.currentState?.validate() == false &&
              currentPassword.isNotEmpty);
      _newPasswordError = newPassword.isEmpty ||
          (_formKey.currentState?.validate() == false &&
              newPassword.isNotEmpty);
      _confirmPasswordError = confirmPassword.isEmpty ||
          (_formKey.currentState?.validate() == false &&
              confirmPassword.isNotEmpty);
    });

    if (_formKey.currentState!.validate()) {
      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {
        showToast('All fields are required', 'error');
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _apiUserService.changePassword(
            currentPassword, newPassword, confirmPassword);
        if (result == 'pass') {
          showToast('Successfully changed your password!', 'pass');
          Navigator.pop(context);
        } else {
          showToast(result, 'error');
        }
      } catch (e) {
        if (e == 'LOG_OUT') {
          showToast('User token expired. Logging out.', 'error');
          final appState = Provider.of<MyAppState>(context, listen: false);
          appState.signOut(context);
        } else {
          showToast('Error changing password: $e', 'error');
        }
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
      appBar: AppBar(
        title: Text('Change Password'),
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
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: inputStyle('Current Password', _formKey,
                          _showErrors, _currentPasswordError),
                      cursorColor: Color(0xFF4CAF50),
                      obscureText: true,
                      validator: (value) {
                        String? validMsg = validatePassword(value);
                        if (validMsg == null) {
                          setState(() {
                            _currentPasswordError = false;
                          });
                          return validMsg;
                        } else {
                          setState(() {
                            _currentPasswordError = true;
                          });
                          return validMsg;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: inputStyle('New Password', _formKey,
                          _showErrors, _newPasswordError),
                      cursorColor: Color(0xFF4CAF50),
                      obscureText: true,
                      validator: (value) {
                        String? validMsg = validatePassword(value);
                        if (validMsg == null) {
                          setState(() {
                            _newPasswordError = false;
                          });
                          return validMsg;
                        } else {
                          setState(() {
                            _newPasswordError = true;
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
                        if (value != _newPasswordController.text) {
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: submitButtonStyle(),
                      child: Text('Change Password'),
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
