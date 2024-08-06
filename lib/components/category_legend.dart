import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/styles.dart';

class CategoryLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(157, 255, 255, 255),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryIcons.keys
              .map((category) => Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset(categoryIcons[category] ??
                                'assets/images/Icon.png'),
                          ),
                          const SizedBox(width: 8),
                          Text(category, style: bodyTextStyle()),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
