import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_screen_wrapper.dart'; // Import wrapper to simulating state change if needed, though we navigate to dashboard normally

class VisaGoalSelectionScreen extends StatelessWidget {
  final Function(String) onGoalSelected;

  const VisaGoalSelectionScreen({
    super.key,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '어떤 미래를\n꿈꾸시나요?',
              style: GoogleFonts.notoSansKr(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: const Color(0xFF1E2B4D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '나중에 언제든 변경할 수 있으니 편하게 선택하세요! 🔄',
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildGoalCard(
                  context,
                  title: '취업형',
                  subtitle: '졸업 후 한국 기업 취업\n(E-7 비자)',
                  icon: Icons.business_center_outlined,
                  color: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1976D2),
                  goalKey: 'job',
                ),
                _buildGoalCard(
                  context,
                  title: '연구형',
                  subtitle: '대학원 진학 & 영주권\n(F-2-7 비자)',
                  icon: Icons.school_outlined,
                  color: const Color(0xFFF3E5F5),
                  iconColor: const Color(0xFF7B1FA2),
                  goalKey: 'residency',
                ),
                _buildGoalCard(
                  context,
                  title: '창업형',
                  subtitle: '나만의 스타트업 시작\n(D-8-4 비자)',
                  icon: Icons.rocket_launch_outlined,
                  color: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFE65100),
                  goalKey: 'startup',
                ),
                _buildGoalCard(
                  context,
                  title: '글로벌형',
                  subtitle: '학위 취득 후\n본국/해외 진출',
                  icon: Icons.public,
                  color: const Color(0xFFE0F2F1),
                  iconColor: const Color(0xFF00796B),
                  goalKey: 'global',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildNoviceCard(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String goalKey,
  }) {
    return GestureDetector(
      onTap: () => onGoalSelected(goalKey),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.notoSansKr(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E2B4D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.notoSansKr(
                fontSize: 12,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoviceCard(BuildContext context) {
    return GestureDetector(
      onTap: () => onGoalSelected('novice'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.psychology_alt, color: Colors.grey, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '아직 탐색 중이에요 🌱',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '일단 학교 생활과 비자 유지에 집중할래요',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
