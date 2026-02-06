import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';

class StartupVisaScreen extends StatefulWidget {
  const StartupVisaScreen({super.key});

  @override
  State<StartupVisaScreen> createState() => _StartupVisaScreenState();
}

class _StartupVisaScreenState extends State<StartupVisaScreen> {
  // OASIS 프로그램 데이터
  final Map<String, String> oasisPrograms = {
    "OASIS-1 (기초소양)": "지식재산권 소양 (15점)",
    "OASIS-2 (심화소양)": "지식재산권 출원 (10~25점)",
    "OASIS-4 (창업소양)": "창업 이민 교육 (25점)",
    "OASIS-5 (코칭)": "전문가 멘토링 (15점)",
    "OASIS-6 (박람회)": "발명/창업대전 입상 (25점)",
    "OASIS-9 (사업화)": "법인 설립 완료 (25점)",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // User requested background
      appBar: AppBar(
        title: Text(
          '실전 창업형 로드맵',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFFFF3E0), // Match background
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisaGoalSelectionScreen(
                      onGoalSelected: (goal) {
                        debugPrint("New Goal Selected: $goal");
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFFE65100)),
              label: Text(
                "Class 변경",
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // 1. 상단 목표 카드 (Hero)
            _buildHeroCard(),

            const SizedBox(height: 24),

            // 2. D-8-4 자격 요건
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRequirementsCard(),
            ),

            const SizedBox(height: 24),

            // 3. OASIS 개념 설명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOasisConceptCard(),
            ),

            const SizedBox(height: 24),
            
            // 4. 전국 OASIS 센터 안내
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOasisCenterCard(),
            ),

            const SizedBox(height: 24),

            // 5. OASIS 프로그램 가이드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOasisListCard(),
            ),

            const SizedBox(height: 24),

            // 6. D-10-2 비교 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildD10ComparisonCard(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 1. 상단 목표 카드
  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
             Color(0xFFFF9800), // Requested
             Color(0xFFFFB74D), // Requested
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 목표',
                    style: GoogleFonts.notoSansKr(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "기술 창업",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '(D-8-4)',
                          style: GoogleFonts.notoSansKr(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded, // Rocket Icon
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
             decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStep(label: 'D-2', isCurrent: true),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),
                _buildStep(label: 'D-10-2', isCurrent: false),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),
                _buildStep(label: 'D-8-4', isCurrent: false, isTarget: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String label,
    bool isCurrent = false,
    bool isTarget = false,
  }) {
    if (isCurrent) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFD35400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Current',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE65100),
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: isTarget ? Border.all(color: Colors.white.withOpacity(0.8)) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.95),
          fontSize: 12,
        ),
      ),
    );
  }

  // 2. D-8-4 필수 요건 카드
  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0), 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.verified_outlined, color: Color(0xFFF57C00), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "D-8-4 발급 최소 요건",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 20),

          _buildCheckItem("학사 학위 이상 (국내/외)"),
          const SizedBox(height: 12),
          _buildCheckItem("OASIS 점수 80점 이상 (필수)"),
          const SizedBox(height: 12),
          _buildCheckItem("한국 법인 설립 완료"),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.notoSansKr(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  // 3. OASIS 개념 설명 카드
  Widget _buildOasisConceptCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: Color(0xFFE65100), size: 24),
              const SizedBox(width: 8),
              Text(
                "OASIS가 무엇인가요?",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "창업이민 종합지원시스템. D-8-4 비자를 받기 위해 80점을 적립하는 필수 교육입니다.",
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 4. 전국 OASIS 센터 안내 카드
  Widget _buildOasisCenterCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, color: Color(0xFFF57C00), size: 24),
              const SizedBox(width: 8),
              Text(
                "전국 OASIS 교육 센터",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildCenterItem("1. 서울", "서울글로벌센터(종로), 서울창업허브"),
          const SizedBox(height: 12),
          _buildCenterItem("2. 부산", "부산역 유라시아 플랫폼"),
          const SizedBox(height: 12),
          _buildCenterItem("3. 인천", "인천 글로벌 스타트업 캠퍼스"),
          const SizedBox(height: 12),
          _buildCenterItem("4. 대전", "KAIST 창업보육센터, 대전창업허브"),
        ],
      ),
    );
  }

  Widget _buildCenterItem(String region, String location) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          region,
          style: GoogleFonts.notoSansKr(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            location,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  // 5. OASIS 프로그램 가이드 카드
  Widget _buildOasisListCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb_outline, color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "OASIS 프로그램 가이드",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),
          
          ...oasisPrograms.entries.map((entry) => _buildSimpleExpansionTile(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSimpleExpansionTile(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  content,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 14,
                    color: const Color(0xFFD35400),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. D-10-2 비교 카드
  Widget _buildD10ComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows_rounded, color: Color(0xFFF57C00), size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "창업준비 비자(D-10-2)가 뭔가요?",
                  style: GoogleFonts.notoSansKr(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "D-10-1(구직)과 다릅니다. 창업 준비를 위해 최대 2년간 체류하며 OASIS 점수를 채우는 비자입니다.",
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
