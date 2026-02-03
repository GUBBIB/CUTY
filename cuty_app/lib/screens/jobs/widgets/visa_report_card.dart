import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/diagnosis_provider.dart';
import '../../diagnosis/consulting_screen.dart';
import '../../diagnosis/result_screen.dart';

class VisaReportCard extends ConsumerWidget {
  const VisaReportCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosisState = ref.watch(diagnosisProvider);
    final hasResult = diagnosisState.isAnalysisDone && diagnosisState.result != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (hasResult) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResultScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConsultingScreen()),
              );
            }
          },
          child: hasResult
              ? _buildUnlockedSummaryCard(context, diagnosisState.result!)
              : _buildLockedReportCard(context),
        ),
      ),
    );
  }

  Widget _buildLockedReportCard(BuildContext context) {
    return Stack(
      children: [
        // Background Pattern
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[50]!,  // Very light grey
                  Colors.grey[100]!, // Light grey
                ],
              ),
            ),
          ),
        ),
        
        // Content
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 40, 
                color: Color(0xFF9FA8DA), // Indigo 200
              ),
              const SizedBox(height: 16),
              const Text(
                "나의 E-7 비자 합격률은 몇 점?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283593), // Indigo 800
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "3분 만에 취업 역량을 진단하고\n상세 리포트를 확인해보세요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C6BC0), // Indigo 400
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5C6BC0).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "진단 시작하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedSummaryCard(BuildContext context, dynamic result) { // Using dynamic to avoid import issues if models move, but practically uses DiagnosisResult
    final topJob = result.analysisResults.isNotEmpty 
        ? result.analysisResults.values.first 
        : null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF283593)), // Indigo 800
                  const SizedBox(width: 8),
                  Text(
                    "내 비자 매칭 리포트",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "상세보기",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Scores Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6), // Indigo 50
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "${result.totalScore}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF283593),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "종합 등급",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTierColor(result.totalTier).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getTierColor(result.totalTier).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getTierIcon(result.totalTier), 
                          style: const TextStyle(fontSize: 14)
                        ),
                        const SizedBox(width: 6),
                        Text(
                          result.totalTier,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getTierColor(result.totalTier),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[100], height: 1),
          const SizedBox(height: 16),
          
          // Recommendation
          if (topJob != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: _getSignalIcon(topJob.visaStatus),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "가장 추천하는 직무",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: topJob.jobName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const TextSpan(
                              text: " 입니다.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toUpperCase()) {
      case 'DIAMOND': return Colors.blueAccent;
      case 'PLATINUM': return Colors.teal;
      case 'GOLD': return  const Color(0xFFFFA000); // Amber 700
      case 'SILVER': return Colors.grey;
      default: return Colors.grey;
    }
  }

  String _getTierIcon(String tier) {
    switch (tier.toUpperCase()) {
      case 'DIAMOND': return "💎";
      case 'PLATINUM': return "💠";
      case 'GOLD': return "🏆";
      case 'SILVER': return "🥈";
      default: return "🎲";
    }
  }

  Widget _getSignalIcon(dynamic status) { // VisaStatus enum
    // Assuming VisaStatus string or enum. 
    // Checking string representation or enum value
    Color color = Colors.grey;
    if (status.toString().contains('GREEN')) color = Colors.green;
    else if (status.toString().contains('YELLOW')) color = Colors.amber;
    else if (status.toString().contains('RED')) color = Colors.red;

    return Icon(Icons.circle, size: 12, color: color);
  }
}
