import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/visa_provider.dart';



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
            // Top Horizontal Card (School Life)
            _buildHorizontalClassCard(
              context,
              title: '학교 생활형 (기본형)',
              subtitle: '일단 학교 생활과 비자 유지에 집중할래요',
              description: '일단은 즐거운 캠퍼스 라이프가 우선이죠! 출석률 관리와 학점, 그리고 비자 연장에 필요한 기본기부터 탄탄하게 다져봐요.',
              imagePath: 'assets/images/class_basic.png',
              goalKey: 'school',
              color: Colors.grey[100]!,
              icon: Icons.spa_outlined,
            ),
            const SizedBox(height: 16),
            
            // Grid - Vertical 1:2 Layout
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
                  subtitle: '대학원 진학 예정 &\nF-2-7(거주) 목표',
                  description: '단순 취업비자(E-7)에 만족하지 마세요.\n석사 학위를 활용해 더 자유로운 F-2-7(거주 비자)로 바로 업그레이드할 수 있습니다. 80점 달성을 위한 족집게 전략을 알려드릴게요.',
                  imagePath: 'assets/images/class_academic.jpg',
                  goalKey: 'research',
                  color: Colors.purple[50]!,
                  icon: Icons.school_outlined,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '실전 취업형 (E-7)',
                  subtitle: '학부 졸업 후\n한국 기업 바로 취업',
                  description: 'D-10 구직비자 자격 진단부터 E-7 직종 코드 확인, 취업 역량 분석까지 한번에! 졸업 후 한국 기업 취업을 위한 A to Z를 이 로드맵에 다 담았어요.',
                  imagePath: 'assets/images/class_job.jpg',
                  goalKey: 'employment',
                  color: Colors.blue[50]!,
                  icon: Icons.work_outline_rounded,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '창업형 (D-8-4)',
                  subtitle: '나만의 아이디어로\n기술 창업 도전',
                  description: 'D-8-4 기술창업을 위한 필수 요건(OASIS 80점)부터 전국 교육 센터 정보, 그리고 창업 준비 비자(D-10-2) 활용 가이드까지! 막막한 기술 창업의 길을 이 로드맵이 열어드릴게요.',
                  imagePath: 'assets/images/class_startup.jpg',
                  goalKey: 'startup',
                  color: Colors.orange[50]!,
                  icon: Icons.rocket_launch_outlined,
                ),
                _buildVerticalClassCard(
                  context,
                  title: '글로벌형',
                  subtitle: '한국 학위 취득 후\n본국/해외 진출',
                  description: '한국에서의 학업을 마치고 더 넓은 세상으로! 원활한 귀국 준비나 제3국 진출을 위한 서류 작업을 도와드릴게요.',
                  imagePath: 'assets/images/class_global.png',
                  goalKey: 'global',
                  color: Colors.teal[50]!,
                  icon: Icons.public_outlined,
                ),
              ],
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
                          onGoalSelected(goalKey); // Proceed with select (Update State)

                          // Provider에 상태 저장 후 이동
                          switch (goalKey) {
                            case 'research':
                              context.read<VisaProvider>().selectVisaType('research'); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VisaRoadmapScreen(userGoal: 'residency')), // Keeping internal param 'residency' as requested? Or align? User said 'research'. But RoadmapScreen might expect residency. I'll stick to 'residency' for the screen argument if logic needs it, BUT ensuring Provider gets 'research'.
                              );
                              break;
                            case 'employment':
                              context.read<VisaProvider>().selectVisaType('employment'); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmploymentVisaScreen()),
                              );
                              break;
                            case 'startup':
                              context.read<VisaProvider>().selectVisaType('startup'); 
                              Navigator.pushReplacementNamed(context, '/visa/startup');
                              break;
                            case 'global':
                              context.read<VisaProvider>().selectVisaType('global'); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GlobalVisaScreen()),
                              );
                              break;
                            case 'school':
                              context.read<VisaProvider>().selectVisaType('school'); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SchoolVisaScreen()),
                              );
                              break;
                            default:
                              debugPrint('Unknown goalKey: $goalKey');
                              break;
                          }
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
