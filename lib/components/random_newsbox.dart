import 'package:eco_picker/api/api_newsletter_service.dart';
import 'package:eco_picker/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/newsletter.dart';
import '../main.dart';
import '../utils/styles.dart';
import '../utils/toastbox.dart';

class RandomNewsbox extends StatefulWidget {
  final Function onLoadingComplete;

  RandomNewsbox({required this.onLoadingComplete});

  @override
  State<RandomNewsbox> createState() => _RandomNewsboxState();
}

class _RandomNewsboxState extends State<RandomNewsbox> {
  final ApiNewsletterService _apiNewsletterService = ApiNewsletterService();
  late Future<NewsSummary> _randomNewsFuture;

  @override
  void initState() {
    super.initState();
    try {
      _randomNewsFuture = _apiNewsletterService.fetchRandomNews();
    } catch (e) {
      if (e == 'LOG_OUT') {
        showToast('User token expired. Logging out.', 'error');
        final appState = Provider.of<MyAppState>(context, listen: false);
        appState.signOut(context);
      } else {
        showToast('Error analyzing garbage: $e', 'error');
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadingComplete();
      });
    }
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
              child: Text('Error loading data'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.category.isEmpty) {
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
              child: Text('No data available'),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onLoadingComplete();
          });

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
                    style: midGreenTextStyle(),
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
