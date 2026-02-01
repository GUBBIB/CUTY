import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../community/community_main_screen.dart';

class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    // [Community Section] - FULL WIDTH SHEET
    return Container(
      width: double.infinity, // Key: Full Width
      margin: EdgeInsets.zero, // Key: No Margins
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20), // Reduced bottom padding
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
                      fontSize: 15, // Reduced from 16
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CommunityMainScreen()),
                      );
                    },
                    child: Text(
                      '더보기', 
                      style: GoogleFonts.notoSansKr(
                        fontSize: 11, // Reduced from 12
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6), // Tight gap (8->6)
            // Horizontal List
            SizedBox(
              height: 100, // Increased height (1.4x)
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 8), // Gap 12->8
                itemBuilder: (context, index) {
                  return Container(
                    width: 190, // Slightly narrower
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Material(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          debugPrint('${index == 0 ? "인기글" : "정보"} 클릭됨');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), // Tight Padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  index == 0 ? "🔥 인기글" : "💡 정보",
                                  style: GoogleFonts.notoSansKr(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                              ),
                              const SizedBox(height: 3), // Gap 4->3
                              Text(
                                index == 0 ? "수강신청 꿀팁!" : "오늘 학식 추천",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 12, // 13->12
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 1), // Gap 2->1
                              Text(
                                "성공하셨나요? 저는...",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 10, // 11->10
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
            // NO Bottom Spacing - Removed SizedBox
          ],
        ),
      ),
    );
  }
}
