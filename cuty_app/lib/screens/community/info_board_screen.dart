import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/community_post_item.dart'; // Import shared widget
import 'info_board_detail_screen.dart';

class InfoBoardScreen extends StatelessWidget {
  const InfoBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Info Board
    final List<Map<String, dynamic>> infoPosts = [
      {
        'title': "신촌 자취방 구할 때 '이 특약' 안 넣으면 보증금 날립니다 (필독)",
        'content': "계약서 쓸 때 꼭 확인해야 할 3가지 체크리스트",
        'author': "자취만렙",
        'likes': 324,
        'comments': 45,
        'imageUrl': 'https://source.unsplash.com/random/800x600/?room',
        'board': "꿀팁",
        'flag': "🇰🇷",
        'uni': "본부",
        'cardCount': 5,
      },
      {
        'title': "학교 앞 가성비 식당 TOP 5 (만 원의 행복)",
        'content': "점심값 아껴서 여행가자! 가성비 맛집 지도 대공개",
        'author': "먹깨비",
        'likes': 128,
        'comments': 12,
        'imageUrl': 'https://source.unsplash.com/random/800x600/?food',
        'board': "맛집",
        'flag': "🇨🇳",
        'uni': "경성대",
        'cardCount': 7,
      },
      {
        'title': "한국어능력시험(TOPIK) 6급 단기 완성 비법서",
        'content': "3개월 만에 4급에서 6급으로 점프한 공부법 공유합니다.",
        'author': "한글마스터",
        'likes': 856,
        'comments': 120,
        'imageUrl': 'https://source.unsplash.com/random/800x600/?study',
        'board': "비자",
        'flag': "🇻🇳",
        'uni': "부경대",
        'cardCount': 4,
      },
      {
        'title': "유학생 필독! 2026년 달라지는 장학금 제도",
        'content': "놓치면 후회하는 신설 장학금 목록 정리",
        'author': "장학요정",
        'likes': 421,
        'comments': 34,
        'imageUrl': 'https://source.unsplash.com/random/800x600/?university',
        'board': "생활",
        'flag': "🇺🇸",
        'uni': "동아대",
        'cardCount': 6,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('정보 공유', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
             decoration: const BoxDecoration(
               border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
             ),
             child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   _buildFilterChip("전체", isSelected: true),
                   _buildFilterChip("비자"),
                   _buildFilterChip("생활"),
                   _buildFilterChip("맛집"),
                   _buildFilterChip("꿀팁"),
                ],
              ),
             ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: infoPosts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                 final post = infoPosts[index];
                 // Map 'badge' to 'board' if needed, or ensure data has 'board' key
                 // Since CommunityPostItem uses `post['board']`, we can just ensure the map has it.
                 // We will update the mock data keys above instead.
                 return CommunityPostItem(
                   post: post,
                   showBoardName: true,
                   contentMaxLines: 2,
                 );
              },
            ),
          ),
        ],
      ),
    );
  }

    // --- Helper Widgets ---

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
