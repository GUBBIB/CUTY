import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'providers/f27_visa_provider.dart';
import 'services/local_storage_service.dart';


import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'config/theme.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 로컬 저장소 서비스 초기화 (반드시 runApp 전에 실행)
  await LocalStorageService().init();

  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(393, 852), // iPhone 15 Pro dimensions
      minimumSize: Size(393, 852), // Prevent resizing smaller
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: "CUTY Dev (iPhone 15 View)",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ProviderScope(
      child: p.MultiProvider(
        providers: [
          p.ChangeNotifierProvider(create: (_) => VisaScoreProvider()),
        ],
        child: const CutyApp(),
      ),
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
