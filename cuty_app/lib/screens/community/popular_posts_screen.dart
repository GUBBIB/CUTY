
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularPostsScreen extends StatelessWidget {
  const PopularPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data with Rank and Source
    final List<Map<String, dynamic>> popularPosts = [
      {
        'rank': 1,
        'source': '자유',
        'title': '이번 축제 라인업 유출 떴다 ㅋㅋㅋ',
        'content': '진짜면 대박인데... 에스파 오는거 맞음? 사진 보니까 맞는거 같은데',
        'likes': 120,
        'comments': 45,
        'image': true,
      },
      {
        'rank': 2,
        'source': '비밀',
        'title': '솔직히 C동 엘리베이터 너무 느린 거 아니냐?',
        'content': '수업 10분 전에 도착해도 지각함. 이거 학교 측에 건의 어떻게 하냐',
        'likes': 85,
        'comments': 32,
        'image': false,
      },
      {
        'rank': 3,
        'source': '장터',
        'title': '아이패드 프로 5세대 급처합니다 (가격 내림)',
        'content': '상태 S급이고 애플케어 남았습니다. 쿨거시 네고 가능',
        'likes': 64,
        'comments': 12,
        'image': true,
      },
      {
        'rank': 4,
        'source': '정보',
        'title': '이번 학기 꿀교양 추천해준다',
        'content': '영화의 이해 교수님 진짜 천사심. 과제도 꿀이고 학점 잘 주신다.',
        'likes': 52,
        'comments': 28,
        'image': false,
      },
      {
        'rank': 5,
        'source': '자유',
        'title': '오늘 학식 메뉴 뭐임?',
        'content': '돈까스 나옴? 아니면 그냥 밖에서 먹게',
        'likes': 45,
        'comments': 18,
        'image': false,
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
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final post = popularPosts[index];
                return _PopularPostItem(post: post);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularPostItem extends StatelessWidget {
  final Map<String, dynamic> post;

  const _PopularPostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank Badge
          _buildRankBadge(post['rank']),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source & Title
                Row(
                  children: [
                    Text(
                      '[${post['source']}]',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        post['title'],
                        style: GoogleFonts.notoSansKr(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Content Preview
                Text(
                  post['content'],
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Footer (Likes, Comments)
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${post['likes']}',
                      style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.comment_outlined, size: 14, color: Colors.blue[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${post['comments']}',
                      style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Image Thumbnail (Optional)
          if (post['image']) 
            Container(
              margin: const EdgeInsets.only(left: 12),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color color;
    Widget content;

    if (rank == 1) {
      color = const Color(0xFFFFD700); // Gold
      content = const Icon(Icons.emoji_events, color: Colors.white, size: 18);
    } else if (rank == 2) {
      color = const Color(0xFFC0C0C0); // Silver
      content = const Icon(Icons.emoji_events, color: Colors.white, size: 18);
    } else if (rank == 3) {
      color = const Color(0xFFCD7F32); // Bronze
      content = const Icon(Icons.emoji_events, color: Colors.white, size: 18);
    } else {
      color = Colors.grey[300]!;
      content = Text(
        '$rank',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
