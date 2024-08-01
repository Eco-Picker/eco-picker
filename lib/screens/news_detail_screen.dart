import 'package:flutter/material.dart';

import '../utils/styles.dart';

class NewsDetailScreen extends StatefulWidget {
  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          titleTextStyle: headingTextStyle(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
        )
        // child: SingleChildScrollView(child: Column,),)
        );
  }
}
