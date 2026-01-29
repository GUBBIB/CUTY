import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nav_provider.dart';
import 'home/home_screen.dart';
import 'mypage/my_page_screen.dart';
import 'home/widgets/home_bottom_nav_bar.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          Center(child: Text('상점 (준비중)')), // Shop as placeholder
          HomeScreen(),       // Home Tab (Logic inside will handle JobView)
          MyPageScreen(),     // My Page
        ],
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );

  }
}
