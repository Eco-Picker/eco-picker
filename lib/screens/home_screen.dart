import 'package:eco_picker/screens/onboarding_screen.dart';
import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/rankingboard.dart';
import '../data/provider.dart';
import '../components/random_newsbox.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingNews = true;
  bool _isLoadingRanking = true;

  @override
  void initState() {
    super.initState();
  }

  void _handleNewsLoadingComplete() {
    setState(() {
      _isLoadingNews = false;
    });
  }

  void _handleRankingLoadingComplete() {
    setState(() {
      _isLoadingRanking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? userName = Provider.of<UserProvider>(context).userName;
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoPicker'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help),
            color: Color(0xFF27542A),
            tooltip: 'Show Guide',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
              );
            },
          ),
        ],
        titleTextStyle: headingTextStyle(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userName == null)
                      Text(
                        'Hello,\nThanks for saving Earth!',
                        style: midTextStyle(),
                      )
                    else
                      Text(
                        'Hello, $userName!\nThanks for saving Earth!',
                        style: midTextStyle(),
                      ),
                    SizedBox(height: 10.0),
                    RandomNewsbox(
                      onLoadingComplete: _handleNewsLoadingComplete,
                    ),
                  ],
                ),
              ),
              Rankingboard(
                onLoadingComplete: _handleRankingLoadingComplete,
              ),
            ],
          ),
          if (_isLoadingNews || _isLoadingRanking)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
