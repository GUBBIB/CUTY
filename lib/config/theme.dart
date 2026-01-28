import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E2B4D)),
    useMaterial3: true,
    // Apply global text style: Dark Navy color and heavier weights
    textTheme: GoogleFonts.notoSansKrTextTheme().apply(
      bodyColor: const Color(0xFF1A1A2E), 
      displayColor: const Color(0xFF1A1A2E),
    ).copyWith(
      bodyLarge: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      bodyMedium: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      bodySmall: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      titleSmall: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
    ),
  );

  // Custom Colors
  static const Color softMint = Color(0xFFE0F7FA);
  static const Color darkGreen = Color(0xFF006064);
  static const Color salaryCardBg = Color(0xFFF1F8E9); // Light Green for Salary Card
  static const Color primaryBlue = Color(0xFF1E88E5);
}
