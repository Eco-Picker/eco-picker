import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Dummy data for demonstration
  int userTodayCount = 5;
  int userWeekCount = 20;
  int userMonthCount = 75;

  int totalTodayCount = 200;
  int totalWeekCount = 1000;
  int totalMonthCount = 4000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoPicker Home'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // News ad
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'News Ad (Tip: Plastic Straws can kill turtles and other marine life)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),

            // User's trash collection stats
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Trash Collection Stats:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Today: $userTodayCount items'),
                  Text('This Week: $userWeekCount items'),
                  Text('This Month: $userMonthCount items'),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Total trash collection stats
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Trash Collection Stats:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Today: $totalTodayCount items'),
                  Text('This Week: $totalWeekCount items'),
                  Text('This Month: $totalMonthCount items'),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Challenge stats
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Challenges:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text('Daily Challenge: Collect 100 items'),
                  Text('Weekly Challenge: Collect 500 items'),
                  Text('Monthly Challenge: Collect 2000 items'),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Today's top collector
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Top Collector:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text('1. User123 - 30 items'),
                  // Add more ranks as needed
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Buttons for navigation
            ElevatedButton(
              onPressed: () {
                // Navigate to trash handling information
              },
              child: Text('Go to Trash Handling Information'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to environment news and events
              },
              child: Text('Go to Environment News and Events'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to educational content
              },
              child: Text('Go to Educational Content'),
            ),
          ],
        ),
      ),
    );
  }
}
