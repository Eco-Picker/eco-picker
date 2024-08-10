import 'package:eco_picker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthWrapper()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Color(0xFFE3F5E3),
      skipStyle: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 17)),
          foregroundColor: MaterialStateProperty.all(Color(0xFF27542A))),
      allowImplicitScrolling: true,
      autoScrollDuration: 300000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                textAlign: TextAlign.center,
                'Welcome to \nEco Picker!',
                style: onboardingTextStyle(),
              ),
              const SizedBox(height: 20),
              const Image(
                  image: AssetImage('assets/images/Icon.png'), width: 200),
              Text(
                textAlign: TextAlign.center,
                'Join us in making a difference.\n\n Track your trash-collecting efforts, \nAnalyze what you pick up, \nand Earn rewards for your contribution to a cleaner planet!',
                style: midTextStyle(),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: '',
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Identify and Score Trash',
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              const Image(
                image: AssetImage('assets/images/Onboarding1.png'),
              ),
              Text('Snap a Photo', style: midTextStyle()),
              Text(
                'Take a picture of the trash you collect \nusing the app.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text('Gemini API Analysis', style: midTextStyle()),
              Text(
                'Your photo is automatically analyzed \nto identify the type of trash.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Track Your Impact',
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              const Image(
                image: AssetImage('assets/images/Onboarding2.png'),
              ),
              Text('Collection History', style: midTextStyle()),
              Text(
                'Access your map to review all your past trash collection locations and details.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text('View Details', style: midTextStyle()),
              Text(
                'Tap on a marker to see detailed information about the trash collected at that spot.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Track Your Progress',
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              const Image(
                image: AssetImage('assets/images/Onboarding3.png'),
              ),
              Text('Check Your Dashboard', style: midTextStyle()),
              Text(
                'View your total collected items, points, and eco score.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Improve Your Rank', style: midTextStyle()),
              Text(
                'Increase your eco score to advance through ranks from Bronze to Master.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Climb the Rankings',
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              const Image(
                image: AssetImage('assets/images/Onboarding4.png'),
              ),
              Text('Leaderboard', style: midTextStyle()),
              Text(
                'Check the top 10 players on the leaderboard and see how they are doing.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Achieve and Compete', style: midTextStyle()),
              Text(
                'Compete with others, track your progress, and climb the ranks as you accumulate more points.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Stay Updated with Gemini',
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              const Image(
                image: AssetImage('assets/images/Onboarding5.png'),
              ),
              Text('Gemini Integration', style: midTextStyle()),
              Text(
                'Access weekly newsletters, events, and educational content through our integration with the Gemini API.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Stay Informed', style: midTextStyle()),
              Text(
                'Receive updates on environmental issues to stay motivated.',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Text(
                "Let's Get Started!",
                textAlign: TextAlign.center,
                style: onboardingTextStyle(),
              ),
              Text('Start Your Journey', style: midTextStyle()),
              Text(
                'Ready to make a difference? \nBegin your eco-friendly adventure now!',
                style: titleNormalTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      // onChange: (val) {},
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(
        Icons.arrow_forward,
      ),
      done: const Text('Done',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF27542A))),
      onDone: () => _onIntroEnd(context),
      nextStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Color(0xFF27542A))),
      dotsDecorator: const DotsDecorator(
        size: Size.square(10),
        activeColor: Color(0xFF27542A),
        activeSize: Size.square(17),
      ),
    );
  }
}
