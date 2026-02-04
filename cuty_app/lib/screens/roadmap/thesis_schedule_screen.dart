import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThesisScheduleScreen extends StatefulWidget {
  const ThesisScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ThesisScheduleScreen> createState() => _ThesisScheduleScreenState();
}

class _ThesisScheduleScreenState extends State<ThesisScheduleScreen> {
  // 데모용 데이터
  final List<Map<String, dynamic>> _steps = [
    {'title': '연구 계획서(Proposal) 발표', 'date': '2025.10.15', 'isCompleted': true},
    {'title': '학위 청구 논문 심사 신청', 'date': '2026.04.01', 'isCompleted': true},
    {'title': '예비 심사 (Preliminary)', 'date': '2026.05.20', 'isCompleted': false, 'isNext': true},
    {'title': '본 심사 (Main Defense)', 'date': '2026.06.15', 'isCompleted': false},
    {'title': '최종 논문 인쇄본 제출', 'date': '2026.07.10', 'isCompleted': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('논문 심사 일정', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. 상단 D-Day 및 동기부여 카드
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF9575CD)], // 보라색 그라데이션
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF673AB7).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '예비 심사까지',
                      style: GoogleFonts.notoSansKr(color: Colors.white.withOpacity(0.9), fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'D-30',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '서류 준비는 다 되셨나요?',
                  style: GoogleFonts.notoSansKr(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: Color(0xFF673AB7)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '심사 통과 시 학력 점수 +20점 확정!',
                          style: GoogleFonts.notoSansKr(
                            color: const Color(0xFF673AB7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // 2. 타임라인 리스트
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  final bool isCompleted = step['isCompleted'];
                  final bool isNext = step['isNext'] ?? false;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 타임라인 라인 및 점
                        Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isCompleted 
                                    ? const Color(0xFF673AB7) 
                                    : (isNext ? Colors.white : Colors.grey[300]),
                                border: Border.all(
                                  color: isCompleted || isNext ? const Color(0xFF673AB7) : Colors.grey[300]!,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: isCompleted 
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : (isNext ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF673AB7), shape: BoxShape.circle))) : null),
                            ),
                            if (index != _steps.length - 1)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: Colors.grey[200],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // 텍스트 내용
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title'],
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 16,
                                    fontWeight: isNext || isCompleted ? FontWeight.bold : FontWeight.normal,
                                    color: isNext || isCompleted ? Colors.black87 : Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  step['date'],
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 13,
                                    color: isNext ? const Color(0xFF673AB7) : Colors.grey[400],
                                    fontWeight: isNext ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
