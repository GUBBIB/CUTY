import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'providers/f27_visa_provider.dart';
import 'providers/visa_provider.dart';
import 'providers/locale_provider.dart';
import 'services/local_storage_service.dart';

import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'config/theme.dart';
import 'screens/auth/login_screen.dart'; // 로그인 스크린 임포트 추가
import 'screens/visa/startup_visa_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await LocalStorageService().init();

  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(393, 852),
      minimumSize: Size(393, 852),
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
    RestartWidget(
      child: ProviderScope(
        child: p.MultiProvider(
          providers: [
            p.ChangeNotifierProvider(create: (_) => VisaScoreProvider()),
            p.ChangeNotifierProvider(create: (_) => VisaProvider()),
          ],
          child: const CutyApp(),
        ),
      ),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});
  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class CutyApp extends ConsumerWidget {
  const CutyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'CUTY',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // 초기 화면을 LoginScreen으로 변경
      routes: {
        '/visa/startup': (context) => const StartupVisaScreen(),
      },
    );
  }
}
