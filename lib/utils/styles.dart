import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle submitButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4CAF50),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

TextStyle headingTextStyle() {
  return GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF27542A),
  );
}

TextStyle bodyTextStyle() {
  return const TextStyle(
    fontSize: 14,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle selectTextStyle() {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF27542A),
  );
}

TextStyle bodyImportantTextStyle() {
  return const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle titleTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle greyTextStyle() {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFA3A3A3),
  );
}

TextStyle smallTextStyle() {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle midTextStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3D3D3D),
  );
}
