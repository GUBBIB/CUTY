import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class F27ConceptCard extends StatelessWidget {
  const F27ConceptCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2B4D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF6C63FF), size: 24),
              const SizedBox(width: 8),
              Text(
                "F-2-7 비자 개념 잡기",
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Concept Formula (Visual Equation)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFormulaBadge("💼 E-7 직종", Colors.grey[700]!, Colors.grey[200]!),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.add_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    _buildFormulaBadge("💯 80점", const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    Expanded(
                      child: _buildFormulaBadge("✨ F-2-7 (거주)", const Color(0xFF6C63FF), const Color(0xFFEDE7F6)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ✨ Text Update
                Text(
                  "직종은 같습니다. (E-7-1 전문직)\n하지만 석사 이상 학위에 점수(80점)를 채우면\n비자가 업그레이드됩니다.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Comparison Table
          Text(
            "왜 업그레이드 해야 할까요?",
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2B4D),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              // ✨ Header Row
              Row(
                children: [
                  const SizedBox(width: 70), // Spacer for title
                  Expanded(child: Center(child: Text("일반 취업 (E-7)", style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)))),
                  // SizedBox(width: 20), // Spacer for divider not needed if using Expanded properly, but let's keep consistent
                  Expanded(child: Center(child: Text("거주 비자 (F-2-7)", style: GoogleFonts.notoSansKr(fontSize: 12, color: const Color(0xFF6C63FF), fontWeight: FontWeight.bold)))),
                ],
              ),
              const SizedBox(height: 8),

              _buildCompareListRow("이직의 자유", "❌ 회사 허가 필수", "⭕ 자유로운 이직"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("체류 기간", "⚠️ 1~2년 (짧음)", "✅ 최대 5년 (여유)"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("가족 혜택", "❌ 배우자 취업 불가", "⭕ 배우자도 취업 가능"),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow("영주권", "🐢 5년 거주 필요", "🚀 3년 후 신청 가능"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansKr(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompareListRow(String title, String bad, String good) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bad,
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    good,
                    style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF6C63FF)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
