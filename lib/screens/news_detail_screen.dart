import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_newsletter_service.dart';
import '../data/newsletter.dart';
import '../utils/styles.dart';

class NewsDetailScreen extends StatefulWidget {
  final int id;
  final String category;

  const NewsDetailScreen({required this.id, required this.category});
  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late ApiNewsletterService _apiNewsletterService = ApiNewsletterService();
  late Future<Newsletter> _newsletterFuture;
  @override
  void initState() {
    super.initState();
    _newsletterFuture = _apiNewsletterService.fetchNewsletter(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        titleTextStyle: headingTextStyle(),
      ),
      body: FutureBuilder<Newsletter>(
        future: _newsletterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            );
          } else if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            if (snapshot.data!.title.isNotEmpty) {
              Newsletter newsletter = snapshot as Newsletter;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsletter.title,
                      style: midTextStyle(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Published at: ${DateFormat('yyyy.MM.dd').format(newsletter.publishedAt as DateTime)}',
                      style: greyTextStyle(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      newsletter.content,
                      style: bodyTextStyle(),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Source: ${newsletter.source}',
                        style: greyTextStyle(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.open_in_new),
                        onPressed: () {
                          // 클릭 시 다른 화면으로 이동하거나 웹 페이지 열기 등의 액션을 추가
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              showToast('No data available', 'error');
            }
          } else {
            showToast('No data available', 'error');
          }
          return Text('Not a valid newsletter.');
        },
      ),
    );
  }
}
