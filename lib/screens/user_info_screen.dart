import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_user_service.dart';
import '../main.dart';
import '../utils/styles.dart';

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
        titleTextStyle: headingTextStyle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Badges',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildBadge('Badge 1', Icons.star),
                _buildBadge('Badge 2', Icons.emoji_events),
                _buildBadge('Badge 3', Icons.emoji_events),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Certificates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildCertificate('Certificate 1'),
            _buildCertificate('Certificate 2'),
            _buildCertificate('Certificate 3'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: submitButtonStyle(),
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 18),
                // ADD "ARE YOU SURE?" POP-UP
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String title, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: Colors.white),
      label: Text(title),
      backgroundColor: Colors.green,
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  Widget _buildCertificate(String title) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.verified, color: Colors.green),
        title: Text(title),
      ),
    );
  }
}
