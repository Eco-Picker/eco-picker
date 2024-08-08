import 'package:flutter/material.dart';
import '../api/api_ranking_service.dart';
import '../data/ranking.dart';
import '../utils/toastbox.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              // Close Button
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFF6BBD6E),
                ),
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the BottomSheet
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserDashboard(
                    rankerID: id,
                  ),
                ),
              ),
            ],
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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          showToast('An error occurred: ${snapshot.error}', 'error');
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
            showToast('No data available', 'error');
          }
        } else {
          showToast('No data available', 'error');
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
