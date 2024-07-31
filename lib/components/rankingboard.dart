import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_ranking_service.dart';
import '../data/ranking.dart';
import '../providers/user_provider.dart';
import 'leaderboard.dart';

class Rankingboard extends StatefulWidget {
  @override
  _RankingBoardState createState() => _RankingBoardState();
}

class _RankingBoardState extends State<Rankingboard> {
  final ApiRankingService _apiRankingService = ApiRankingService();
  late Future<Ranking> _dailyRankingFuture;
  late Future<Ranking> _weeklyRankingFuture;
  late Future<Ranking> _monthlyRankingFuture;

  @override
  void initState() {
    super.initState();
    _dailyRankingFuture = _apiRankingService.fetchDailyRanking();
    _weeklyRankingFuture = _apiRankingService.fetchWeeklyRanking();
    _monthlyRankingFuture = _apiRankingService.fetchMonthlyRanking();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Expanded(
      child: Container(
        margin:
            EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0.0),
        decoration: BoxDecoration(
          color: Color(0xFFE3F5E3),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Creates border
                  color: Color(0xFF388E3C)),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Today'),
                Tab(text: 'This Week'),
                Tab(text: 'This Month'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Leaderboard(rankingFuture: _dailyRankingFuture),
                  Leaderboard(rankingFuture: _weeklyRankingFuture),
                  Leaderboard(rankingFuture: _monthlyRankingFuture),
                ],
              ),
            ),
            Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
            if (userProvider.isLoading)
              Center(child: CircularProgressIndicator())
            else if (userProvider.user == null)
              Center(child: Text('No data available'))
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
                  userProvider.user!.username,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  '${userProvider.user!.score}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
