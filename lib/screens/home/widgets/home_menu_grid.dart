import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_view_provider.dart';

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
        'label': '학사정보',
        'icon': Icons.school_outlined,
        'bg': const Color(0xFFF3E5F5), // Light Purple
        'iconColor': const Color(0xFF6A1B9A), // Deep Purple
      },
      {
        'label': '맛집',
        'icon': Icons.restaurant_menu,
        'bg': const Color(0xFFFFE0B2), // Light Orange
        'iconColor': const Color(0xFFEF6C00), // Deep Orange
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12), // Removed bottom padding
      child: Row(
        children: [
          for (int i = 0; i < menuItems.length; i++) ...[
            _MenuCard(
              icon: menuItems[i]['icon'] as IconData,
              label: menuItems[i]['label'] as String,
              backgroundColor: menuItems[i]['bg'] as Color,
              iconColor: menuItems[i]['iconColor'] as Color,
            ),
            if (i < menuItems.length - 1) const SizedBox(width: 12),
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

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 72,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            debugPrint('$label 메뉴 클릭됨');
            if (label == '알바/취업') {
              ref.read(homeViewProvider.notifier).state = 'job'; // Switch view in Home
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48, // Adjusted width to fit smoothly within 72 - 16 padding
                  height: 40, // Height matching design feel
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 4), // Tight spacing
                Text(
                  label,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 11, // Slightly smaller for compact feel
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E), // Dark Navy
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
