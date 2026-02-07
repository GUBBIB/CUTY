import 'package:flutter/material.dart';
import '../job_detail_screen_career.dart';
import '../../diagnosis/consulting_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/diagnosis_provider.dart';
import '../../../../models/diagnosis_model.dart';
import '../../../l10n/gen/app_localizations.dart';

class CareerTabContent extends ConsumerWidget { // Changed to ConsumerWidget
  const CareerTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosisState = ref.watch(diagnosisProvider);
    final isAnalyzed = diagnosisState.isAnalysisDone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        
        // -------------------------------------------------------
        // 1. 중단: 비자 대시보드 (더보기 클릭 활성화)
        // -------------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: (isAnalyzed && diagnosisState.result != null)
              ? _buildResultDashboard(context, diagnosisState.result!, diagnosisState.answer)
              : _buildLockedDashboard(context),
        ),

        const SizedBox(height: 32),

        // -------------------------------------------------------
        // 2. 하단: 공고 리스트 (더보기 추가 & 카드 클릭 활성화)
        // -------------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end, // 텍스트 라인 맞춤
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.careerMatchedCompanies, // 문구 수정 요청 반영
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              // ★ [추가됨] 리스트 '더보기' 버튼
              InkWell(
                onTap: () {
                  debugPrint(">>> [클릭] 맞춤 기업 리스트 더보기");
                  // TODO: 전체 공고 리스트 페이지로 이동
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0, left: 8.0), // 터치 영역 확보
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.btnMore, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 공고 리스트 출력
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: 5,

          separatorBuilder: (c, i) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _buildJobCard(context, index),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // 🔒 잠금 상태 대시보드
  Widget _buildLockedDashboard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, size: 32, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.msgLockedReport,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.msgLockedReportSub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
               debugPrint(">>> [클릭] 비자 진단하러 가기 (Locked)");
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const ConsultingScreen()),
               );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Text(
                AppLocalizations.of(context)!.btnDiagnoseNow,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔓 진단 결과 대시보드
  Widget _buildResultDashboard(BuildContext context, DiagnosisResult result, SurveyAnswer answer) {
    // 1. Primary Job (First one)
    final primary = result.primary;
    
    // Fallback if no jobs or primary is null
    if (primary == null) {
       return Container(
         width: double.infinity,
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(16),
           border: Border.all(color: Colors.indigo.withOpacity(0.2)),
         ),
         child: Center(child: Text(AppLocalizations.of(context)!.msgNoRecommendedJobs)),
      );
    }

    // Generate Insight Comment
    final String comment = _generateInsightComment(context, result, answer);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.lblVisaReport, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  debugPrint(">>> [클릭] 내 비자 매칭 리포트 더보기");
                  // TODO: 상세 리포트 페이지로 이동
                },
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.btnMore, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Icon(Icons.chevron_right, size: 16, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Row 1: Tier Score
          _buildRichInfoRow(
            label: AppLocalizations.of(context)!.lblTier,
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "${AppLocalizations.of(context)!.msgTierCongrat} "),
                  TextSpan(
                    text: "'${result.totalTier}'",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  TextSpan(text: " ${AppLocalizations.of(context)!.msgTierSuffix}"),
                ],
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            iconColor: Colors.teal,
          ),
          const SizedBox(height: 10),

          // Row 2: Recommended Job
          _buildRichInfoRow(
            label: AppLocalizations.of(context)!.lblRecJob,
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "${AppLocalizations.of(context)!.msgRecJobPrefix} "),
                  TextSpan(
                    text: "[${primary.jobName}]",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  TextSpan(text: " ${AppLocalizations.of(context)!.msgRecJobSuffix}"),
                ],
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            iconColor: Colors.blue,
          ),
          const SizedBox(height: 10),

          // Row 3: Insight Comment (Highlight)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, size: 16, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.deepOrange,
                      height: 1.3
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

  String _generateInsightComment(BuildContext context, DiagnosisResult result, SurveyAnswer answer) {
    final primary = result.primary!;
    
    // 1. IF Visa Status is GREEN
    if (primary.visaStatus == VisaStatus.GREEN) {
      return AppLocalizations.of(context)!.insightPerfect;
    }

    // 2. IF Low Korean Level
    if (answer.koreanLevel.contains('기초')) {
      return AppLocalizations.of(context)!.insightTopik;
    }

    // 3. IF Low Experience (Assuming expScore is mapped to '경력' key)
    final expScore = primary.myScores['경력'] ?? 0;
    if (expScore == 0 || answer.experiences.isEmpty) {
      return AppLocalizations.of(context)!.insightInternship;
    }

    // 4. ELSE (General)
    // Calculate simple percentile logic for display
    final score = result.totalScore;
    int percentile = (100 - score).clamp(1, 99);
    return AppLocalizations.of(context)!.insightPercentile(percentile);
  }

  Widget _buildRichInfoRow({required String label, required Widget content, required Color iconColor}) {
    return Row(
      children: [
        Container(width: 4, height: 14, decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(width: 8),
        Expanded(child: content),
      ],
    );
  }


  Widget _buildJobCard(BuildContext context, int index) {
    final jobs = [
      // Case 1: E-7(OK) + F-2-R(Company OK) + Salary(OK)
      {
        "case": "1. 슈퍼 매칭",
        "company": "한화오션 (거제)",
        "title": "선박 제어 시스템 설계 엔지니어",
        "tags": [
          {"type": "E-7", "text": "E-7 | 전자공학 2351"},
          {"type": "F2R_C", "text": "F-2-R | 경남 거제"},
          {"type": "S", "text": "GNI 70%↑ 충족"},
        ],
        "salary": "연봉 4,200만원",
      },
      // Case 2: E-7(OK) + F-2-R(Salary NO)
      {
        "case": "2. E-7 전용",
        "company": "서울 테크윈",
        "title": "IT 솔루션 기술 지원팀원",
        "tags": [
          {"type": "E-7", "text": "E-7 | 응용SW 1332"},
        ],
        "salary": "연봉 2,800만원 (F-2-R 미달)",
      },
      // Case 3: E-7(OK) + F-2-R(User Region OK) + Salary(OK)
      {
        "case": "3. E-7/F-2-R 듀얼",
        "company": "현대중공업 협력사",
        "title": "플랜트 공정 관리직",
        "tags": [
          {"type": "E-7", "text": "E-7 | 기계공학 2353"},
          {"type": "F2R_U", "text": "F-2-R | 거주민 특례"},
          {"type": "S", "text": "GNI 70%↑ 충족"},
        ],
        "salary": "연봉 3,800만원",
      },
      // Case 4: E-7(NO) + F-2-R(Company OK) + Salary(OK)
      {
        "case": "4. F-2-R 전용 (지역)",
        "company": "전남 영광 풍력단지",
        "title": "단지 운영 지원 및 현장 관리",
        "tags": [
          {"type": "F2R_C", "text": "F-2-R | 전남 영광"},
          {"type": "S", "text": "GNI 70%↑ 충족"},
        ],
        "salary": "연봉 3,500만원",
      },
      // Case 5: E-7(NO) + F-2-R(User Region OK) + Salary(OK)
      {
        "case": "5. F-2-R 전용 (거주)",
        "company": "판교 데이터센터",
        "title": "단순 서버 모니터링 및 관리",
        "tags": [
          {"type": "F2R_U", "text": "F-2-R | 거주민 특례"},
          {"type": "S", "text": "GNI 70%↑ 충족"},
        ],
        "salary": "연봉 3,400만원",
      },
    ];

    final job = jobs[index];
    final tags = job['tags'] as List<Map<String, String>>;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CareerJobDetailScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
          border: Border.all(color: Colors.indigo.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((tag) => _buildBadge(tag)).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.business, color: Colors.grey)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title']! as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(job['company']! as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(job['salary']! as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(Map<String, String> tag) {
    Color bgColor;
    Color textColor;
    
    switch (tag['type']) {
      case 'E-7':
        bgColor = Colors.deepPurple[50]!;
        textColor = Colors.deepPurple;
        break;
      case 'F2R_C':
        bgColor = Colors.teal[50]!;
        textColor = Colors.teal[800]!;
        break;
      case 'F2R_U':
        bgColor = Colors.indigo[50]!;
        textColor = Colors.indigo[800]!;
        break;
      default: // Salary
        bgColor = Colors.orange[50]!;
        textColor = Colors.deepOrange[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4), border: Border.all(color: textColor.withOpacity(0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag['type'] == 'S') Icon(Icons.check_circle, size: 10, color: textColor),
          if (tag['type'] == 'S') const SizedBox(width: 4),
          Text(tag['text']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
