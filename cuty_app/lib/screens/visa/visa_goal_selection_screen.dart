import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
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
            // Top Grid - Vertical 1:2 Layout
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.5, // 1:2 Ratio for Vertical Cards
              children: [
                _buildVerticalClassCard(
                  context,
                  title: '연구/거주형',
                  subtitle: '대학원 진학 & 영주권\n(F-2-7 비자)',
                  description: '깊이 있는 연구와 F-2-7 점수제 비자를 목표로 하시나요? 논문 일정 관리와 가산점 항목들을 놓치지 않게 도와드릴게요.',
                  imagePath: 'assets/images/class_academic.jpg',
                  goalKey: 'residency',
                  color: Colors.purple[50]!,
                  icon: Icons.school_outlined,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '실전 취업형',
                  subtitle: '졸업 후 한국 기업 취업\n(E-7 비자)',
                  description: '졸업 후 한국 기업에 취업하는 것이 목표시군요! E-7 비자 발급 조건부터 인턴십, 면접 꿀팁까지 제가 꼼꼼하게 챙겨드릴게요.',
                  imagePath: 'assets/images/class_job.jpg',
                  goalKey: 'job',
                  color: Colors.blue[50]!,
                  icon: Icons.work_outline_rounded,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '창업형',
                  subtitle: '나만의 스타트업 시작\n(D-8-4 비자)',
                  description: '멋진 아이디어가 있으시군요! D-8-4 비자 취득을 위한 OASIS 프로그램과 법인 설립 절차를 함께 준비해 봐요.',
                  imagePath: 'assets/images/class_startup.jpg',
                  goalKey: 'startup',
                  color: Colors.orange[50]!,
                  icon: Icons.rocket_launch_outlined,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '글로벌형',
                  subtitle: '학위 취득 후\n본국/해외 진출',
                  description: '한국에서의 학업을 마치고 더 넓은 세상으로! 원활한 귀국 준비나 제3국 진출을 위한 서류 작업을 도와드릴게요.',
                  imagePath: 'assets/images/class_global.png',
                  goalKey: 'global',
                  color: Colors.teal[50]!,
                  icon: Icons.public_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom Horizontal Card
            _buildHorizontalClassCard(
              context,
              title: '학교 생활형',
              subtitle: '일단 학교 생활과 비자 유지에 집중할래요',
              description: '일단은 즐거운 캠퍼스 라이프가 우선이죠! 출석률 관리와 학점, 그리고 비자 연장에 필요한 기본기부터 탄탄하게 다져봐요.',
              imagePath: 'assets/images/class_basic.png', // Fallback to png as jpg not found
              goalKey: 'novice',
              color: Colors.grey[100]!,
              icon: Icons.spa_outlined,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required Color color,
    required String goalKey,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Image Area
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    height: 140, // Allow overlap
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50), // Spacing for the overlapping image
              
              // Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E2B4D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.blueAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '목표는 나중에 [마이페이지]에서\n언제든 바꿀 수 있어요!',
                              style: GoogleFonts.notoSansKr(
                                fontSize: 13,
                                color: Colors.blue[800],
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Actions Area
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '다른 거 볼래요',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          onGoalSelected(goalKey); // Proceed with select
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF1E2B4D), // Brand color
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '이걸로 결정!',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalClassCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required String imagePath,
    required String goalKey,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(
        context,
        title: title,
        description: description,
        imagePath: imagePath,
        color: color,
        goalKey: goalKey,
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top Image - Flex 3 (75%)
            Expanded(
              flex: 3,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            // Bottom Info - Flex 1 (25%)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: color,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          title,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E2B4D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalClassCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required String imagePath,
    required String goalKey,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(
        context,
        title: title,
        description: description,
        imagePath: imagePath,
        color: color,
        goalKey: goalKey,
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 120, // Fixed height for horizontal card
          child: Row(
            children: [
              // Left Image - Flex 3 (30%)
              Expanded(
                flex: 3,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
                ),
              ),
              // Right Info - Flex 7 (70%)
              Expanded(
                flex: 7,
                child: Container(
                  color: color,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 24, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E2B4D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
