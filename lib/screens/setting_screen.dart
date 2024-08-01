import 'package:eco_picker/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_user_service.dart';
import '../utils/styles.dart';
import 'change_password.dart';
import 'sign_in_screen.dart';

class SettingScreen extends StatelessWidget {
  final ApiUserService _ApiUserService = ApiUserService();

  void _logout(BuildContext context) {
    _ApiUserService.logout();
    Provider.of<MyAppState>(context, listen: false).signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        titleTextStyle: headingTextStyle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Update Password'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
