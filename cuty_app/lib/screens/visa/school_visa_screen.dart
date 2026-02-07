import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
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
          AppLocalizations.of(context)!.roadmapSchoolTitle,
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
                AppLocalizations.of(context)!.actionChangeClass,
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
            _buildHeroCard(context),

            const SizedBox(height: 24),

            // 2. 알바 & 비자 안전 가이드 (Safety)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSafetyCard(context),
            ),

            const SizedBox(height: 24),

            // 3. 한국어 중요성 카드 (New)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildKoreanImportanceCard(context),
            ),

            const SizedBox(height: 24),

            // 4. 한국어 전략 카드 (Updated)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLanguageStrategyCard(context),
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
  Widget _buildHeroCard(BuildContext context) {
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
                    AppLocalizations.of(context)!.visaRoadmapStep3, // '나의 목표'
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
                        AppLocalizations.of(context)!.stepSmartSchoolLife,
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
            AppLocalizations.of(context)!.descSmartSchoolLife,
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
                _buildStep(label: AppLocalizations.of(context)!.stepAdmission, isCurrent: true),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
                _buildStep(label: AppLocalizations.of(context)!.stepCampusLife, isCurrent: false),
                 Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
                _buildStep(label: AppLocalizations.of(context)!.stepCareerChoice, isCurrent: false, isTarget: true),
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
  Widget _buildSafetyCard(BuildContext context) {
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
                  AppLocalizations.of(context)!.secVisaMandatory,
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
          _buildCheckItem(AppLocalizations.of(context)!.warnNoPermit, isWarning: true),
          const SizedBox(height: 12),
          _buildCheckItem(AppLocalizations.of(context)!.warnAttendance, isWarning: true),
          const SizedBox(height: 12),
          // Updated GPA item
          _buildCheckItem(AppLocalizations.of(context)!.warnGpa, isRecommended: true),
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
  Widget _buildKoreanImportanceCard(BuildContext context) {
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
                  AppLocalizations.of(context)!.secKoreanValue,
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
            AppLocalizations.of(context)!.descKoreanValue,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: const Color(0xFF424242),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildImportanceItem(AppLocalizations.of(context)!.tagWage, AppLocalizations.of(context)!.descWage),
          const SizedBox(height: 8),
          _buildImportanceItem(AppLocalizations.of(context)!.tagNetwork, AppLocalizations.of(context)!.descNetwork),
          const SizedBox(height: 8),
          _buildImportanceItem(AppLocalizations.of(context)!.tagEmployment, AppLocalizations.of(context)!.descEmployment),
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
  Widget _buildLanguageStrategyCard(BuildContext context) {
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
                  AppLocalizations.of(context)!.secStrategicPrep,
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
                      child: Text(AppLocalizations.of(context)!.tagTest, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1565C0))),
                    ),
                    const SizedBox(height: 12),
                    _buildCompactInfo(AppLocalizations.of(context)!.lblPurpose, AppLocalizations.of(context)!.valScholarshipGrad),
                    const SizedBox(height: 8),
                    _buildCompactInfo(AppLocalizations.of(context)!.lblValidity, AppLocalizations.of(context)!.valValidityTwoYears),
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
                      child: Text(AppLocalizations.of(context)!.tagEducationCurriculum, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32))),
                    ),
                    const SizedBox(height: 12),
                    _buildCompactInfo(AppLocalizations.of(context)!.lblPurpose, AppLocalizations.of(context)!.valVisaPermanent),
                    const SizedBox(height: 8),
                    _buildCompactInfo(AppLocalizations.of(context)!.lblValidity, AppLocalizations.of(context)!.valValidityForever, highlight: true),
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
                 _buildDifferenceRow(AppLocalizations.of(context)!.descTopikVsKiip),
                 const SizedBox(height: 8),
                 _buildDifferenceRow(
                   AppLocalizations.of(context)!.warnKiipLevel5,
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
                      AppLocalizations.of(context)!.titleTipGraduation,
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
                  AppLocalizations.of(context)!.descTipGraduation,
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
                AppLocalizations.of(context)!.titleFuturePath,
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
                  title: AppLocalizations.of(context)!.roadmapJobTitle,
                  subtitle: AppLocalizations.of(context)!.subtitleE7,
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: AppLocalizations.of(context)!.descE7),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFF9C27B0), // Purple
                  title: AppLocalizations.of(context)!.lblResidencyVisa,
                  subtitle: AppLocalizations.of(context)!.subtitleF2,
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                       TextSpan(text: AppLocalizations.of(context)!.descF2),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFFFF9800), // Orange
                  title: AppLocalizations.of(context)!.roadmapStartupTitle,
                  subtitle: AppLocalizations.of(context)!.subtitleStartup,
                  content: Text.rich(
                    TextSpan(
                      style: GoogleFonts.notoSansKr(
                        color: Colors.black87,
                        height: 1.5,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: AppLocalizations.of(context)!.descStartup),
                      ],
                    ),
                  ),
                ),
                 _buildExpansionTile(
                  color: const Color(0xFF009688), // Mint/Teal
                  title: AppLocalizations.of(context)!.roadmapGlobalTitle,
                  subtitle: AppLocalizations.of(context)!.subtitleGlobal,
                  content: Text(
                    AppLocalizations.of(context)!.descGlobal,
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
