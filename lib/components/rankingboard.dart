import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
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
    return Expanded(
      child: Container(
          margin:
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFE5E5E5),
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
                  color: Color(0xFF6BBD6E),
                ),
                child: Text(
                  'Leaderboard',
                  style: midGreenTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Leaderboard(),
            ],
          )),
    );
  }
}
