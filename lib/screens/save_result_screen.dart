import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/navigation_bar.dart';
import '../data/garbage.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';

class SaveResultScreen extends StatefulWidget {
  final Garbage garbageResult;

  SaveResultScreen({required this.garbageResult});

  @override
  _SaveResultScreenState createState() => _SaveResultScreenState();
}

class _SaveResultScreenState extends State<SaveResultScreen> {
  bool isPlaying = false;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  void _goto(int index) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainBar(index: index)),
        (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Image saved!', style: onboardingTextStyle()),
                Text(
                    '+ ${categoriesReverse.indexOf(widget.garbageResult.category).toString()}',
                    style: GoogleFonts.quicksand(
                      fontSize: 100,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF27542A),
                    )),
                Text('Points earned', style: newsTitleTextStyle()),
                // ElevatedButton(
                //   onPressed: () => _goto(2),
                //   style: smallButtonStyle(),
                //   child: Text('Take another picture'),
                // ),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainBar(index: 3),
                      ),
                      (route) => false,
                    )
                  },
                  style: smallButtonStyle(),
                  child: Text('Go to map'),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
        )
      ]),
    );
  }
}
