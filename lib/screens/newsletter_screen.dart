import 'package:eco_picker/api/api_newsletter_service.dart';
import 'package:flutter/material.dart';
import '../components/post_list.dart';
import '../components/post_search.dart';
import '../data/newsletter.dart';
import '../utils/styles.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ApiNewsletterService _apiNewsletterService = ApiNewsletterService();
  late Future<NewsList> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _apiNewsletterService.fetchNewsList(
        offset: 0, limit: 10, category: "NEWS");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Letter'),
        titleTextStyle: headingTextStyle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: PostSearchDelegate(newsFuture: _newsFuture),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<NewsList>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else if (!snapshot.hasData ||
                snapshot.data!.newsletterList.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              return PostList(
                  newsList: snapshot.data!.newsletterList, isPaging: true);
            }
          },
        ),
      ),
    );
  }
}
