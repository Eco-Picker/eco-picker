import 'package:flutter/material.dart';
import '../data/newsletter.dart';
import '../utils/styles.dart';
import '../screens/news_detail_screen.dart';

class PostList extends StatelessWidget {
  final List<NewsSummary> newsList;
  final ScrollController scrollController;

  PostList({required this.newsList, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                news.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                news.summary,
                style: greyTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                      id: news.id,
                      category: news.category,
                    ),
                  ),
                );
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
