import 'package:eco_picker/api/api_newsletter_service.dart';
import 'package:eco_picker/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';
import '../data/newsletter.dart';
import '../screens/news_list_screen.dart';
import '../utils/styles.dart';

class RandomNewsbox extends StatefulWidget {
  @override
  _RandomNewsboxState createState() => _RandomNewsboxState();
}

class _RandomNewsboxState extends State<RandomNewsbox> {
  final ApiNewsletterService _apiNewsletterService = ApiNewsletterService();
  late Future<NewsSummary> _randomNewsFuture;

  @override
  void initState() {
    super.initState();
    _randomNewsFuture = _apiNewsletterService.fetchRandomNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NewsSummary>(
      future: _randomNewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text('Error loading data'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.category.isEmpty) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text('No data available'),
            ),
          );
        } else {
          final newsSummary = snapshot.data;
          return GestureDetector(
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
                    newsSummary!.category,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27542A),
                    ),
                  ),
                  Text(
                    newsSummary.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    newsSummary.summary,
                    style: greyTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                          id: newsSummary.id,
                          category: newsSummary.category,
                        )),
              );
            },
          );
        }
      },
    );
  }
}
