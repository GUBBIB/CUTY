import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';
import '../../widgets/job_capability_banner.dart';
import '../../l10n/gen/app_localizations.dart'; // Add localization import

class EmploymentVisaScreen extends StatefulWidget {
  const EmploymentVisaScreen({super.key});

  @override
  State<EmploymentVisaScreen> createState() => _EmploymentVisaScreenState();
}

class _EmploymentVisaScreenState extends State<EmploymentVisaScreen> {
  // D-10 상태
  bool isFirstApplication = true; // Renamed from _isD10FirstTime to match snippet

  // [핵심 데이터] E-7 상세 직종 코드 (Code | Job Title)
  Map<String, List<String>> e7Occupations = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    e7Occupations = {
      AppLocalizations.of(context)!.codeProfessional: [
        AppLocalizations.of(context)!.jobManager, AppLocalizations.of(context)!.jobITManager, AppLocalizations.of(context)!.jobConstructionMgr,
        AppLocalizations.of(context)!.jobProductPlanner, AppLocalizations.of(context)!.jobPerfPlanner, AppLocalizations.of(context)!.jobTranslator,
        AppLocalizations.of(context)!.jobBioExpert, AppLocalizations.of(context)!.jobScienceExpert, AppLocalizations.of(context)!.jobChemEng,
        AppLocalizations.of(context)!.jobMetalEng, AppLocalizations.of(context)!.jobMechEng, AppLocalizations.of(context)!.jobPlantEng,
        AppLocalizations.of(context)!.jobRobotExpert, AppLocalizations.of(context)!.jobHwEng, AppLocalizations.of(context)!.jobTelecomEng,
        AppLocalizations.of(context)!.jobSystemAnalyst, AppLocalizations.of(context)!.jobSwDev,
        AppLocalizations.of(context)!.jobAppDev, AppLocalizations.of(context)!.jobWebDev, AppLocalizations.of(context)!.jobDataExpert,
        AppLocalizations.of(context)!.jobNetworkDev, AppLocalizations.of(context)!.jobSecExpert,
        AppLocalizations.of(context)!.jobDesigner, AppLocalizations.of(context)!.jobVideoDesigner, AppLocalizations.of(context)!.jobArtPlanner
      ],
      AppLocalizations.of(context)!.codeSemiPro: [
        AppLocalizations.of(context)!.jobDutyFree, AppLocalizations.of(context)!.jobCounselor, AppLocalizations.of(context)!.jobAirTransport,
        AppLocalizations.of(context)!.jobTourGuide, AppLocalizations.of(context)!.jobHotelReception, AppLocalizations.of(context)!.jobMedicalCoord,
        AppLocalizations.of(context)!.jobChef
      ],
      AppLocalizations.of(context)!.codeSkilled: [
        AppLocalizations.of(context)!.jobZookeeper, AppLocalizations.of(context)!.jobAquaTech, AppLocalizations.of(context)!.jobHalalButcher,
        AppLocalizations.of(context)!.jobInstrumentMaker, AppLocalizations.of(context)!.jobShipWelder,
        AppLocalizations.of(context)!.jobAircraftMech, AppLocalizations.of(context)!.jobShipElectrician, AppLocalizations.of(context)!.jobShipPainter
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.roadmapJobTitle,
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFE3F2FD), // Match background
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
                AppLocalizations.of(context)!.actionChangeClass,
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
            const SizedBox(height: 10),
            _buildHeroCard(),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: JobCapabilityBanner(), // 공통 배너 위젯
            ),
            const SizedBox(height: 30),
            
            // 3. E-7 직종 코드 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildE7SectionCard(),
            ),

            const SizedBox(height: 24),

            // 4. D-10 가이드 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildD10SectionCard(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // [위젯] 상단 목표 카드 (Exact Layout from RoadmapHeaderCard, Modified for E-7)
  Widget _buildHeroCard() {
    final s = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24), // F-2-7 uses Padding(horizontal: 24), so we use margin here to match
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // E-7 Blue Theme Gradient
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0), // Darker Blue
            Color(0xFF42A5F5), // Lighter Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Goal Title & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.visaRoadmapStep3, // '나의 목표'
                      style: GoogleFonts.notoSansKr(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.stepPracticeJob,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '(E-7)',
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
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business_center_outlined, // E-7 Icon
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Bottom Row: Roadmap Flow
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
             decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Step 1: D-2 (Current)
                _buildStep(
                  label: 'D-2',
                  isCurrent: true,
                ),
                
                 // Arrow
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),

                // Step 2: D-10
                _buildStep(
                  label: 'D-10',
                  isCurrent: false,
                ),

                // Arrow
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),

                // Step 3: Target (E-7)
                _buildStep(
                  label: 'E-7', 
                  isCurrent: false,
                  isTarget: true,
                ),
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
    // Current Step Style
    if (isCurrent) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Badge
          Positioned(
            top: -18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE040FB), // Magenta Badge
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
          // Main Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                color: const Color(0xFF4A90E2), // E-7 Blue Text
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }
    
    // Inactive/Target Step Style
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: isTarget ? Border.all(color: Colors.white.withOpacity(0.5)) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
        ),
      ),
    );
  }

  // [신규] E-7 직종 코드 섹션 카드
  Widget _buildE7SectionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.1),
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
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.work_outline, color: Color(0xFF4A90E2), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.secJobCodes,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.descJobCodes,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),
          
          // 리스트 아이템 (기존 데이터 매핑)
          ...e7Occupations.entries.map((entry) => _buildSimpleExpansionTile(entry.key, entry.value)),
        ],
      ),
    );
  }

  // [수정] 카드 내부용 심플 아코디언
  Widget _buildSimpleExpansionTile(String title, List<String> items) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero, // 패딩 제거해서 깔끔하게
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: items.map((item) {
                final parts = item.split('|');
                final code = parts[0].trim();
                final name = parts.length > 1 ? parts[1].trim() : "";
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(code, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF4A90E2))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(name, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]))),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  // [신규] D-10 가이드 섹션 카드
  Widget _buildD10SectionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.1),
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
                  color: const Color(0xFFFFF4E5), // 연한 주황색 배경
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.verified_user_outlined, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.visaGoalD10, // 'D-10 구직비자 가이드'
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.descD10Guide,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 20),

          // 스위치 로직
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.lblFirstApp,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF1A1A2E)),
                ),
              ),
              Switch(
                value: isFirstApplication,
                activeThumbColor: const Color(0xFF4A90E2),
                onChanged: (value) => setState(() => isFirstApplication = value),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 결과 박스 (카드 안의 카드 느낌으로 연하게)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isFirstApplication ? const Color(0xFFF0FDF4) : const Color(0xFFFFF8F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFirstApplication ? const Color(0xFFDCFCE7) : const Color(0xFFFFE4E6),
              ),
            ),
            child: isFirstApplication
                ? Column(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 32),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context)!.lblPointExempt, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF27AE60))),
                      Text(AppLocalizations.of(context)!.descPointExempt, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                    ],
                  )
                : Column(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
                      const SizedBox(height: 8),
                      Text(AppLocalizations.of(context)!.lblPointRequired, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text(AppLocalizations.of(context)!.descPointRequired, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
