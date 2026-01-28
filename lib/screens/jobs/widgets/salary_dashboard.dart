import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for clock icon

class SalaryDashboard extends StatelessWidget {
  const SalaryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###");

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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.softMint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '기록하기',
                    style: TextStyle(
                      color: AppTheme.darkGreen,
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
            color: Color(0xFFDEDCBA), // Beige-ish clock but icon color usually solid. 
            // Mockup shows filled circle with clock face. 
            // Using Icon might not match exactly if we want the background circle.
            // Let's use Stack with Icon if needed or just Icon.
            // Directive says: "use cupertino_icons of clock or time, and place it large."
            // Simple approach: Large Icon.
          ),
        ],
      ),
    );
  }
}
