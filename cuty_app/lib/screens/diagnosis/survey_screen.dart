import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/diagnosis_provider.dart';
import 'result_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _questions = [
    '희망 직무는 무엇인가요?',
    '전공 분야는 무엇인가요?',
    'TOPIK(한국어능력시험) 등급은?',
    '인턴 및 실무 경험 횟수는?',
  ];

  final List<List<String>> _options = [
    ['마케팅', 'IT개발', '디자인', '무역'],
    ['상경계열', '공학계열', '예체능', '인문계열'],
    ['없음', '3급 이하', '4급', '5급 이상'],
    ['없음', '1회', '2회 이상'],
  ];

  final List<String> _keys = [
    'target_job',
    'major',
    'topik',
    'exp',
  ];

  @override
  Widget build(BuildContext context) {
    // Access provider (ensure it is provided by parent or wrapper)
    final provider = Provider.of<DiagnosisProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('스펙 진단 Step ${_currentPage + 1}/4'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildQuestionPage(
                  question: _questions[index],
                  options: _options[index],
                  key: _keys[index],
                  provider: provider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage({
    required String question,
    required List<String> options,
    required String key,
    required DiagnosisProvider provider,
  }) {
    final selectedValue = provider.answers[key];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 32),
          ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    provider.updateAnswer(key, option);
                    // Move to next page or Finish
                    if (_currentPage < 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Finish
                      provider.analyzeSpec();
                      
                      // Navigate to Result (Pass Provider)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: const ResultScreen(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedValue == option
                          ? const Color(0xFF8B5CF6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedValue == option
                            ? const Color(0xFF8B5CF6)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selectedValue == option ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (selectedValue == option)
                          const Icon(Icons.check_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
