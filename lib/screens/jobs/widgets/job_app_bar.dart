import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_view_provider.dart';
import '../providers/job_providers.dart';

class JobAppBar extends ConsumerWidget {
  const JobAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedJobCategoryProvider);
    final iconColor = category == 0 ? const Color(0xFF26A69A) : const Color(0xFF1A237E);

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
                color: iconColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                'CUTY', // Logo
                style: TextStyle(
                  fontFamily: 'Poppins', // Assuming font is available or fallback to default
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: iconColor,
                ),
              ),
            ],
          ),
          // Actions
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
