
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/community_post_item.dart'; // Import shared widget

class PopularPostsScreen extends StatelessWidget {
  const PopularPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data with Rank and Source (Updated likes for 1-3)
    final List<Map<String, dynamic>> popularPosts = [
      {
        'board': '자유게시판',
        'title': '이번 축제 라인업 유출 떴다 ㅋㅋㅋ',
        'content': '진짜면 대박인데... 에스파 오는거 맞음? 사진 보니까 맞는거 같은데',
        'likes': 428,
        'comments': 120,
        'imageUrl': 'https://source.unsplash.com/random/200x200/?concert',
        'flag': '🇰🇷',
        'uni': '본부',
        'author': '익명',
      },
      {
        'board': '비밀게시판',
        'title': '솔직히 C동 엘리베이터 너무 느린 거 아니냐?',
        'content': '수업 10분 전에 도착해도 지각함. 이거 학교 측에 건의 어떻게 하냐',
        'likes': 256,
        'comments': 84,
        'imageUrl': null,
        'flag': '🇨🇳', 
        'uni': '경성대',
        'author': '익명',
      },
      {
        'board': '중고장터',
        'title': '아이패드 프로 5세대 급처합니다 (가격 내림)',
        'content': '상태 S급이고 애플케어 남았습니다. 쿨거시 네고 가능',
        'likes': 102,
        'comments': 15,
        'imageUrl': 'https://source.unsplash.com/random/200x200/?ipad',
        'flag': '🇻🇳', 
        'uni': '부경대',
        'author': '판매왕',
      },
      {
        'board': '정보게시판',
        'title': '이번 학기 꿀교양 추천해준다',
        'content': '영화의 이해 교수님 진짜 천사심. 과제도 꿀이고 학점 잘 주신다.',
        'likes': 78,
        'comments': 42,
        'imageUrl': null,
        'flag': '🇯🇵', 
        'uni': '부산대',
        'author': '학점킬러',
      },
      {
        'board': '자유게시판',
        'title': '오늘 학식 메뉴 뭐임?',
        'content': '돈까스 나옴? 아니면 그냥 밖에서 먹게',
        'likes': 56,
        'comments': 24,
        'imageUrl': null,
        'flag': '🇺🇸', 
        'uni': '동아대',
        'author': '배고파',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 실시간 인기글', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: const Color(0xFFFFF3E0), // Light Orange
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFFF6F00), size: 24),
                const SizedBox(width: 12),
                Text(
                  '지금 학교에서 가장 핫한 이야기! 🏆',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE65100),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: popularPosts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                final post = popularPosts[index];
                return CommunityPostItem(
                   post: post,
                   rankingIndex: index + 1,
                   showBoardName: true,
                   contentMaxLines: 2,
                   showMetadata: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

