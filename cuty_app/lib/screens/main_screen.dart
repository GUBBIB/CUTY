import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nav_provider.dart';
import 'home/home_screen.dart';
import 'mypage/my_page_screen.dart';
import 'home/widgets/home_bottom_nav_bar.dart';
import 'shop/shop_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return WillPopScope(
      onWillPop: () async {
        // 1. If current tab is NOT Home (Index 1) -> Go to Home
        if (currentIndex != 1) {
          ref.read(bottomNavIndexProvider.notifier).state = 1; // 1 = Home
          return false; // Prevent app exit
        }

        // 2. If current tab IS Home (Index 1) -> Confirm Exit
        final now = DateTime.now();
        if (currentBackPressTime == null || 
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한 번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            ShopScreen(),       // Shop Tab (0)
            HomeScreen(),       // Home Tab (1)
            MyPageScreen(),     // My Page (2)
          ],
        ),
        bottomNavigationBar: const HomeBottomNavBar(),
      ),
    );
  }
}
