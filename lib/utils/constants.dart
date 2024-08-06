import 'package:flutter/material.dart';

// Define category-specific colors with more distinct variations
const Map<String, Color> categoryColors = {
  'Plastic': Color(0xFF0288D1),
  'Metal': Color(0xFF4FC3F7),
  'Glass': Color(0xFFB3E5FC),
  'Cardboard': Color(0xFF66BB6A),
  'Food scraps': Color(0xFF4CAF50),
  'Organic yard': Color(0xFF388E3C),
  'Other': Color(0xFFC8E6C9),
};

const Map<String, String> categoryENUM = {
  'Plastic': 'PLASTIC',
  'Metal': 'METAL',
  'Glass': 'GLASS',
  'Cardboard': 'CARDBOARD_PAPER',
  'Food scraps': 'FOOD_SCRAPS',
  'Organic yard': 'ORGANIC_YARD_WASTE',
  'Other': 'OTHER',
};

const Map<String, String> categoryIcons = {
  'Plastic': 'assets/images/PLASTIC.png',
  'Metal': 'assets/images/METAL.png',
  'Glass': 'assets/images/GLASS.png',
  'Cardboard': 'assets/images/CARDBOARD_PAPER.png',
  'Food scraps': 'assets/images/FOOD_SCRAPS.png',
  'Organic yard': 'assets/images/ORGANIC_YARD_WASTE.png',
  'Other': 'assets/images/OTHER.png',
};

// const String baseUrl = 'http://localhost:15000/api';
const String baseUrl = 'http://10.0.0.66:15000/api';
// const String baseUrl = 'http://127.0.0.1:15000/api';
// const String baseUrl = 'http://eco-picker.com:15000/api';