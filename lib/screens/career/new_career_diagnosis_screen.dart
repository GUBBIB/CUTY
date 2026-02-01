import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuty_app/providers/user_provider.dart';
import 'package:cuty_app/providers/survey_provider.dart';
import 'package:cuty_app/providers/diagnosis_provider.dart';
import 'package:cuty_app/providers/document_provider.dart';
import 'package:cuty_app/screens/career/widgets/diagnosis_radar_chart.dart'; // Explicit import

class NewCareerDiagnosisScreen extends ConsumerWidget {
  const NewCareerDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final diagnosis = ref.watch(diagnosisProvider);
    final survey = ref.watch(surveyProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("진단 결과", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Header (User Info)
            Text(
              "${user.name}님의 취업 경쟁력 진단서",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "희망 직무: ${survey.job ?? '미선택'}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // 2. Scoreboard Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Row 1: Visa Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildVisaStatusIcon(diagnosis.resultData.visaStatus),
                      const SizedBox(width: 8),
                      Text(
                        diagnosis.resultData.visaStatus == VisaStatus.ELIGIBLE ? "비자 발급 안정권" : "비자 발급 주의",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: diagnosis.resultData.visaStatus == VisaStatus.ELIGIBLE ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 2: Score & Tier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text("종합 점수", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "${diagnosis.resultData.score}",
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF283593)),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[200]),
                      Column(
                        children: [
                          const Text("예상 등급", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "Tier ${diagnosis.resultData.tier}",
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF283593)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // [NEW] Radar Chart
                  const Text("역량 상세 분석", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: DiagnosisRadarChart(
                      data: diagnosis.resultData.metricScores.values.toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // [NEW] Kakao Share Button
            ElevatedButton.icon(
              onPressed: () {
                // Kakao Share Logic Stub
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('카카오톡 공유하기 기능을 실행합니다... (API 키 필요)')),
                );
              },
              icon: const Icon(Icons.share, color: Colors.black87),
              label: const Text("나의 진단 결과 카카오톡 공유하기", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE500), // Kakao Yellow
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: Colors.indigo.withValues(alpha: 0.4),
                ),
                child: const Text("맞춤형 공고 보러가기", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
             TextButton(
              onPressed: () {
                 ref.read(surveyProvider.notifier).reset();
                 Navigator.pop(context); 
              },
              child: Text("다시 진단하기", style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisaStatusIcon(VisaStatus status) {
    // Return simple icon based on status
    if (status == VisaStatus.ELIGIBLE) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 24);
    } else {
      return const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24);
    }
  }
}
