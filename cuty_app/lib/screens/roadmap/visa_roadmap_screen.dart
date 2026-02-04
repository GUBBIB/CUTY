import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Add Provider
import '../../providers/f27_visa_provider.dart'; // Add VisaScoreProvider
import '../visa/f27_visa_calculator_screen.dart'; 
import 'thesis_schedule_screen.dart';

class VisaRoadmapScreen extends StatefulWidget {
  final String? userGoal;
  final VoidCallback? onGoalChangeRequested;

  const VisaRoadmapScreen({
    Key? key,
    this.userGoal,
    this.onGoalChangeRequested,
  }) : super(key: key);

  @override
  State<VisaRoadmapScreen> createState() => _VisaRoadmapScreenState();
}

class _VisaRoadmapScreenState extends State<VisaRoadmapScreen> {
  // ✅ Initialize to 0 and detailed result
  int currentScore = 0;
  bool hasCalculated = false;
  Map<String, dynamic>? detailedResult; // ✨ New: Stores full calculator result

  @override
  void initState() {
    super.initState();
    _refreshScore();
  }

  void _refreshScore() {
    // 1. Provider 접근 (listen: false)
    final provider = Provider.of<VisaScoreProvider>(context, listen: false);
    
    // 2. 저장된 데이터가 있는지 확인 (점수 계산 시도)
    int savedScore = provider.calculateTotalScore();
    
    // 3. 점수가 0점보다 크거나, 서류지갑이 연동된 상태라면 화면 갱신
    if (savedScore > 0 || provider.isSpecWalletLinked) {
      setState(() {
        currentScore = savedScore;
        hasCalculated = true; // ? 대신 점수를 보여주기 위해 true로 설정
        
        // detailedResult가 필요하다면 여기서도 재구성하거나 provider에 저장해두는 것이 좋음.
        // 현재는 점수만 복구하므로 상세 분석 메시지는 일부 제한될 수 있음.
        // 하지만 calculateTotalScore() 결과가 있다면 점수는 표시됨.
        
        // Strategy를 위해 minimal detailedResult 생성
        detailedResult = {
            'totalScore': savedScore,
            'isMasters': (provider.educationLevel == '석사' || provider.educationLevel == '박사'),
            'isStem': provider.isStemOrDoubleMajor,
            // 다른 필드들도 필요시 provider에서 가져옴
            'korean': (provider.koreanLevel == 'TOPIK 5~6급 / KIIP 5단계') ? 20 : 0, // Simplified check for consulting
            'income': (provider.incomeBracket != null) ? 10 : 0, // Dummy check, logic inside provider is better
             // NOTE: 실제로는 Provider가 detailedMap을 반환하는 메소드를 가지는게 더 좋음.
             // 임시로 화면 표시를 위해 점수 기반 활성화만 진행.
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPass = currentScore >= 80;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('My Visa Roadmap', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: widget.onGoalChangeRequested,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 16, color: Color(0xFF1E2B4D)),
              label: Text(
                "유형 변경",
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // 1. Current Visa Status Card (Keep as is)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2B4D),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1E2B4D).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('현재 비자 상태', style: GoogleFonts.notoSansKr(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('D-2 유학비자', style: GoogleFonts.notoSansKr(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text('D-365', style: GoogleFonts.notoSansKr(color: Colors.white, fontWeight: FontWeight.w600)),
                    )
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // 1.5 ✨ NEW: Detailed Visa Guide Section
          _buildVisaGuideSection(context),

          const SizedBox(height: 24),

          // 2. F-2-7 Calculator Card
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const F27VisaCalculatorScreen()));
              if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                      detailedResult = result;
                      currentScore = result['totalScore'] as int;
                      hasCalculated = true; 
                  });
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Colors.white, const Color(0xFFE3F2FD).withOpacity(0.5)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF1E2B4D).withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 10), spreadRadius: 2)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('모의 점수 계산기', style: GoogleFonts.notoSansKr(fontSize: 16, color: const Color(0xFF1E2B4D), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        // Only show score if calculated, otherwise show placeholder or ???
                        if (hasCalculated) ...[
                             RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: '$currentScore', style: GoogleFonts.notoSansKr(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFF1E2B4D), height: 1.0)),
                                  TextSpan(text: ' / 80', style: GoogleFonts.notoSansKr(fontSize: 20, color: Colors.grey[400], fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ] else ...[
                            Text('? / 80', style: GoogleFonts.notoSansKr(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.grey[300], height: 1.0)),
                        ],

                        const SizedBox(height: 12),
                        // ✨ Button Style Action
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF673AB7), // Brand Color
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Text(
                                hasCalculated ? '다시 계산하기' : '모의 점수 계산해보기',
                                style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10)
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(height: 80, width: 80, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF0277BD).withOpacity(0.4), blurRadius: 40, spreadRadius: 5)])),
                      Hero(tag: 'calculator_hero', child: Image.asset('assets/images/calculator.png', height: 110, fit: BoxFit.contain)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. ✨ NEW: Visa Upgrade Strategy Card (Conditional)
          if (hasCalculated)
            _buildUpgradeStrategyCard(context, currentScore),
          
          if (hasCalculated)
            const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- NEW WIDGETS ---

  // 1. Detailed Visa Guide Section
  Widget _buildVisaGuideSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2B4D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF1E2B4D), size: 24),
              const SizedBox(width: 8),
              Text(
                "F-2-7 비자 개념 잡기",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Concept Formula (Visual Equation)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFormulaBadge("💼 E-7 직종", Colors.grey[700]!, Colors.grey[200]!),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.add_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    _buildFormulaBadge("💯 80점", const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    Expanded(
                      child: _buildFormulaBadge("✨ F-2-7 (거주)", const Color(0xFF673AB7), const Color(0xFFEDE7F6)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ✨ Text Update
                Text(
                  "직종은 같습니다. (E-7-1 전문직)\n하지만 석사 이상 학위에 점수(80점)를 채우면\n비자가 업그레이드됩니다.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Comparison Table
          Text(
            "왜 업그레이드 해야 할까요?",
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2B4D),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              // ✨ Header Row
              Row(
                children: [
                    const SizedBox(width: 70), // Spacer for title
                    Expanded(child: Center(child: Text("일반 취업 (E-7)", style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)))),
                    // SizedBox(width: 20), // Spacer for divider not needed if using Expanded properly, but let's keep consistent
                    Expanded(child: Center(child: Text("거주 비자 (F-2-7)", style: GoogleFonts.notoSansKr(fontSize: 12, color: const Color(0xFF673AB7), fontWeight: FontWeight.bold)))),
                ],
              ),
              const SizedBox(height: 8),

              _buildCompareListRow("이직의 자유", "❌ 회사 허가 필수", "⭕ 자유로운 이직"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("체류 기간", "⚠️ 1~2년 (짧음)", "✅ 최대 5년 (여유)"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("가족 혜택", "❌ 배우자 취업 불가", "⭕ 배우자도 취업 가능"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("영주권", "🐢 5년 거주 필요", "🚀 3년 후 신청 가능"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansKr(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompareListRow(String title, String bad, String good) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bad,
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    good,
                    style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF673AB7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Strategy Card Widget
  Widget _buildUpgradeStrategyCard(BuildContext context, int currentScore) {
    // Show nothing if score hasn't been calculated yet
    if (!hasCalculated) return const SizedBox.shrink();

    // Get the personalized advice text
    String strategyMessage = _analyzeStrategy();
    
    // Determine color theme based on score (Pass/Fail)
    bool isPass = (detailedResult?['totalScore'] ?? 0) >= 80;
    Color iconColor = isPass ? const Color(0xFF673AB7) : const Color(0xFFFF8F00); // Purple vs Orange

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2B4D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Fixed Header (Persona)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.smart_toy_rounded, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "F-2-7 비자 컨설턴트",
                style: GoogleFonts.notoSansKr(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)), // Clean separator
          const SizedBox(height: 16),

          // 2. Dynamic Consulting Message
          Text(
            strategyMessage,
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              height: 1.6, // Better readability
              color: const Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic Helper ---
  String _analyzeStrategy() {
    if (detailedResult == null) return "점수를 먼저 계산해보세요.";
    
    int score = detailedResult!['totalScore'];
    bool isMasters = detailedResult!['isMasters'] ?? false;
    bool isStem = detailedResult!['isStem'] ?? false;
    int koreanScore = detailedResult!['korean'] ?? 0;
    int incomeScore = detailedResult!['income'] ?? 0;
    int volunteerScore = detailedResult!['volunteer'] ?? 0;
    int gap = 80 - score;

    // 🛑 1. Bachelor's Degree Check (Gatekeeper)
    if (!isMasters) {
      return "잠깐! 혹시 '석사 대학원' 졸업을 앞두고 계신가요? 🎓\n\n그렇다면 계산기에서 '석사'를 선택해야 정확한 결과가 나옵니다.\n\n만약 '국내 학사'로만 신청하신다면, 바로 F-2-7 변경은 어렵고 E-7 비자를 먼저 거쳐야 합니다.";
    }

    // ✅ 2. Masters+ (Real Consulting)
    
    // 2-1. 합격권
    if (score >= 80) {
       String msg = "완벽합니다! (석사 + ${score}점) 👏\n학위 요건과 점수를 모두 충족했습니다.\n이제 '전문직(E-7-1)' 취업이 확정되면 바로 F-2-7 변경이 가능합니다.";
       if (!isStem) msg += "\n(참고: 이공계라면 점수가 더 여유로울 수 있습니다)";
       return msg;
    }

    // 2-2. 불합격권 (석사인데 점수가 부족한 경우)

    // Case A: 1점 부족 & 봉사 없음
    if (gap == 1 && volunteerScore == 0) {
        return "학위는 완벽한데, 딱 1점이 부족해요! 😭\n**'사회봉사'**로 1점만 채우면, 석사 특례로 바로 F-2-7 주인공이 됩니다.";
    }

    // Case B: KIIP 추천 (2~10점 부족)
    // Assuming 20 is max, if < 20 they can improve. Or strict KIIP check?
    // Let's stick to the condition: if gap <= 10 and not max korean
    if (koreanScore < 20 && gap <= 10) {
       return "석사 학위가 있어도 점수가 ${gap}점 부족하네요.\n가장 확실한 방법은 **'사회통합프로그램(KIIP) 5단계'** 이수입니다. 가산점 10점으로 바로 합격권 진입하세요!";
    }

    // Case C: 기본 부족
    return "석사 학위가 있지만 점수 차이가 큽니다.\n**한국어(TOPIK)** 등급을 최대로 올렸는지, **예상 연봉**이 너무 낮게 책정된 건 아닌지 확인해보세요.";
  }

  // 2. Comparison Modal
  void _showComparisonModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text("왜 점수를 채워야 할까요?", style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("취업 비자(E-7)와 거주 비자(F-2-7)는\n삶의 질이 완전히 다릅니다.", style: GoogleFonts.notoSansKr(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 24),
            
            // Comparison Table
            Expanded(
              child: ListView(
                children: [
                  _buildCompareRow("이직의 자유", "❌ 회사 허가 필수", "⭕ 자유로운 이직", true),
                  _buildCompareRow("체류 기간", "⚠️ 보통 1년씩 연장", "✅ 최대 3~5년", true),
                  _buildCompareRow("배우자 취업", "❌ 불가능 (F-3)", "⭕ 가능 (F-2-71)", true),
                  _buildCompareRow("영주권 신청", "🐢 5년 거주 후", "🚀 3년 후 가능", true),
                ],
              ),
            ),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2B4D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("확인했습니다", style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareRow(String title, String bad, String good, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Center(child: Text(bad, style: GoogleFonts.notoSansKr(fontSize: 13, color: Colors.grey[600])))),
              Container(width: 1, height: 24, color: Colors.grey[300]), // Divider
              Expanded(child: Center(child: Text(good, style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF673AB7))))),
            ],
          ),
        ],
      ),
    );
  }
}
