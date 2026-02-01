import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/nav_provider.dart';
import '../../../../providers/home_view_provider.dart';

class HomeBottomNavBar extends ConsumerWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E2B4D),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        // Logic: If tapping 'Home' (1) while already on 'Home' (1), reset view to dashboard
        if (index == 1 && currentIndex == 1) {
           ref.read(homeViewProvider.notifier).state = 'dashboard';
        }
        
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
    );
  }
}
