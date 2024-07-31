import 'package:flutter/material.dart';
import '../data/ranking.dart';

class Leaderboard extends StatelessWidget {
  final Future<Ranking> rankingFuture;
  int? _selectedIndex;
  Leaderboard({required this.rankingFuture});

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
                onTap: () {
                  _selectedIndex = index;
                },
                leading: Text(
                  '1',
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
