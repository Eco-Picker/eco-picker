import 'package:flutter/material.dart';

Widget buildRankImage(String rank, int page) {
  String imagePath;

  switch (rank) {
    case 'Bronze':
      imagePath = 'assets/images/Bronze.png';
      break;
    case 'Silver':
      imagePath = 'assets/images/Silver.png';
      break;
    case 'Gold':
      imagePath = 'assets/images/Gold.png';
      break;
    case 'Diamond':
      imagePath = 'assets/images/Diamond.png';
      break;
    case 'Master':
      imagePath = 'assets/images/Master.png';
      break;
    default:
      imagePath = 'assets/images/Icon.png';
  }

  return page == 1
      ? Image.asset(
          imagePath,
          width: 50,
          height: 50,
        )
      : Image.asset(
          imagePath,
          width: 25,
          height: 25,
        );
}
