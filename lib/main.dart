import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'config/theme.dart';
import 'screens/main_screen.dart';

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
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
