import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/diagnosis_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Provider (passed via ChangeNotifierProvider.value)
    final provider = Provider.of<DiagnosisProvider>(context);
    final result = provider.result;

    final String visaStatus = result['visa_status'] ?? 'INELIGIBLE';
    final int totalScore = result['total_score'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 결과'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                "🎓 [CUTY] 내 취업 경쟁력 진단 결과!\n비자 상태: $visaStatus\n종합 점수: ${totalScore}점\n#유학생 #취업 #CUTY",
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Visa Status Card
            _buildVisaCard(visaStatus),
            const SizedBox(height: 20),

            // 2. Score Chart Card
            _buildChartCard(result),
            const SizedBox(height: 20),

            // 3. Solution Section
            _buildSolutionSection(totalScore),
          ],
        ),
      ),
    );
  }

  Widget _buildVisaCard(String status) {
    final isEligible = status == 'ELIGIBLE';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEligible ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEligible ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.check_circle : Icons.warning_amber_rounded,
            color: isEligible ? Colors.green : Colors.red,
            size: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('비자 적합성 (Track 1)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                isEligible ? '안전 (Eligible)' : '위험 (Ineligible)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isEligible ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(Map<String, dynamic> result) {
    // Scaling to 5-point scale
    // Major (Max 40)
    double vMajor = ((result['score_major'] as int) / 40) * 5;
    // Exp (Max 30)
    double vExp = ((result['score_exp'] as int) / 30) * 5;
    // Lang (Max 20)
    double vLang = ((result['score_lang'] as int) / 20) * 5;
    // Extra (Max 10)
    double vExtra = ((result['score_extra'] as int) / 10) * 5;

    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('취업 경쟁력 (Track 2)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                gridBorderData: BorderSide(color: Colors.grey[200]!, width: 2),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                
                // Titles
                getTitle: (index, angle) {
                  switch (index) {
                    case 0: return const RadarChartTitle(text: '직무 전문성');
                    case 1: return const RadarChartTitle(text: '실무 경험');
                    case 2: return const RadarChartTitle(text: '어학 능력');
                    case 3: return const RadarChartTitle(text: '가산점');
                    default: return const RadarChartTitle(text: '');
                  }
                },
                
                // Data
                dataSets: [
                  RadarDataSet(
                    fillColor: Colors.purple.withOpacity(0.2),
                    borderColor: Colors.purple,
                    entryRadius: 3,
                    dataEntries: [
                      RadarEntry(value: vMajor),
                      RadarEntry(value: vExp),
                      RadarEntry(value: vLang),
                      RadarEntry(value: vExtra),
                    ],
                    borderWidth: 2,
                  ),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '종합 점수: ${result['total_score']}점 / 100점',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionSection(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("💡 AI 맞춤 솔루션", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (score < 60)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 18, color: Colors.black87),
                SizedBox(width: 8),
                Text('직무 경험이 부족해요! 인턴 공고 보기', style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 18, color: Colors.black87),
                SizedBox(width: 8),
                Text('전공 학점 관리 팁 보러가기', style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
      ],
    );
  }
}
