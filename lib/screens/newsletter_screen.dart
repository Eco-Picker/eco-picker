import 'package:flutter/material.dart';

import '../styles.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Letter'),
        titleTextStyle: headingTextStyle(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          NewsCard(
              title: 'Latest Issues',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LatestIssuesPage()),
                );
              }),
          NewsCard(
              title: 'Events',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              }),
          NewsCard(
              title: 'Educational Contents',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EducationalContentPage()),
                );
              }),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  NewsCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

class LatestIssuesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Issues'),
        titleTextStyle: headingTextStyle(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: List.generate(5, (index) {
          return NewsItemCard(
            title: 'Best Restaurants in Town',
            subtitle: 'Experience the most exquisite dining...',
            onTap: () {},
          );
        }),
      ),
    );
  }
}

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        titleTextStyle: headingTextStyle(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: List.generate(5, (index) {
          return NewsItemCard(
            title: 'Top Rated Hotels',
            subtitle: 'Enjoy luxury and comfort at these...',
            onTap: () {},
          );
        }),
      ),
    );
  }
}

class EducationalContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Educational Content'),
        titleTextStyle: headingTextStyle(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: List.generate(5, (index) {
          return NewsItemCard(
            title: 'Must-Visit Attractions',
            subtitle: 'Discover the best attractions and...',
            onTap: () {},
          );
        }),
      ),
    );
  }
}

class NewsItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  NewsItemCard(
      {required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
