import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import 'package:camera/camera.dart';
import '../screens/user_info_screen.dart';
import '../screens/newsletter_screen.dart';

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
        // page = Map();
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
                backgroundColor: Colors.black,
                selectedItemColor: Colors.greenAccent,
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'HomePage',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article),
                    label: 'Newsletter',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt),
                    label: 'Take Picture',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'User Information',
                  ),
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
