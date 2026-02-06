import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';

class GlobalVisaScreen extends StatelessWidget {
  const GlobalVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Global Teal Background
      appBar: AppBar(
        title: Text(
          '글로벌형 로드맵',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFE0F7FA), // Match background
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
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFF0097A7)), // Teal Accent
              label: Text(
                "Class 변경",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0097A7), // Teal Accent
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

            // 2. 학위 인증 가이드 (Apostille)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildApostilleCard(),
            ),

            const SizedBox(height: 24),

            // 3. 글로벌 취업 전략
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildGlobalStrategyCard(),
            ),

            const SizedBox(height: 24),

            // 4. 귀국 전 필수 체크리스트 (Clean Exit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCleanExitCard(),
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
             Color(0xFF4DD0E1), // Light Cyan
             Color(0xFF00BCD4), // Cyan
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.4),
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
                        "글로벌 커리어",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
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
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.public_rounded, // Globe Icon
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Balanced spacing
              children: [
                _buildStep(label: 'D-2', isCurrent: true),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),
                _buildStep(label: 'Global', isCurrent: false, isTarget: true),
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
                color: const Color(0xFF00838F), // Dark Cyan Accent
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
                color: const Color(0xFF0097A7), // Teal Text
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

  // 2. 학위 인증 가이드 (Apostille)
  Widget _buildApostilleCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0097A7).withOpacity(0.1),
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
                  color: const Color(0xFFE0F7FA), // Light Teal
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.verified_user_outlined, color: Color(0xFF0097A7), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "졸업장 인증(Apostille) 필수!",
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
            "본국에서 한국 학위를 인정받으려면 귀국 전 아포스티유(Apostille)나 영사 확인이 반드시 필요합니다.",
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Highlight Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFF00838F), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "귀국 후에는 처리가 매우 복잡하니, 반드시 한국에서 완료하세요.",
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13,
                      color: const Color(0xFF00838F),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. 글로벌 취업 전략
  Widget _buildGlobalStrategyCard() {
    final keywords = ["#해외영업", "#통번역", "#현지관리자", "#주재원보조"];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0097A7).withOpacity(0.1),
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
              const Icon(Icons.business_center_outlined, color: Color(0xFF0097A7), size: 24),
              const SizedBox(width: 8),
              Text(
                "한국 기업 해외 법인 공략",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "여러분의 가장 큰 무기는 "),
                TextSpan(text: "'한국어 능력'", style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: const Color(0xFF0097A7))),
                const TextSpan(text: "과 "),
                TextSpan(text: "'현지 문화 이해도'", style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: const Color(0xFF0097A7))),
                const TextSpan(text: "입니다."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFB2EBF2)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BCD4).withOpacity(0.1),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Text(
                tag,
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  color: const Color(0xFF00838F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // 4. 귀국 전 필수 체크리스트 (Clean Exit)
  Widget _buildCleanExitCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0097A7).withOpacity(0.1),
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
              const Icon(Icons.flight_takeoff_rounded, color: Color(0xFF0097A7), size: 24),
              const SizedBox(width: 8),
              Text(
                "깔끔한 마무리 (Clean Exit)",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCheckItem("외국인등록증 반납 (출국 시 공항)"),
          const SizedBox(height: 12),
          _buildCheckItem("4대 보험 및 세금 정산 (과태료 방지)"),
          const SizedBox(height: 12),
          _buildCheckItem("휴대폰 및 인터넷 해지"),
          const SizedBox(height: 12),
          _buildCheckItem("월세 보증금 반환 확인"),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Color(0xFF00BCD4), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: const Color(0xFF424242),
            ),
          ),
        ),
      ],
    );
  }
}
