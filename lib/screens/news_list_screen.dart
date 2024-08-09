import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_newsletter_service.dart';
import '../data/newsletter.dart';
import '../components/post_list.dart';
import '../main.dart';
import '../utils/toastbox.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<NewsSummary> _newsList = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  late TabController _tabController;
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'NEWS',
    'EVENT',
    'EDUCATION',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _selectedCategory = _categories[_tabController.index];
        _resetNewsList();
        _fetchNews(category: _selectedCategory);
      }
    });

    _fetchNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchNews(category: _selectedCategory);
      }
    });
  }

  void _resetNewsList() {
    setState(() {
      _newsList.clear();
      _currentPage = 0;
      _hasMore = true;
    });
  }

  Future<void> _fetchNews({String category = 'ALL'}) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newsList = await ApiNewsletterService().fetchNewsList(
        offset: _currentPage * 10,
        limit: 10,
        category: category == 'ALL' ? null : category,
      );

      setState(() {
        _currentPage++;
        _newsList.addAll(newsList.newsletterList);
        _hasMore = _currentPage < newsList.totalPages;
      });
    } catch (e) {
      if (e == 'LOG_OUT') {
        showToast('User token expired. Logging out.', 'error');
        final appState = Provider.of<MyAppState>(context, listen: false);
        appState.signOut(context);
      } else {
        showToast('Error fetching newslist: $e', 'error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Letter'),
        titleTextStyle: headingTextStyle(),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories
              .map((category) => Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(category),
                    ),
                  ))
              .toList(),
          indicatorColor: Color(0xFFE3F5E3),
          labelColor: Color(0xFFE3F5E3),
          unselectedLabelColor: Color(0xFFE5E5E5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _newsList.isEmpty && !_isLoading
                ? Center(child: Text('No news available'))
                : PostList(
                    newsList: _newsList,
                    scrollController: _scrollController,
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ),
        ],
      ),
    );
  }
}
