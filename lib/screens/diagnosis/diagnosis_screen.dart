import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/diagnosis_provider.dart';
import 'survey_screen.dart';

class DiagnosisScreen extends StatelessWidget {
  final String routePath;

  const DiagnosisScreen({
    super.key,
    this.routePath = '/diagnosis',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스펙 진단'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 80, color: Color(0xFF8B5CF6)),
            const SizedBox(height: 24),
            const Text(
              'Career Scan Pro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '나의 비자 적합성과 취업 경쟁력을\n한눈에 확인해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Start Survey with new Provider Scope
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => DiagnosisProvider(),
                      child: const SurveyScreen(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text(
                '진단 시작하기',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
