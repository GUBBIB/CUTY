import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/diagnosis_provider.dart';
import '../screens/diagnosis/consulting_screen.dart'; // Consulting (Entry)
import '../screens/diagnosis/result_screen.dart'; // Result

class JobCapabilityBanner extends ConsumerWidget {
  const JobCapabilityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosisState = ref.watch(diagnosisProvider);
    final isCompleted = diagnosisState.isAnalysisDone;
    
    // Updated: Use model getter
    final score = diagnosisState.result?.totalScore ?? 0;

    return Container(
      // Unified styling tailored for both tabs
      width: double.infinity,
      height: 140, // Reduced to match Career Tab standard 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), 
        gradient: const LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF283593)], // Career Tab Colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF283593).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 24, top: 0, bottom: 0,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  Text(
                    "취업역량 점수: ${isCompleted ? score : '--'}점", 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                  const SizedBox(height: 2), // Slightly reduced gap
                  const Text(
                    "취업비자연계 진단", 
                    style: TextStyle(fontSize: 13, color: Colors.white70)
                  ),
                  const SizedBox(height: 12), // Reduced spacing
                  GestureDetector(
                    onTap: () {
                      debugPrint("Clicked: 스펙 진단하기 (Shared Widget)");
                       if (isCompleted) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultScreen()));
                       } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultingScreen()));
                       }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // More compact padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? "결과 다시보기" : "스펙 진단하기",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 25, 
            bottom: 0, 
            width: 105, 
            child: Image.asset(
              'assets/images/capy_corp_semicut.png', 
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, _) => const Icon(Icons.error, color: Colors.white),
            )
          ),
        ],
      ),
    );
  }
}
