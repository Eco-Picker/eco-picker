import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/user_dashboard_screen.dart';
import '../screens/news_list_screen.dart';
import '../screens/map_screen.dart';

class MainBar extends StatefulWidget {
  final CameraDescription? camera;

  const MainBar({required this.camera});

  @override
  State<MainBar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainBar> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = NewsListScreen();
        break;
      case 2:
        page = CameraScreen(camera: widget.camera);
        break;
      case 3:
        page = MapScreen();
        break;
      case 4:
        page = UserDashboardScreen();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: page,
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
