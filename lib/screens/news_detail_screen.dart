import 'package:eco_picker/utils/change_date_format.dart';
import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_newsletter_service.dart';
import '../data/newsletter.dart';
import '../main.dart';
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

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      _newsletterFuture = _apiNewsletterService.fetchNewsletter(widget.id);
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
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            Newsletter? newsletter = snapshot.data;
            if (newsletter != null && newsletter.title.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsletter.title,
                      style: newsTitleTextStyle(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Published at: ${changeDateFormat(newsletter.publishedAt ?? '')}',
                      style: newsGreyTextStyle(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      newsletter.content,
                      style: newsBodyTextStyle(),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _launchURL(newsletter.source),
                      child: Text(
                        'Source: ${newsletter.source}',
                        style: newsGreyTextStyle().copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.share(
                              'Check out this article from Eco Picker!: ${newsletter.source}');
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
