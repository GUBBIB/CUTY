import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:cuty_app/providers/f27_visa_provider.dart';
import '../visa/f27_visa_calculator_screen.dart';
import 'widgets/roadmap_header_card.dart';
import 'widgets/f27_concept_card.dart';
import '../visa/visa_goal_selection_screen.dart';

class VisaRoadmapScreen extends ConsumerStatefulWidget {
  final String? userGoal;
  final VoidCallback? onGoalChangeRequested;

  const VisaRoadmapScreen({
    super.key,
    this.userGoal,
    this.onGoalChangeRequested,
  });

  @override
  ConsumerState<VisaRoadmapScreen> createState() => _VisaRoadmapScreenState();
}

class _VisaRoadmapScreenState extends ConsumerState<VisaRoadmapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final visaState = ref.watch(visaScoreProvider);
    final int realTimeScore = visaState.calculateTotalScore();
    // 데이터가 있는지 확인 (점수가 0보다 크거나 지갑이 연동됨)
    final bool hasData = realTimeScore > 0 || visaState.isSpecWalletLinked;
    final adviceList = visaState.getSmartAdvice();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF6C63FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.lblResidencyVisa,
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisaGoalSelectionScreen(
                      onGoalSelected: (goal) {
                        print("새로운 목표 선택됨: $goal");
                      },
                    ),
                  ), 
                );
              },
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFF6C63FF)),
              label: Text(
                AppLocalizations.of(context)!.actionChangeClass,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6C63FF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C63FF),
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
            // 1. 헤더
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: RoadmapHeaderCard(
                currentVisa: 'D-2',
                targetVisa: 'F-2-7',
              ),
            ),
            const SizedBox(height: 24),

            // 2. 개념 잡기
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: F27ConceptCard(),
            ),
            const SizedBox(height: 24),
            
            // 3. 모의 점수 계산기
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildScoreCard(realTimeScore, hasData),
            ),
            
            // 4. 컨설턴트 (조건부 렌더링)
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: hasData 
                  ? _buildAdviceCard(adviceList)      // 데이터 있으면: 실제 조언
                  : _buildLockedConsultantCard(),     // 데이터 없으면: 잠금(블라인드)
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // [New] 실제 조언 카드
  Widget _buildAdviceCard(List<String> adviceList) {
    if (adviceList.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC5CAE9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent, color: Color(0xFF6C63FF), size: 24),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.roadmapConsultant,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...adviceList.map((advice) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.check_circle, size: 16, color: Color(0xFF6C63FF)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    advice.replaceAll('**', ''),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // [New] 잠금(블라인드) 카드
  Widget _buildLockedConsultantCard() {
    return GestureDetector(
      onTap: () async {
        // 잠긴 카드 눌러도 계산기로 이동
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const F27VisaCalculatorScreen()),
        );
        setState(() {});
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 32, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.roadmapConsultant,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.roadmapConsultantDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 계산기 카드 (기존 디자인 복구)
  Widget _buildScoreCard(int score, bool hasData) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const F27VisaCalculatorScreen()),
        );
        setState(() {}); 
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
                  Text(AppLocalizations.of(context)!.roadmapCalculator, style: GoogleFonts.notoSansKr(fontSize: 16, color: const Color(0xFF1E2B4D), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Only show score if hasScore, otherwise show placeholder
                  if (hasData) ...[
                       RichText(
                         text: TextSpan(
                           children: [
                             TextSpan(text: '$score', style: GoogleFonts.notoSansKr(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFF1E2B4D), height: 1.0)),
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
                      color: const Color(0xFF6C63FF), // Updated Brand Color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Text(
                          hasData ? AppLocalizations.of(context)!.btnRecalculate : AppLocalizations.of(context)!.btnCalculate,
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
    );
  }
}
