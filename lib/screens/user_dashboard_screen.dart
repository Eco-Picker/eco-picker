import 'package:eco_picker/components/user_dashboard.dart';
import 'package:eco_picker/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import '../components/scoreboard.dart';
import '../utils/styles.dart';

class UserDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            color: Color(0xFF27542A),
            tooltip: 'User settings',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return SettingScreen();
                },
              ));
            },
          ),
        ],
        titleTextStyle: headingTextStyle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserDashboard(),
              SizedBox(
                height: 16,
              ),
              Scoreboard(),
            ],
          ),
        ),
      ),
    );
  }
}
