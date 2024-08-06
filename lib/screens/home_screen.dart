import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/rankingboard.dart';
import '../main.dart';
import '../components/random_newsbox.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('EcoPicker'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help),
            color: Color(0xFF27542A),
            tooltip: 'Show Guide',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                      // insert guide in the future
                      );
                },
              ));
            },
          ),
        ],
        titleTextStyle: headingTextStyle(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userProvider.isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  )
                else if (userProvider.user == null)
                  Text(
                    'Hello,\nThanks for saving Earth!',
                    style: midTextStyle(),
                  )
                else
                  Text(
                    'Hello, ${userProvider.user!.username}!\nThanks for saving Earth!',
                    style: midTextStyle(),
                  ),
                SizedBox(height: 10.0),
                RandomNewsbox(),
              ],
            ),
          ),
          Rankingboard(),
        ],
      ),
    );
  }
}
