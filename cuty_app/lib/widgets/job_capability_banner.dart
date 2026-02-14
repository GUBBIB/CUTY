import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/gen/app_localizations.dart';
import '../providers/diagnosis_provider.dart';
import '../screens/diagnosis/consulting_screen.dart';
import '../screens/diagnosis/result_screen.dart';

class JobCapabilityBanner extends ConsumerWidget {
  const JobCapabilityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosisState = ref.watch(diagnosisProvider);
    final isCompleted = diagnosisState.isAnalysisDone;
    
    final score = diagnosisState.result?.totalScore ?? 0;

    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), 
        gradient: const LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF283593).withOpacity(0.3),
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
                    AppLocalizations.of(context)!.bannerJobScore(isCompleted ? score : '--'), 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.bannerDiagnosisTitle, 
                    style: const TextStyle(fontSize: 13, color: Colors.white70)
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Clicked: Banner Action");
                       if (isCompleted) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultScreen()));
                       } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultingScreen()));
                       }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? AppLocalizations.of(context)!.bannerActionCheckResult : AppLocalizations.of(context)!.bannerActionTest,
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
