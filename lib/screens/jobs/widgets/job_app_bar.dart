import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../providers/home_view_provider.dart';

class JobAppBar extends ConsumerWidget {
  const JobAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Back Logic
                  ref.read(homeViewProvider.notifier).state = 'dashboard';
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                color: const Color(0xFF1E2B4D),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                'CUTY', // Logo
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                color: const Color(0xFF1E2B4D),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, size: 28),
                color: const Color(0xFF1E2B4D),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
