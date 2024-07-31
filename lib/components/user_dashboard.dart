import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/styles.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (userProvider.isLoading)
          Center(child: CircularProgressIndicator())
        else if (userProvider.user == null)
          Text(
            'Hello!',
            style: MidTextStyle(),
          )
        else
          Text(
            '${userProvider.user!.username}\'s dashboard',
            style: MidTextStyle(),
          ),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: [
            _buildStatColumn('Total', '15', 'Garbages'),
            _buildStatColumn('Today', '5', 'Garbages'),
            _buildStatColumn('This Week', '5', 'Garbages'),
            _buildStatColumn('This Month', '5', 'Garbages'),
          ],
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
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green[200],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.green[400],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.yellow[200],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.green[100],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.green[700],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.yellow[100],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.grey[200],
                        value: 40,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: const [
                  Text('TOTAL', style: TextStyle(color: Colors.grey)),
                  Text('100 point',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
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
            _buildScoreDetail(Colors.green[200]!, 'Plastic', '10 pt'),
            _buildScoreDetail(Colors.green[400]!, 'Metal', '10 pt'),
            _buildScoreDetail(Colors.yellow[200]!, 'Glass', '10 pt'),
            _buildScoreDetail(Colors.green[100]!, 'Cardboard', '10 pt'),
            _buildScoreDetail(Colors.green[700]!, 'Food scraps', '10 pt'),
            _buildScoreDetail(Colors.yellow[100]!, 'Organic yard', '10 pt'),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: _buildScoreDetail(Colors.grey[200]!, 'Other', '40 pt'),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String title, String count, String subtitle) {
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
          Text(subtitle, style: smallTextStyle()),
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
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label),
        if (label != 'Other') Spacer() else SizedBox(width: 8),
        Text(points),
      ],
    );
  }
}
