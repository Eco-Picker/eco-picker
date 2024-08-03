import 'package:flutter/material.dart';

import '../utils/styles.dart';

class Scoreboard extends StatefulWidget {
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.10).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Eco Rank', style: titleTextStyle()),
            Text('100 pt', style: titleTextStyle())
          ],
        ),
        Text('Collect points to be a master player!'),
        SizedBox(
          height: 8,
        ),
        // Progress Bar
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _animation.value,
              backgroundColor: Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              minHeight: 10,
            );
          },
        ),
        const SizedBox(height: 4),
        // Steps with numbers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStepIndicator('0'),
            _buildStepIndicator('250'),
            _buildStepIndicator('500'),
            _buildStepIndicator('750'),
            _buildStepIndicator('1000'),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator(String number) {
    return Column(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: Color(0xFF4CAF50),
        ),
        const SizedBox(height: 4),
        Text(
          number,
          style: TextStyle(
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
