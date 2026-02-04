import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_view_provider.dart';
import '../../visa/visa_screen_wrapper.dart';
import '../../spec/spec_wallet_screen.dart';
import '../../academic/academic_main_screen.dart';
import '../../schedule/schedule_screen.dart';
import '../../community/community_main_screen.dart';


class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Define menu items
    final List<Map<String, dynamic>> menuItems = [
      {
        'label': '비자',
        'icon': Icons.public_outlined,
        'bg': const Color(0xFFE1F5FE), // Light Blue
        'iconColor': const Color(0xFF0277BD), // Deep Blue
      },
      {
        'label': '커뮤니티',
        'icon': Icons.chat_bubble_outline_rounded,
        'bg': const Color(0xFFE1F5FE), // Same as Visa (Primary Blue Light)
        'iconColor': const Color(0xFF0277BD), // Same as Visa (Primary Blue Deep)
      },
      {
        'label': '서류지갑',
        'icon': Icons.wallet_outlined,
        'bg': const Color(0xFFFFF9C4), // Light Yellow
        'iconColor': const Color(0xFFF57F17), // Deep Yellow/Orange
      },
      {
        'label': '알바/취업',
        'icon': Icons.work_outline,
        'bg': const Color(0xFFE0F2F1), // Light Mint
        'iconColor': const Color(0xFF00695C), // Deep Teal
      },
      {
        'label': '시간표',
        'icon': Icons.calendar_today_outlined,
        'bg': const Color(0xFFE3F2FD), // Light Blue
        'iconColor': const Color(0xFF1565C0), // Deep Blue
      },
      {
        'label': '학사정보',
        'icon': Icons.school_outlined,
        'bg': const Color(0xFFF3E5F5), // Light Purple
        'iconColor': const Color(0xFF6A1B9A), // Deep Purple
        'isPreparing': true,
      },
      {
        'label': '맛집',
        'icon': Icons.restaurant_menu,
        'bg': const Color(0xFFFFE0B2), // Light Orange
        'iconColor': const Color(0xFFEF6C00), // Deep Orange
        'isPreparing': true,
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20), // Increased padding
      child: Row(
        children: [
          for (int i = 0; i < menuItems.length; i++) ...[
            _MenuCard(
              icon: menuItems[i]['icon'] as IconData,
              label: menuItems[i]['label'] as String,
              backgroundColor: menuItems[i]['bg'] as Color,
              iconColor: menuItems[i]['iconColor'] as Color,
              isPreparing: menuItems[i]['isPreparing'] ?? false,
            ),
            if (i < menuItems.length - 1) const SizedBox(width: 16), // Increased spacing
          ],
        ],
      ),
    );
  }
}


class _MenuCard extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final bool isPreparing;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    this.isPreparing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 72, // Increased from 60
      height: 90, // Increased from 74
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: isPreparing
              ? null
              : () {
                  debugPrint('$label 메뉴 클릭됨');
                  switch (label) {
                    case '비자':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VisaScreenWrapper()),
                      );
                      break;
                    case '서류지갑':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpecWalletScreen()),
                      );
                      break;
                    case '알바/취업':
                      ref.read(homeViewProvider.notifier).state = 'job';
                      break;
                    case '학사정보':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AcademicMainScreen()),
                      );
                      break;
                    case '시간표':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScheduleScreen()),
                      );
                      break;
                    case '커뮤니티':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CommunityMainScreen()),
                      );
                      break;
                    case '맛집':
                      // Matjib no screen request, keeping log
                      break;
                  }
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48, // Increased from 38
                      height: 40, // Increased from 34
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: iconColor, size: 24), // Increased size
                    ),
                    const SizedBox(height: 6), // Increased spacing
                    Text(
                      label,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 12, // Increased from 10
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isPreparing)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "준비중",
                      style: GoogleFonts.notoSansKr(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

