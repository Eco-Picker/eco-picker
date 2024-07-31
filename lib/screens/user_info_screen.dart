import 'package:eco_picker/components/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../main.dart';
import '../utils/styles.dart';
import 'change_password.dart';

class UserInfoScreen extends StatelessWidget {
  final ApiUserService _ApiUserService = ApiUserService();

  void _logout(BuildContext context) {
    _ApiUserService.logout();
    Provider.of<MyAppState>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        titleTextStyle: headingTextStyle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserDashboard(),
              const Divider(),
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
