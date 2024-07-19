import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/user_info_screen.dart';
import '../screens/camera_screen.dart';
// import '../screens/map_screen.dart';
// import '../screens/newsletter_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = CameraScreen();
        break;
      case 2:
        // page = MapScreen();
        break;
      case 3:
        page = UserInfoScreen();
        break;
      case 4:
      // page = NewsLetterScreen();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      selectedLabelStyle: const TextStyle(
        color: Colors.green,
      ),
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(
        color: Colors.grey,
      ),
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Newsletter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Upload',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
