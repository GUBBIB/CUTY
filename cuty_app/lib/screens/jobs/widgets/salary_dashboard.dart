import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for clock icon

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/job_providers.dart';

class SalaryDashboard extends ConsumerWidget {
  const SalaryDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat("#,###");
    final theme = ref.watch(jobThemeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '예상 월급',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${currencyFormat.format(1200000)}원',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              InkWell(
                onTap: () {
                  debugPrint('기록하기 Click!');
                },
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.secondaryColor.withValues(alpha: 0.2), // Light background based on secondary
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '기록하기',
                    style: TextStyle(
                      color: theme.primaryColor, // Text matches primary
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Clock Icon
          const Icon(
            CupertinoIcons.time,
            size: 80,
            color: Color(0xFFDEDCBA), 
          ),
        ],
      ),
    );
  }
}
