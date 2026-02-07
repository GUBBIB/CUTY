import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/gen/app_localizations.dart';

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
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.store), label: AppLocalizations.of(context)!.tabShop),
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.tabHome),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppLocalizations.of(context)!.tabMy),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        // [UX Fix] Home 탭(Index 1) 클릭 시 네비게이션 스택 초기화 (First Route까지 Pop)
        if (index == 1) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        // Logic: If tapping 'Home' (1) while already on 'Home' (1), reset view to dashboard
        if (index == 1 && currentIndex == 1) {
           ref.read(homeViewProvider.notifier).state = 'dashboard';
        }
        
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
    );
  }
}
