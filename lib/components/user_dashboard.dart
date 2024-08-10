import 'package:eco_picker/api/api_ranking_service.dart';
import 'package:eco_picker/data/provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../api/api_user_service.dart';
import '../data/user.dart';
import '../main.dart';
import '../utils/rank_image.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';

class UserDashboard extends StatefulWidget {
  final int? rankerID;

  const UserDashboard({this.rankerID});
  @override
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPointUnit = true; // State to track unit type
  final ApiUserService _apiUserService = ApiUserService();
  final ApiRankingService _apiRankingService = ApiRankingService();
  late Future<UserStatistics> _userStatisticsFuture;
  String? userName;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    if (widget.rankerID == null) {
      try {
        _userStatisticsFuture = _apiUserService.fetchUserStatistics();
      } catch (e) {
        if (e == 'LOG_OUT') {
          showToast('User token expired. Logging out.', 'error');
          final appState = Provider.of<MyAppState>(context, listen: false);
          appState.signOut(context);
        } else {
          showToast('Error analyzing garbage: $e', 'error');
        }
      }
    } else {
      try {
        _userStatisticsFuture =
            _apiRankingService.fetchRanker(widget.rankerID!);
      } catch (e) {
        if (e == 'LOG_OUT') {
          showToast('User token expired. Logging out.', 'error');
          final appState = Provider.of<MyAppState>(context, listen: false);
          appState.signOut(context);
        } else {
          showToast('Error analyzing garbage: $e', 'error');
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.rankerID == null) {
      userName = Provider.of<UserProvider>(context).userName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      _isPointUnit = !_isPointUnit;
    });
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
          print(snapshot.error);
          return Center(child: Text('Failed to load user statistics'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final userStatistics = snapshot.data!;
        final rank = userStatistics.getRank();
        final totalScore = userStatistics.score.totalScore;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName ?? userStatistics.userName!,
                  style: midTextStyle(),
                ),
                Row(
                  children: [
                    buildRankImage(rank, 1),
                    Text(
                      rank,
                      style: midTextStyle(),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Collected Garbages (pk)',
                    style: titleTextStyle(),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildStatColumn(
                          'Total', userStatistics.count.totalCount.toString()),
                      _buildStatColumn('Today',
                          userStatistics.count.totalDailyCount.toString()),
                      _buildStatColumn('This Week',
                          userStatistics.count.totalWeeklyCount.toString()),
                      _buildStatColumn('This Month',
                          userStatistics.count.totalMonthlyCount.toString()),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          if (userStatistics.score.totalScore == 0) {
                            return Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                border: Border.all(color: Color(0xFF388E3C)),
                                shape: BoxShape.circle,
                              ),
                            );
                          } else {
                            return PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: categoryColors['Plastic'],
                                    value: userStatistics.count.totalPlastic *
                                        _animation.value,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    color: categoryColors['Metal'],
                                    value: userStatistics.count.totalMetal *
                                        _animation.value,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    color: categoryColors['Glass'],
                                    value: userStatistics.count.totalGlass *
                                        _animation.value,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    color: categoryColors['Cardboard'],
                                    value: userStatistics
                                            .count.totalCardboardPaper *
                                        _animation.value,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    color: categoryColors['Food scraps'],
                                    value:
                                        userStatistics.count.totalFoodScraps *
                                            _animation.value,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    color: categoryColors['Other'],
                                    value: userStatistics.count.totalOther *
                                        _animation.value,
                                    showTitle: false,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL', style: TextStyle(color: Colors.grey)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              _isPointUnit
                                  ? '$totalScore pt'
                                  : '${userStatistics.count.totalCount} pk',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Transform.translate(
                            offset: Offset(-10, 0),
                            child: RawMaterialButton(
                              onPressed: _toggleUnit,
                              constraints:
                                  BoxConstraints(minWidth: 0, minHeight: 0),
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder(),
                              child: Icon(Icons.change_circle, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildScoreDetail(
                    categoryColors['Plastic']!,
                    'Plastic',
                    _isPointUnit
                        ? '${userStatistics.score.plasticScore} pt'
                        : '${userStatistics.count.totalPlastic} pk'),
                _buildScoreDetail(
                    categoryColors['Metal']!,
                    'Metal',
                    _isPointUnit
                        ? '${userStatistics.score.metalScore} pt'
                        : '${userStatistics.count.totalMetal} pk'),
                _buildScoreDetail(
                    categoryColors['Glass']!,
                    'Glass',
                    _isPointUnit
                        ? '${userStatistics.score.glassScore} pt'
                        : '${userStatistics.count.totalGlass} pk'),
                _buildScoreDetail(
                    categoryColors['Cardboard']!,
                    'Cardboard',
                    _isPointUnit
                        ? '${userStatistics.score.cardboardPaperScore} pt'
                        : '${userStatistics.count.totalCardboardPaper} pk'),
                _buildScoreDetail(
                    categoryColors['Food scraps']!,
                    'Food scraps',
                    _isPointUnit
                        ? '${userStatistics.score.foodScrapsScore} pt'
                        : '${userStatistics.count.totalFoodScraps} pk'),
                _buildScoreDetail(
                    categoryColors['Other']!,
                    'Other',
                    _isPointUnit
                        ? '${userStatistics.score.otherScore} pt'
                        : '${userStatistics.count.totalOther} pk'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatColumn(String title, String count) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE5E5E5),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: 80,
      child: Column(
        children: [
          Text(title, style: smallTextStyle()),
          Text(count, style: bodyImportantTextStyle()),
        ],
      ),
    );
  }

  Widget _buildScoreDetail(Color color, String label, String points) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 18,
          height: 18,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label, style: bodyTextStyle()),
        Spacer(),
        Text(points, style: bodyTextStyle()),
      ],
    );
  }
}
