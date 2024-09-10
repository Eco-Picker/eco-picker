import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/user_dashboard_screen.dart';
import '../screens/news_list_screen.dart';
import '../screens/map_screen.dart';

class MainBar extends StatefulWidget {
  final int? index;

  const MainBar({this.index});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int selectedIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    // Initialize the selectedIndex based on the widget's index parameter
    selectedIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomeScreen();
      case 1:
        page = NewsListScreen();
      case 2:
        page = CameraScreen();
      case 3:
        page = MapScreen();
      case 4:
        page = UserDashboardScreen();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFF5F5F5),
        iconSize: 30,
        selectedItemColor: Color.fromARGB(255, 76, 175, 79),
        unselectedItemColor: Color.fromARGB(122, 76, 175, 79),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: "Newsletter"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
