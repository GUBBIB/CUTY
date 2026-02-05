import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';
import '../../widgets/job_capability_banner.dart';

class EmploymentVisaScreen extends StatefulWidget {
  const EmploymentVisaScreen({super.key});

  @override
  State<EmploymentVisaScreen> createState() => _EmploymentVisaScreenState();
}

class _EmploymentVisaScreenState extends State<EmploymentVisaScreen> {
  // D-10 상태
  bool _isD10FirstTime = true;
  int _ageScore = 20;
  int _eduScore = 20;
  int _koreanScore = 20;
  int get _totalD10Score => _ageScore + _eduScore + _koreanScore;
  bool get _isPass => _totalD10Score >= 60;

  // [핵심 데이터] E-7 상세 직종 코드 (Code | Job Title)
  final Map<String, List<String>> e7Occupations = {
    "E-7-1 (전문직 - 관리/전문가)": [
      "1110 | 기획 및 경영지원 관리자", "1212 | 정보통신 관리자", "1391 | 건설 및 광업 생산 관리자",
      "1511 | 상품기획 전문가", "1522 | 공연기획자", "1630 | 통번역가",
      "2111 | 생명과학 전문가", "2112 | 자연과학 전문가", "2311 | 화학공학 기술자",
      "2321 | 금속/재료 공학 기술자", "2351 | 기계공학 기술자", "2353 | 플랜트공학 기술자",
      "2392 | 로봇공학 전문가", "2511 | 컴퓨터 하드웨어 기술자", "2521 | 통신공학 기술자",
      "2530 | 컴퓨터 시스템 설계 및 분석가", "2531 | 시스템 S/W 개발자",
      "2532 | 응용 S/W 개발자", "2533 | 웹 개발자", "2592 | 데이터 전문가",
      "2593 | 네트워크 시스템 개발자", "2594 | 정보보안 전문가",
      "2721 | 디자이너", "2733 | 영상 관련 디자이너", "2741 | 문화예술 기획자"
    ],
    "E-7-2 (준전문 - 사무/서비스)": [
      "3121 | 면세점/제주영어도시 판매", "3126 | 고객상담 사무원", "3910 | 항공 운송 사무원",
      "3922 | 관광 통역 안내원", "3991 | 호텔 접수 사무원", "4320 | 의료 코디네이터",
      "4410 | 주방장 및 조리사"
    ],
    "E-7-3 (일반기능 - 숙련직)": [
      "6139 | 동물 사육사", "6310 | 양식 기술자", "7103 | 할랄 도축원",
      "7303 | 악기 제조 및 조율사", "7430 | 조선 용접공",
      "7521 | 항공기 정비원", "7621 | 선박 전기원", "7724 | 선박 도장공"
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          '실전 취업형 로드맵',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF5F7FA), // Match background
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
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFF6C63FF)),
              label: Text(
                "Class 변경",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6C63FF),
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
            const SizedBox(height: 10), // AppBar spacing
            
            // 1. Header Card (F-2-7 Style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildHeaderCard(),
            ),

            const SizedBox(height: 24),

            // 2. Capybara Promotion Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: JobCapabilityBanner(),
            ),

            const SizedBox(height: 24),

            // 3. E-7 Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "E-7 비자 직종 코드",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "희망 직무의 정확한 코드를 확인해보세요.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...e7Occupations.entries.map((entry) => _buildExpansionTile(entry.key, entry.value)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 4. D-10 Guide (Optional / Bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("🛡️ D-10 구직비자 가이드"),
                  const SizedBox(height: 16),
                  _buildD10Guide(),
                ],
              ),
            ),
            
            const SizedBox(height: 100), // Bottom padding for comfortable scrolling
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.notoSansKr(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1E2B4D),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A90E2), // Deep Blue
            Color(0xFF87CEFA), // Sky Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 목표',
                    style: GoogleFonts.notoSansKr(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                     crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '실전 취업',
                        style: GoogleFonts.notoSansKr(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '(E-7)',
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work_outline_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Flow Chart
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFlowStep("D-2", isCurrent: false),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: 12),
                _buildFlowStep("D-10", isCurrent: false),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: 12),
                _buildFlowStep("E-7", isCurrent: true), // Target is "Current" highlight style in this context
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStep(String label, {required bool isCurrent}) {
    if (isCurrent) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset:const Offset(0, 2))],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(color: const Color(0xFF1565C0), fontSize: 14, fontWeight: FontWeight.w700),
          ),
        );
    }
    return Text(
      label,
      style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
    );
  }


  // _buildCapybaraBanner has been replaced by JobCapabilityBanner widget

  Widget _buildExpansionTile(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.folder_open, color: Color(0xFF4A90E2), size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 4, color: Color(0xFF4A90E2)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildD10Guide() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
           Row(
            children: [
              Expanded(
                child: Text(
                  "국내 대학 졸업 후\n최초 신청인가요?", // Simplified copy
                  style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1E2B4D)),
                ),
              ),
              Switch(
                value: _isD10FirstTime,
                activeColor: const Color(0xFF2196F3),
                onChanged: (v) => setState(() => _isD10FirstTime = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isD10FirstTime)
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(16)),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text("🎉", style: TextStyle(fontSize: 20)),
                   const SizedBox(width: 8),
                   Text("점수 계산 없이 발급 가능", style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
                 ],
               ),
             )
          else 
             Column(
               children: [
                  _buildSimpleCalRow("나이", 20, _ageScore, (v) => setState(() => _ageScore = v)),
                  const SizedBox(height: 8),
                  _buildSimpleCalRow("학위", 20, _eduScore, (v) => setState(() => _eduScore = v)),
                  const SizedBox(height: 8),
                  _buildSimpleCalRow("한국어", 20, _koreanScore, (v) => setState(() => _koreanScore = v)),
                  const SizedBox(height: 16),
                  Text("$_totalD10Score / 60점", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _isPass ? Colors.green : Colors.red)),
               ],
             ),
        ],
      ),
    );
  }
  
  Widget _buildSimpleCalRow(String label, int max, int current, Function(int) onChanged) {
    bool isChecked = current == max;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.notoSansKr(fontSize: 14, color: Colors.grey[700])),
          GestureDetector(
            onTap: () => onChanged(isChecked ? 0 : max),
            child: Icon(isChecked ? Icons.check_circle : Icons.check_circle_outline, color: isChecked ? const Color(0xFF2196F3) : Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
