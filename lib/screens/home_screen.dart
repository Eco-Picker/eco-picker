import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:eco_picker/api/api_ranking_service.dart';
import 'package:eco_picker/data/ranking.dart';
import '../api/api_user_service.dart';
import '../data/user.dart';
import 'newsletter_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiUserService _apiUserService = ApiUserService();
  final ApiRankingService _apiRankingService = ApiRankingService();
  late Future<Ranking> _dailyRankingFuture;
  late Future<Ranking> _weeklyRankingFuture;
  late Future<Ranking> _monthlyRankingFuture;
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _apiUserService.fetchUserInfo();
    _dailyRankingFuture = _apiRankingService.fetchDailyRanking();
    _weeklyRankingFuture = _apiRankingService.fetchWeeklyRanking();
    _monthlyRankingFuture = _apiRankingService.fetchMonthlyRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoPicker'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help),
            color: Color(0xFF27542A),
            tooltip: 'Show Guide',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                      // insert guide in the future
                      );
                },
              ));
            },
          ),
        ],
        titleTextStyle: headingTextStyle(),
      ),
      body: DefaultTabController(
        length: 3, // Number of tabs in TabBar
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,\nThanks for saving Earth!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Issues',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF27542A),
                            ),
                          ),
                          Text(
                            'Best Restaurants in Town',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Experience the most exquisite dining options in the city at ...',
                            style: greyTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F5E3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(8), // Creates border
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
                          LeaderboardList(rankingFuture: _dailyRankingFuture),
                          LeaderboardList(rankingFuture: _weeklyRankingFuture),
                          LeaderboardList(rankingFuture: _monthlyRankingFuture),
                        ],
                      ),
                    ),
                    Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
                    FutureBuilder<User>(
                        future: _userFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error loading data'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.username.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            final user = snapshot.data;
                            return ListTile(
                              leading: Text(
                                '100',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                user!.username,
                                style: TextStyle(fontSize: 14),
                              ),
                              trailing: Text(
                                '100 pt',
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final Future<Ranking> rankingFuture;
  LeaderboardList({required this.rankingFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ranking>(
      future: rankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.rankers.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          final rankers = snapshot.data!.rankers;
          return ListView.builder(
            itemCount: rankers.length,
            itemBuilder: (context, index) {
              final ranker = rankers[index];
              return ListTile(
                leading: Text('1'
                    // '${ranker.rank}',
                    // style: TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: ranker.rank <= 3
                    //       ? (ranker.rank == 1
                    //           ? Colors.red
                    //           : ranker.rank == 2
                    //               ? Colors.orange
                    //               : Colors.blue)
                    //       : Colors.black,
                    // ),
                    ),
                title: Text(
                  ranker.username,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  '${ranker.point} pt',
                  style: TextStyle(fontSize: 14),
                ),
              );
            },
          );
        }
      },
    );
  }
}
