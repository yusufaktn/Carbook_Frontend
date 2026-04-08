import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF19DB8A)),
      useMaterial3: true,
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF14181B),
        ),
        titleLarge: GoogleFonts.readexPro(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF14181B),
        ),
        bodyMedium: GoogleFonts.readexPro(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF57636C),
        ),
      ),
    );
  }
}

class AppTextStyles {
  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF14181B),
    );
  }

  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.readexPro(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF14181B),
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.readexPro(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF57636C),
    );
  }

  static TextStyle bodyMediumWhite(BuildContext context) {
    return GoogleFonts.readexPro(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }

  static TextStyle bodyMediumPrimary(BuildContext context) {
    return GoogleFonts.readexPro(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF19DB8A),
    );
  }
}
