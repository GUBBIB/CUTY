import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CUTY',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        IconButton(
          onPressed: () {
            debugPrint('알림 클릭됨');
          },
          icon: const Icon(
            Icons.notifications_none,
            size: 32,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
