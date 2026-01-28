import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    // [Community Section] - FULL WIDTH SHEET
    return Container(
      width: double.infinity, // Key: Full Width
      margin: EdgeInsets.zero, // Key: No Margins
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0), // Key: Internal Padding Reduced (15->12)
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Key: Top Radius Only
      ),
      child: SafeArea(
        top: false, 
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '커뮤니티',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint('더보기 클릭됨');
                    },
                    child: Text(
                      '더보기', // See more
                      style: GoogleFonts.notoSansKr(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Reduced gap (15->10)
            // Horizontal List
            SizedBox(
              height: 100, // Reduced List Height (110->100)
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  return Container(
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Material(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          debugPrint('${index == 0 ? "인기글" : "정보"} 클릭됨');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15), // Further reduced vertical padding (8->4)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  index == 0 ? "🔥 인기글" : "💡 정보",
                                  style: GoogleFonts.notoSansKr(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                index == 0 ? "수강신청 꿀팁!" : "오늘 학식 추천",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "성공하셨나요? 저는...",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 11,
                                  color: const Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Extra space for visual balance
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
