import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_ranking_service.dart';
import '../data/ranking.dart';
import '../providers/user_provider.dart';
import 'leaderboard.dart';
import 'user_dashboard.dart';

class Rankingboard extends StatefulWidget {
  @override
  _RankingBoardState createState() => _RankingBoardState();
}

class _RankingBoardState extends State<Rankingboard> {
  void _showUserDashboard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: UserDashboard(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Expanded(
      child: Container(
          margin:
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFE3F5E3),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(0),
                  ),
                  color: Color(0xFF4CAF50),
                ),
                child: Text(
                  'Leaderboard',
                  style: midTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Leaderboard(),
              Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
              if (userProvider.isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                )
              else
                ListTile(
                  leading: Text(
                    '100',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    userProvider.user?.username ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(
                    '${0} pt',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: userProvider.user != null ? _showUserDashboard : null,
                ),
            ],
          )),
    );
  }
}
