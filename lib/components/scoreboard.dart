import 'package:eco_picker/utils/rank_image.dart';
import 'package:flutter/material.dart';

import '../api/api_user_service.dart';
import '../data/user.dart';
import '../utils/styles.dart';

class Scoreboard extends StatefulWidget {
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ApiUserService _apiUserService = ApiUserService();
  late Future<UserStatistics> _userStatisticsFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.10).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
    _userStatisticsFuture = _apiUserService.fetchUserStatistics();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserStatistics>(
      future: _userStatisticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load user statistics'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final userStatistics = snapshot.data!;
        final rank = userStatistics.getRank();
        final totalScore = userStatistics.score.totalScore;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Eco Rank', style: titleTextStyle()),
                Text(totalScore.toString(), style: titleTextStyle())
              ],
            ),
            Text('Collect points to be a master player!'),
            SizedBox(
              height: 8,
            ),
            // Progress Bar
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Color(0xFFE5E5E5),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  minHeight: 10,
                );
              },
            ),
            const SizedBox(height: 4),
            // Steps with numbers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator('0', 'Bronze'),
                _buildStepIndicator('2500', 'Silver'),
                _buildStepIndicator('5000', 'Gold'),
                _buildStepIndicator('7500', 'Diamond'),
                _buildStepIndicator('10000+', 'Master'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepIndicator(String number, String rank) {
    return Column(
      children: [
        buildRankImage(rank, 2),
        Text(
          number,
          style: bodyImportantTextStyle(),
        ),
      ],
    );
  }
}
