import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import 'package:camera/camera.dart';
import '../screens/user_info_screen.dart';
import '../screens/newsletter_screen.dart';
import '../screens/map_screen.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Map> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MyHomePage();
        break;
      case 1:
        page = NewsPage();
        break;
      case 2:
        //page = TakePicturePage();
        page = TakePicturePage();
        break;
      case 3:
        page = Placeholder();
        page = MapPage();
        break;
      case 4:
        page = UserInfoPage();
        // page = UserInfoPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var layoutBuilder = LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(child: page),
            SafeArea(
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Color(0xFFF5F5F5),
                elevation: 0,
                iconSize: 30,
                selectedItemColor: Color.fromARGB(255, 76, 175, 79),
                unselectedItemColor: Color.fromARGB(122, 76, 175, 79),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.article), label: "Newsletter"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.camera_alt), label: "Camera"),
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "User"),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
    return Scaffold(
      body: layoutBuilder,
    );
  }
}
