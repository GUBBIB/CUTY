import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/f27_visa_provider.dart';
import 'f27_visa_calculator_screen.dart';

class VisaDashboardScreen extends StatefulWidget {
  final String userGoal; // 'novice', 'residency', 'job', etc.
  final VoidCallback? onGoalChangeRequested; // Callback to reset goal

  const VisaDashboardScreen({
    super.key,
    this.userGoal = 'novice',
    this.onGoalChangeRequested,
  });

  @override
  State<VisaDashboardScreen> createState() => _VisaDashboardScreenState();
}

class _VisaDashboardScreenState extends State<VisaDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'My Visa Roadmap',
          style: GoogleFonts.notoSansKr(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: widget.onGoalChangeRequested ?? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('목표 설정 변경 기능 준비 중')),
              );
            },
            icon: const Icon(Icons.edit_road),
            tooltip: '목표 변경',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            if (widget.userGoal == 'novice') _buildNoviceContent(),
            if (widget.userGoal == 'residency') _buildResidencyContent(context),
            if (widget.userGoal == 'job') _buildJobContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2B4D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2B4D).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현재 비자 상태',
            style: GoogleFonts.notoSansKr(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'D-2 유학비자',
                style: GoogleFonts.notoSansKr(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'D-365',
                  style: GoogleFonts.notoSansKr(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoviceContent() {
    return Column(
      children: [
        _buildInfoCard(
          title: '출석률 관리',
          value: '95%',
          description: '안전한 비자 연장을 위해 80% 이상 유지하세요.',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: '시간제 취업 허용',
          value: '주 20시간',
          description: '학기 중 허용 시간입니다. 방학 중에는 무제한!',
          icon: Icons.access_time,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildResidencyContent(BuildContext context) {
    // Get live score from Store
    final currentScore = Provider.of<VisaScoreProvider>(context).calculateTotalScore();
    final isPass = currentScore >= 80;

    return Column(
      children: [
        _buildInfoCard(
          title: 'F-2-7 점수 예측',
          value: '$currentScore점 / 80점',
          description: isPass 
              ? '축하합니다! 목표 점수를 달성했습니다.' 
              : '목표 점수까지 ${80 - currentScore}점 남았습니다.\n터치하여 상세 점수 계산하기',
          icon: Icons.calculate_outlined,
          color: isPass ? Colors.green : Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const F27VisaCalculatorScreen(),
              ),
            ).then((_) {
               setState(() {});
            });

          },
        ),
        const SizedBox(height: 16),
         _buildInfoCard(
          title: '사회통합프로그램',
          value: '3단계 이수',
          description: '5단계 이수 시 가산점이 부여됩니다.',
          icon: Icons.school_outlined,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildJobContent() {
     return Column(
      children: [
        _buildInfoCard(
          title: 'E-7 요건 충족',
          value: '준비 중',
          description: '전공 관련 직무 탐색이 필요합니다.',
          icon: Icons.work_outline,
          color: Colors.indigo,
        ),
        const SizedBox(height: 16),
         _buildInfoCard(
          title: '한국어 능력',
          value: 'TOPIK 4급',
          description: '취업에 유리한 5급 도전을 추천해요!',
          icon: Icons.translate,
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String description,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

