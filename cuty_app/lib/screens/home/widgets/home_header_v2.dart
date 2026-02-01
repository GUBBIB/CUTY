import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/point_provider.dart';
import '../../wallet/my_point_screen.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch precise point value from PointProvider
    final pointState = ref.watch(pointProvider);
    final points = pointState.totalBalance;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Text(
          'CUTY',
          style: GoogleFonts.poppins(
            fontSize: 28, // Adjusted size
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),

        // Point Display & Notification
        Row(
          children: [
              GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const MyPointScreen()),
                 );
               },
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.05),
                       blurRadius: 4,
                       offset: const Offset(0, 2),
                     )
                   ],
                   border: Border.all(color: Colors.grey.shade200),
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const Text("💰"), 
                     const SizedBox(width: 4),
                     Text(
                       "$points P", 
                       style: GoogleFonts.notoSansKr(
                         fontSize: 13, 
                         fontWeight: FontWeight.bold,
                         color: const Color(0xFF1A1A2E),
                       )
                     ),
                   ],
                 ),
               ),
             ),
             const SizedBox(width: 12),
             
             // Notification Bell
             GestureDetector(
              onTap: () {
                debugPrint('알림 클릭됨');
              },
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
