import 'package:flutter/material.dart';
import '../api/api_ranking_service.dart';
import '../data/ranking.dart';
import 'user_dashboard.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final ApiRankingService _apiRankingService = ApiRankingService();
  late Future<Ranking> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = _apiRankingService.fetchRanking();
  }

  void _showUserDashboard(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('test'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: UserDashboard(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ranking>(
      future: _rankingFuture,
      builder: (context, snapshot) {
        List<Ranker> rankers =
            List.generate(10, (index) => Ranker(username: '', point: 0, id: 0));
        String errorMessage = '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          errorMessage = 'Error loading data';
        } else if (snapshot.hasData) {
          if (snapshot.data!.rankers.isNotEmpty) {
            rankers = [];
            int currentRank = 1;
            int lastPoint = -1;
            int rankCounter = 1;

            for (var ranker in snapshot.data!.rankers) {
              if (ranker.point != lastPoint) {
                currentRank += rankCounter - 1;
                rankCounter = 1;
              } else {
                rankCounter++;
              }
              lastPoint = ranker.point;
              rankers.add(ranker.copyWith(rank: currentRank));
            }
          } else {
            errorMessage = 'No data available';
          }
        } else {
          errorMessage = 'No data available';
        }

        return Expanded(
          child: ListView.builder(
            itemCount: rankers.length,
            itemBuilder: (context, index) {
              final ranker = rankers[index];
              return ListTile(
                dense: true,
                onTap: () {
                  _showUserDashboard(ranker.id);
                },
                leading: Text(
                  '${ranker.rank}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                title: Text(
                  ranker.username.isEmpty ? '' : ranker.username,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  '${ranker.point} pt',
                  style: TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
