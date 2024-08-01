import 'package:flutter/material.dart';
import 'package:eco_picker/components/post_list.dart';
import 'package:eco_picker/data/newsletter.dart';

class PostSearchDelegate extends SearchDelegate {
  PostSearchDelegate({required this.newsFuture});
  final Future<NewsList> newsFuture;

  List<NewsSummary> results = <NewsSummary>[];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        elevation: Theme.of(context).appBarTheme.elevation,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query.isEmpty ? close(context, null) : query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<NewsList>(
      future: newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.newsletterList.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          results = snapshot.data!.newsletterList
              .where((news) => news.title.contains(query))
              .toList();
          return PostList(newsList: results, isPaging: false);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<NewsList>(
      future: newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.newsletterList.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final suggestions = snapshot.data!.newsletterList
              .where((news) => news.title.contains(query))
              .toList();
          return PostList(newsList: suggestions, isPaging: false);
        }
      },
    );
  }
}
