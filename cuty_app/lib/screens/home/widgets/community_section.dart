import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../community/community_main_screen.dart';
import '../../community/community_feed_screen.dart';
import '../../community/board_list_screen.dart';
import '../../community/popular_posts_screen.dart';

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
                  // Determine Content based on Index
                  String tag;
                  String title;
                  String subtitle;
                  Color tagColor;
                  Color tagTextColor;

                  if (index == 0) {
                    tag = "🔥 인기글";
                    title = "수강신청 꿀팁!";
                    subtitle = "성공하셨나요? 저는...";
                    tagColor = const Color(0xFFFFF3E0);
                    tagTextColor = Colors.orange;
                  } else if (index == 1) {
                    tag = "💡 정보";
                    title = "오늘 학식 추천";
                    subtitle = "맛있는거 뭐 나옴?";
                    tagColor = const Color(0xFFFFF9C4);
                    tagTextColor = const Color(0xFFFBC02D);
                  } else {
                    tag = "🗣️ 자유";
                    title = "심심한 사람 드루와";
                    subtitle = "놀아줘요...";
                    tagColor = const Color(0xFFE3F2FD);
                    tagTextColor = const Color(0xFF1976D2);
                  }

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
                          if (index == 0) {
                            // Popular -> Leading to PopularPostsScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PopularPostsScreen()),
                            );
                          } else if (index == 1) {
                             // Info -> Leading to BoardListScreen (List)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BoardListScreen(title: '꿀팁 정보게시판')),
                            );
                          } else {
                            // Free/Other -> Leading to CommunityFeedScreen (Feed)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CommunityFeedScreen()),
                            );
                          }
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
                                  color: tagColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.notoSansKr(fontSize: 8, fontWeight: FontWeight.bold, color: tagTextColor),
                                ),
                              ),
                              const SizedBox(height: 3), // Gap 4->3
                              Text(
                                title,
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
                                subtitle,
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
