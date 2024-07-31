import 'package:flutter/material.dart';
import '../data/newsletter.dart';
import '../api/api_newsletter_service.dart';

class PostList extends StatefulWidget {
  final List<NewsSummary> newsList;
  final bool isPaging;

  PostList({required this.newsList, this.isPaging = true});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final List<NewsSummary> _newsList = [];
  int _offset = 0;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  late ApiNewsletterService _apiNewsletterService;

  @override
  void initState() {
    super.initState();
    _newsList.addAll(widget.newsList);
    _apiNewsletterService = ApiNewsletterService();
    if (widget.isPaging) {
      _fetchNews();
    }
  }

  Future<void> _fetchNews() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newsList = await _apiNewsletterService.fetchNewsList(
          offset: _offset, limit: _limit);
      setState(() {
        // 중복된 데이터를 걸러냄
        for (var news in newsList.newsletters) {
          if (!_newsList.contains(news)) {
            _newsList.add(news);
          }
        }
        _offset += _limit;
        _hasMore = newsList.newsletters.length == _limit;
      });
    } catch (e) {
      // Handle error
      print('Failed to load news: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !_isLoading) {
          if (widget.isPaging) {
            _fetchNews();
          }
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _newsList.length + (widget.isPaging && _hasMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == _newsList.length) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _newsList[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(_newsList[index].summary),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
