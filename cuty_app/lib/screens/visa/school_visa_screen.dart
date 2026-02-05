import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';

class SchoolVisaScreen extends StatelessWidget {
  const SchoolVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Clean Gray Background
      appBar: AppBar(
        title: Text(
          '학교 생활형 로드맵',
          style: GoogleFonts.poppins(
            color: const Color(0xFF424242), // Dark Charcoal
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF424242)),
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
                      onGoalSelected: (goal) {},
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFF616161)),
              label: Text(
                "Class 변경",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF616161),
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

            // 2. 알바 & 비자 안전 가이드 (Safety)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSafetyCard(),
            ),

            const SizedBox(height: 24),

            // 3. 한국어 중요성 카드 (New)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildKoreanImportanceCard(),
            ),

            const SizedBox(height: 24),

            // 4. 한국어 전략 카드 (Updated)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLanguageStrategyCard(),
            ),

            const SizedBox(height: 24),

            // 3. 미래 로드맵 미리보기 (Future Path)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFuturePathCard(context),
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
             Color(0xFFF5F5F5), // Silver
             Color(0xFFE0E0E0), // Darker Silver
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "슬기로운 학교생활",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF424242),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF616161),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "아직 정해진 건 없어요. 무엇이든 될 수 있습니다!",
            style: GoogleFonts.notoSansKr(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
             decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            // Use Row with Flexible children to avoid overflow
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStep(label: '입학', isCurrent: true),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
                _buildStep(label: '학교생활', isCurrent: false),
                 Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
                _buildStep(label: '진로선택', isCurrent: false, isTarget: true),
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
    return Flexible( // Use Flexible to allow shrinking
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFF616161) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isCurrent ? null : Border.all(color: Colors.grey[400]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSansKr(
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? Colors.white : const Color(0xFF616161),
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
        ),
      ),
    );
  }

  // 2. 알바 & 비자 안전 가이드 (Safety)
  Widget _buildSafetyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.security, color: Colors.redAccent, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "비자 잃지 않으려면 (필수)",
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCheckItem("시간제 취업 허가 없이 알바 절대 금지 (강제 출국 대상)", isWarning: true),
          const SizedBox(height: 12),
          _buildCheckItem("출석률 70% 미만 시 비자 연장 불가", isWarning: true),
          const SizedBox(height: 12),
          // Updated GPA item
          _buildCheckItem("학점 2.0 이상 유지 (권장)", isRecommended: true),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, {bool isWarning = false, bool isRecommended = false}) {
    IconData icon;
    Color color;

    if (isWarning) {
      icon = Icons.error_outline;
      color = Colors.redAccent;
    } else if (isRecommended) {
      icon = Icons.check_circle_outline;
      color = Colors.orange;
    } else {
      icon = Icons.check_circle_outline;
      color = Colors.grey[600]!;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: isWarning ? Colors.redAccent : const Color(0xFF424242),
              fontWeight: isWarning ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }


  // 3. 한국어 중요성 카드 (New)
  Widget _buildKoreanImportanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.auto_graph_rounded, color: Colors.blueGrey, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "한국어 실력 = 나의 몸값",
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "한국어는 단순한 언어가 아닙니다. 한국에서의 '기회'와 '수입'을 결정하는 가장 강력한 무기입니다.",
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: const Color(0xFF424242),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildImportanceItem("💰 시급 상승", "힘든 육체노동 NO, 카페/서비스직 가능"),
          const SizedBox(height: 8),
          _buildImportanceItem("🤝 인 맥", "한국인 선배/친구와 교류 (꿀정보 획득)"),
          const SizedBox(height: 8),
          _buildImportanceItem("🏢 취 업", "E-7 전문직 면접은 한국어 실력이 1순위"),
        ],
      ),
    );
  }

  Widget _buildImportanceItem(String title, String desc) {
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: GoogleFonts.notoSansKr(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF424242),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            desc,
            style: GoogleFonts.notoSansKr(
              fontSize: 13,
              color: const Color(0xFF616161),
            ),
          ),
        ),
      ],
    );
  }

  // 4. 한국어 전략 카드 (Updated)
  Widget _buildLanguageStrategyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.translate_rounded, color: Color(0xFF424242), size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "전략적 준비 (TOPIK vs KIIP)",
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // ① VS Comparison (Side by Side)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: TOPIK
              Expanded(
                child: Column(
                  children: [
                    Text("TOPIK", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(4)),
                      child: Text("📝 시험 (Test)", style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1565C0))),
                    ),
                    const SizedBox(height: 12),
                    _buildCompactInfo("목적", "장학금 / 입학\n졸업 요건"),
                    const SizedBox(height: 8),
                    _buildCompactInfo("유효기간", "2년 (갱신 필수)"),
                  ],
                ),
              ),
              Container(width: 1, height: 140, color: Colors.grey[200]), // Divider
              // Right: KIIP
              Expanded(
                child: Column(
                  children: [
                    Text("KIIP", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                      child: Text("🏫 교육과정", style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32))),
                    ),
                    const SizedBox(height: 12),
                    _buildCompactInfo("목적", "비자(F-2)\n영주권(F-5)"),
                    const SizedBox(height: 8),
                    _buildCompactInfo("유효기간", "무제한 (평생)", highlight: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ② KIIP 심층 가이드 (Grey Box)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _buildDifferenceRow("TOPIK은 점수만 보지만, KIIP는 교육 이수(출석)가 필수입니다."),
                 const SizedBox(height: 8),
                 _buildDifferenceRow(
                   "⚠️ 5단계 주의: 0~4단계는 수업만 들어도 승급되지만, 마지막 5단계는 '종합평가' 합격(60점↑)을 해야 28점 만점을 받습니다.",
                   isWarning: true
                 ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ③ 💡 1타 3피 꿀팁 (Emphasis Box)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0), // Light Orange
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "졸업 요건 대체 가능?",
                      style: GoogleFonts.notoSansKr(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "최근 많은 대학이 KIIP 이수증으로 졸업 논문/TOPIK을 대체해 줍니다.\n학교 행정실에 확인해 보세요. [졸업 + 비자 + 영주권]을 한 번에 해결할 수 있습니다!",
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    color: const Color(0xFFBF360C),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCompactInfo(String label, String value, {bool highlight = false}) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.notoSansKr(fontSize: 10, color: Colors.grey[500])),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSansKr(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: highlight ? Colors.deepOrange : const Color(0xFF424242),
          ),
        ),
      ],
    );
  }

  Widget _buildDifferenceRow(String text, {bool bold = false, bool isWarning = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: TextStyle(color: isWarning ? Colors.redAccent : Colors.grey)),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSansKr(
              fontSize: 13,
              color: isWarning ? const Color(0xFFD32F2F) : const Color(0xFF424242),
              fontWeight: (bold || isWarning) ? FontWeight.w700 : FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // 3. 미래 로드맵 미리보기 (Future Path) - Accordion Style
  Widget _buildFuturePathCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              const Icon(Icons.alt_route_rounded, color: Color(0xFF424242), size: 24),
              const SizedBox(width: 8),
              Text(
                "졸업 후, 어떤 길로 갈까요?",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced spacing slightly
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Remove borders
            child: Column(
              children: [
                _buildExpansionTile(
                  color: const Color(0xFF2196F3), // Blue
                  title: "취업형 (E-7)",
                  subtitle: "전문직 취업 비자",
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "법무부 장관이 지정한 87개 직종에서 근무할 수 있습니다.\n단순히 전공만 맞추는 것이 아니라, "),
                        TextSpan(
                          text: "나의 '전문성'과 회사가 유학생을 채용해야 하는 '필요성'을 입증",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "해야 합니다.\n(전공-직무 연관 시 유리)"),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFF9C27B0), // Purple
                  title: "연구/거주형 (F-2)",
                  subtitle: "점수제 거주 비자 (석사대상)",
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "나이, 학력, 소득을 점수로 환산하는 비자입니다.\n"),
                        TextSpan(
                          text: "유학전형의 경우 석사학위 이상을 대상으로 하며, 이공계가 점수 확보에 유리합니다.",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: " 취업처 변경이 자유로운 "),
                        TextSpan(
                          text: "'준영주권'",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "입니다."),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFFFF9800), // Orange
                  title: "창업형 (D-8-4)",
                  subtitle: "기술 창업 비자 (OASIS 필수)",
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "특허나 독자적인 기술을 바탕으로 한국에서 벤처 기업을 설립하는 비자입니다. 단순히 자본금만 투자하는 것이 아니라 '기술력'을 입증해야 합니다.\n\n"),
                        TextSpan(
                          text: "일반적인 구직(D-10)이나 취업(E-7) 비자와는 준비 과정이 완전히 다릅니다.\n",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "단순 스펙보다는 "),
                        TextSpan(
                          text: "OASIS 프로그램 이수",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "와 "),
                        TextSpan(
                          text: "지식재산권(특허) 확보",
                          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "가 비자 발급의 핵심 열쇠입니다."),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFF009688), // Mint/Teal
                  title: "글로벌형 (해외진출)",
                  subtitle: "Global Career",
                  content: Text(
                    "한국에 남지 않고, 한국 학위와 언어 능력을 스펙으로 삼아 본국이나 제3국 기업의 핵심 인재로 진출하는 커리어 로드맵입니다.",
                    style: GoogleFonts.notoSansKr(color: Colors.black87, height: 1.5, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required Color color,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        radius: 6,
        child: CircleAvatar(
          backgroundColor: color,
          radius: 3,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.notoSansKr(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF424242),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      tilePadding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DefaultTextStyle(
            style: GoogleFonts.notoSansKr(
              color: Colors.black87,
              height: 1.5,
              fontSize: 14,
            ),
            textAlign: TextAlign.start,
            child: content,
          ),
        ),
      ],
    );
  }
}
