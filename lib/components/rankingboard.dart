import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_ranking_service.dart';
import '../data/ranking.dart';
import '../main.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';
import 'user_dashboard.dart';

class Rankingboard extends StatefulWidget {
  final Function onLoadingComplete;

  Rankingboard({required this.onLoadingComplete});

  @override
  _RankingboardState createState() => _RankingboardState();
}

class _RankingboardState extends State<Rankingboard> {
  final ApiRankingService _apiRankingService = ApiRankingService();
  late Future<Ranking> _rankingFuture;

  @override
  void initState() {
    super.initState();
    try {
      _rankingFuture = _apiRankingService.fetchRanking();
    } catch (e) {
      if (e == 'LOG_OUT') {
        showToast('User token expired. Logging out.', 'error');
        final appState = Provider.of<MyAppState>(context, listen: false);
        appState.signOut(context);
      } else {
        showToast('Error fetching ranking: $e', 'error');
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadingComplete();
      });
    }
  }

  void _showUserDashboard(int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFF6BBD6E),
                ),
                padding: EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(16.0),
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
              FutureBuilder<Ranking>(
                future: _rankingFuture,
                builder: (context, snapshot) {
                  List<Ranker> rankers = List.generate(
                      10, (index) => Ranker(username: '', point: 0, id: 0));

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    showToast('An error occurred: ${snapshot.error}', 'error');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onLoadingComplete();
                    });
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text('Error loading ranking'),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.rankers.isNotEmpty) {
                      rankers = [];
                      int currentRank = 0;
                      int lastPoint = -1;
                      int rankCounter = 1;

                      for (var ranker in snapshot.data!.rankers) {
                        if (ranker.point != lastPoint) {
                          currentRank += rankCounter;
                          rankCounter = 1;
                        } else {
                          rankCounter++;
                        }
                        lastPoint = ranker.point;
                        rankers.add(ranker.copyWith(rank: currentRank));
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onLoadingComplete();
                      });
                    } else {
                      showToast('No data available', 'error');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onLoadingComplete();
                      });
                    }
                  } else {
                    showToast('No data available', 'error');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onLoadingComplete();
                    });
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
              )
            ],
          )),
    );
  }
}
