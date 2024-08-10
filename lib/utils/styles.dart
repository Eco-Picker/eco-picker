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

ButtonStyle smallButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4CAF50),
    foregroundColor: Colors.white,
    minimumSize: const Size(180, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

ButtonStyle greyButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFA3A3A3),
    foregroundColor: Colors.white,
    minimumSize: const Size(180, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

InputDecoration inputStyle(
    String label, GlobalKey<FormState> formKey, bool showErr, bool formError) {
  return InputDecoration(
    labelText: label,
    floatingLabelStyle: TextStyle(
      color: (showErr && formError) ? Colors.red : Color(0xFF27542A),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4CAF50)),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );
}

TextStyle onboardingTextStyle() {
  return GoogleFonts.quicksand(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: Color(0xFF27542A),
  );
}

TextStyle headingTextStyle() {
  return GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF27542A),
  );
}

TextStyle headingWhiteTextStyle() {
  return GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFAFAFA),
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

TextStyle titleNormalTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle titleWhiteTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFAFAFA),
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

TextStyle midGreenTextStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF27542A),
  );
}

TextStyle newsTitleTextStyle() {
  return const TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3D3D3D),
  );
}

TextStyle newsGreyTextStyle() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Color(0xFFA3A3A3),
  );
}

TextStyle newsBodyTextStyle() {
  return const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Color(0xFF3D3D3D),
      height: 1.5);
}
