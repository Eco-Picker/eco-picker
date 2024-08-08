import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFE3F5E3),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Icon.png', height: 200),
            Text('Eco Picker',
                style: GoogleFonts.quicksand(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF27542A),
                )),
          ],
        )),
      ),
    );
  }
}
