import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../community/community_main_screen.dart';
import '../../community/community_feed_screen.dart';
import '../../community/board_list_screen.dart';
import '../../community/popular_posts_screen.dart';
import '../../community/widgets/community_post_item.dart';

class PopularPostsPreview extends StatelessWidget {
  const PopularPostsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // [Home Screen Popular Posts Preview] - FULL WIDTH SHEET
    return Container(
      width: double.infinity, // Key: Full Width
      margin: EdgeInsets.zero, // Key: No Margins
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 5), // Reduced bottom padding
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
            const SizedBox(height: 8), // Standard gap
            // Horizontal List
            // Top 3 Popular Posts (Horizontal Card List)
            Builder(
              builder: (context) {
                // Mock Data for Popular Section (Top 3)
                final List<Map<String, dynamic>> popularPosts = [
                   {
                    'title': '한국에서 알바 구할 때 한국어 능력 얼마나 중요해?',
                    'content': '토픽 4급인데 힘들까? 사장님들이 보통 뭐 물어보시는지 궁금해 ㅠㅠ 면접 꿀팁 좀 알려주라...',
                    'author': '비빔밥러버',
                    'flag': '🇻🇳',
                    'uni': '경성대',
                    'likes': 120,
                    'comments': 52,
                    'board': '자유게시판',
                    'imageUrl': 'placeholder', // Grey Box Placeholder
                  },
                  {
                    'title': 'D-2 비자 연장 후기 (하이코리아 방문 예약 필수)',
                    'content': '오늘 출입국 관리 사무소 다녀왔는데 사람이 진짜 많더라고. 서류 미리 안 챙겼으면 큰일 날 뻔...',
                    'author': '비자마스터',
                    'flag': '🇯🇵',
                    'uni': '부산대',
                    'likes': 85,
                    'comments': 22,
                    'board': '정보게시판',
                    'imageUrl': 'placeholder', // Grey Box Placeholder
                  },
                  {
                    'title': '이번 학기 장학금 신청 기간 정리',
                    'content': '다들 놓치지 말고 신청해! 성적 장학금이랑 근로 장학금 중복 수혜 가능한지도 확인해봐.',
                    'author': '장학금사냥꾼',
                    'flag': '🇺🇸',
                    'uni': '해양대',
                    'likes': 82,
                    'comments': 15,
                    'board': '정보게시판',
                    'imageUrl': null, // Test without image
                  },
                ];

                return SizedBox(
                  height: 135, // Reduced height for tighter layout
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Vertical padding for shadow
                    itemCount: popularPosts.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final post = popularPosts[index];
                      return Container(
                        width: 300, // Fixed width card
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFF5F5F5)),
                        ),
                        // Clip behavior for clean corners
                        clipBehavior: Clip.hardEdge,
                        child: CommunityPostItem(
                          post: post,
                          rankingIndex: index + 1,
                          showBoardName: true,
                          contentMaxLines: 2, // Increased textual content space
                          showMetadata: false, // Minimal design (Preview Only: Title/Content/Image)
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
