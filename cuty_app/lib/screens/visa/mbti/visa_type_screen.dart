import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider; // Alias for classic Provider
import 'package:share_plus/share_plus.dart';

import '../../../providers/visa_provider.dart';
import '../../roadmap/visa_roadmap_screen.dart';
import '../employment_visa_screen.dart';
import '../global_visa_screen.dart';
import '../school_visa_screen.dart';
import 'visa_type_provider.dart';

class VisaTypeScreen extends ConsumerWidget {
  const VisaTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(visaTypeProvider);
    final notifier = ref.read(visaTypeProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "비자 유형 테스트",
          style: GoogleFonts.notoSansKr(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.reset(),
          )
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state.result != null
              ? _ResultView(result: state.result!)
              : _QuestionView(
                  key: ValueKey(state.currentQuestionIndex),
                  questionIndex: state.currentQuestionIndex,
                  onAnswer: (code) {
                    if (state.currentQuestionIndex == 0) {
                      notifier.answerQuestion1(code);
                    } else {
                      notifier.answerQuestion2(code);
                    }
                  },
                ),
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final int questionIndex;
  final Function(String) onAnswer;

  const _QuestionView({
    super.key,
    required this.questionIndex,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isQ1 = questionIndex == 0;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress
          LinearProgressIndicator(
            value: isQ1 ? 0.5 : 0.9,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFFA18CD1),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 40),
          
          // Question Text
          Text(
            isQ1 ? "Q1.\n졸업 후에\n어떤 계획을 가지고 있나요?" : "Q2.\n선호하는\n업무 스타일이 있나요?",
            style: GoogleFonts.notoSansKr(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2B4D),
              height: 1.4,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          if (isQ1) ...[
            Text(
              "가장 가까운 것을 골라보세요! 😊",
              style: GoogleFonts.notoSansKr(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
          
          const Spacer(),

          // Options
          if (isQ1) ...[
            _AnswerButton(label: "한국에서 취업하거나 창업할래요! 🏢", onPressed: () => onAnswer('A')),
            const SizedBox(height: 12),
            _AnswerButton(label: "대학원에 진학하고 싶어요 🎓", onPressed: () => onAnswer('B')),
            const SizedBox(height: 12),
            _AnswerButton(label: "본국 귀국 / 해외로 갈 거예요 ✈️", onPressed: () => onAnswer('C')),
            const SizedBox(height: 12),
            _AnswerButton(label: "아직 잘 모르겠어요 🤔", onPressed: () => onAnswer('D')),
          ] else ...[
             _AnswerButton(label: "안정적인 월급과 워라밸이 최고! 💰", onPressed: () => onAnswer('A')),
            const SizedBox(height: 16),
            _AnswerButton(label: "내 아이디어로 사업에 도전! 🔥", onPressed: () => onAnswer('B')),
          ],
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AnswerButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF1E2B4D),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final VisaTypeResult result;

  const _ResultView({required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "당신의 비자 유형은...",
            style: GoogleFonts.notoSansKr(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          
          // Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  result.title,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2B4D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    result.imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    result.description,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 16,
                      color: const Color(0xFF4A5568),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                   "추천 로드맵: ${result.goalName}",
                   style: GoogleFonts.notoSansKr(
                     fontSize: 14,
                     color: const Color(0xFFA18CD1),
                     fontWeight: FontWeight.bold,
                   ),
                 ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Action Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Provider Logic Integration
                _applyVisaType(context, result.goalKey);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2B4D),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "이 비자로 시작하기",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Share.share(
                  "나는 [${result.title}] 타입이래! 너도 확인해봐 👉 cuty.app",
                  subject: "내 카피바라 비자 유형은?",
                );
              },
              icon: const Icon(Icons.share, color: Colors.grey),
              label: Text(
                "친구에게 결과 공유하기",
                style: GoogleFonts.notoSansKr(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.white,
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyVisaType(BuildContext context, String goalKey) {
    // 1. Classic Provider Call (context.read)
    // LocalStorageService is handled inside VisaProvider
    final visaProvider = provider.Provider.of<VisaProvider>(context, listen: false);
    visaProvider.selectVisaType(goalKey);

    // 2. Navigation
    Widget nextScreen;
    switch (goalKey) {
      case 'research': // F-2-7
        nextScreen = const VisaRoadmapScreen(userGoal: 'residency');
        break;
      case 'employment':
        nextScreen = const EmploymentVisaScreen();
        break;
      case 'startup':
         nextScreen = const VisaRoadmapScreen(userGoal: 'startup'); // Assuming there's logic or using Named route
         // Warning: Previously 'startup' used pushReplacementNamed.
         // Let's check typical navigation.
         // Reverting to what was in VisaGoalSelectionScreen
         break;
      case 'global':
        nextScreen = const GlobalVisaScreen();
        break;
      case 'school':
        nextScreen = const SchoolVisaScreen();
        break;
      default:
        nextScreen = const SchoolVisaScreen();
    }

    if (goalKey == 'startup') {
       Navigator.of(context).pushReplacementNamed('/visa/startup');
    } else {
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (_) => nextScreen),
       );
    }
  }
}
