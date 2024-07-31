import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/styles.dart';
import '../utils/constants.dart';

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
        Text('Collected Garbages'),
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
                        color: categoryColors['Plastic'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Metal'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Glass'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Cardboard'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Food scraps'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Organic yard'],
                        value: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: categoryColors['Other'],
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            _buildScoreDetail(categoryColors['Plastic']!, 'Plastic', '10 pt'),
            _buildScoreDetail(categoryColors['Metal']!, 'Metal', '10 pt'),
            _buildScoreDetail(categoryColors['Glass']!, 'Glass', '10 pt'),
            _buildScoreDetail(
                categoryColors['Cardboard']!, 'Cardboard', '10 pt'),
            _buildScoreDetail(
                categoryColors['Food scraps']!, 'Food scraps', '10 pt'),
            _buildScoreDetail(
                categoryColors['Organic yard']!, 'Organic yard', '10 pt'),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: _buildScoreDetail(categoryColors['Other']!, 'Other', '40 pt'),
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
          // Text(subtitle, style: smallTextStyle()),
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
          color: categoryColors[label],
        ),
        SizedBox(width: 8),
        Text(label, style: bodyTextStyle()),
        if (label != 'Other') Spacer() else SizedBox(width: 8),
        Text(points, style: bodyTextStyle()),
      ],
    );
  }
}
