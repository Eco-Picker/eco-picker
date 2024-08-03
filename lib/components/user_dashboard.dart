import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPointUnit = true; // State to track unit type

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
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
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (userProvider.isLoading)
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          )
        else if (userProvider.user == null)
          Text(
            'Hello!',
            style: midTextStyle(),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userProvider.user!.username,
                style: midTextStyle(),
              ),
              Text('Bronze', style: midTextStyle())
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
                  _buildStatColumn('Total', '15'),
                  _buildStatColumn('Today', '5'),
                  _buildStatColumn('This Week', '5'),
                  _buildStatColumn('This Month', '5'),
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
                        return PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: categoryColors['Plastic'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Metal'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Glass'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Cardboard'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Food scraps'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Organic yard'],
                                value: 10 * _animation.value,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: categoryColors['Other'],
                                value: 40 * _animation.value,
                                showTitle: false,
                              ),
                            ],
                          ),
                        );
                      })),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL', style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_isPointUnit ? '100 pt' : '50 pk',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Transform.translate(
                        offset: Offset(-10, 0), // 왼쪽으로 4픽셀 이동
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
          children: [
            _buildScoreDetail(categoryColors['Plastic']!, 'Plastic',
                _isPointUnit ? '10 pt' : '2 pk'),
            _buildScoreDetail(categoryColors['Metal']!, 'Metal',
                _isPointUnit ? '10 pt' : '2 pk'),
            _buildScoreDetail(categoryColors['Glass']!, 'Glass',
                _isPointUnit ? '10 pt' : '2 pk'),
            _buildScoreDetail(categoryColors['Cardboard']!, 'Cardboard',
                _isPointUnit ? '10 pt' : '2 pk'),
            _buildScoreDetail(categoryColors['Food scraps']!, 'Food scraps',
                _isPointUnit ? '10 pt' : '2 pk'),
            _buildScoreDetail(categoryColors['Organic yard']!, 'Organic yard',
                _isPointUnit ? '10 pt' : '2 pk'),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: _buildScoreDetail(categoryColors['Other']!, 'Other',
              _isPointUnit ? '40 pt' : '8 pk'),
        ),
      ],
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
        if (label != 'Other') Spacer() else SizedBox(width: 8),
        Text(points, style: bodyTextStyle()),
      ],
    );
  }
}
