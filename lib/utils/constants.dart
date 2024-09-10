import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final categories = [
  'Display All',
  'Plastic',
  'Metal',
  'Glass',
  'Cardboard',
  'Food scraps',
  'Other'
];

const List<String> categoriesReverse = [
  '',
  'OTHER',
  'FOOD_SCRAPS',
  'CARDBOARD_PAPER',
  'GLASS',
  'METAL',
  'PLASTIC'
];
const Map<String, Color> categoryColors = {
  'Plastic': Color(0xFF0288D1),
  'Metal': Color(0xFF4FC3F7),
  'Glass': Color(0xFFB3E5FC),
  'Cardboard': Color(0xFF66BB6A),
  'Food scraps': Color(0xFF4CAF50),
  'Other': Color(0xFFC8E6C9),
};

const Map<String, String> categoryENUM = {
  'Plastic': 'PLASTIC',
  'Metal': 'METAL',
  'Glass': 'GLASS',
  'Cardboard': 'CARDBOARD_PAPER',
  'Food scraps': 'FOOD_SCRAPS',
  'Other': 'OTHER',
};

const Map<String, String> categoryIcons = {
  'Plastic': 'assets/images/PLASTIC.png',
  'Metal': 'assets/images/METAL.png',
  'Glass': 'assets/images/GLASS.png',
  'Cardboard': 'assets/images/CARDBOARD_PAPER.png',
  'Food scraps': 'assets/images/FOOD_SCRAPS.png',
  'Other': 'assets/images/OTHER.png',
};

final ip = dotenv.env['IP_ADDRESS'];
// const String baseUrl = 'http://localhost:15000/api';
// const String baseUrl = 'http://10.0.0.66:15000/api';
String baseUrl = 'http://$ip:15000/api';
// const String baseUrl = 'https://eco-picker.com/api';
