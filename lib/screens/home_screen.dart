import 'package:eco_picker/components/navigation_bar.dart';
import 'package:eco_picker/screens/camera_screen.dart';
import 'package:flutter/material.dart';
// import 'package:eco_picker/components/buttons.dart';
// import 'package:eco_picker/components/maps.dart';
// import 'package:eco_picker/data/user.dart';
// import 'package:eco_picker/utils/location_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ),
            );
          },
          child: const Text('Upload Picture'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

void setState(Null Function() param0) {}
