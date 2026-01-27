import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CutyApp(),
    ),
  );
}

class CutyApp extends StatelessWidget {
  const CutyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUTY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      ),
      home: const HomeScreen(),
    );
  }
}
