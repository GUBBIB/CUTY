
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoardListScreen extends StatelessWidget {
  final String title;

  const BoardListScreen({super.key, this.title = '정보게시판'});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Info/Tips
    final List<Map<String, dynamic>> infoPosts = [
      {
        'title': '2024년 1학기 국가장학금 2차 신청 안내',
        'content': '신입생, 편입생, 재입학생 등 2차 신청 기간 놓치지 마세요! 가구원 동의 필수입니다.',
        'author': '학생지원팀',
        'date': '2024.02.03',
        'likes': 120,
        'comments': 15,
      },
      {
        'title': '[꿀팁] 학교 앞 가성비 식당 리스트 정리 (24년 ver)',
        'content': '선배들이 추천하는 진짜 맛집만 모았습니다. 점심 시간 피해서 가세요.',
        'author': '쩝쩝박사',
        'date': '2024.02.01',
        'likes': 85,
        'comments': 42,
      },
      {
        'title': '교양 "영화의 이해" 수강 후기',
        'content': '팀플 없고 과제도 영화 감상문 하나라 편해요. 교수님도 좋으심.',
        'author': '익명',
        'date': '2024.01.28',
        'likes': 64,
        'comments': 8,
      },
      {
        'title': '자취생을 위한 분리수거 가이드',
        'content': '헷갈리는 플라스틱, 비닐 분리수거 방법 확실하게 정리해드립니다.',
        'author': '자취만렙',
        'date': '2024.01.25',
        'likes': 52,
        'comments': 12,
      },
      {
        'title': '도서관 스터디룸 예약 방법 변경 안내',
        'content': '이제 모바일 앱으로도 예약 가능합니다. 당일 예약은 불가능하니 참고하세요.',
        'author': '도서관자치위',
        'date': '2024.01.20',
        'likes': 30,
        'comments': 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: infoPosts.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final post = infoPosts[index];
          return _InfoListItem(post: post);
        },
      ),
    );
  }
}

class _InfoListItem extends StatelessWidget {
  final Map<String, dynamic> post;

  const _InfoListItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            post['title'],
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          // Preview Content
          Text(
            post['content'],
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Meta Row
          Row(
            children: [
              Text(
                '${post['author']} · ${post['date']}',
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              const Spacer(),
              _buildIconStat(Icons.favorite_border_rounded, '${post['likes']}', Colors.red[300]!),
              const SizedBox(width: 8),
              _buildIconStat(Icons.chat_bubble_outline_rounded, '${post['comments']}', Colors.blue[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconStat(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          label,
          style: GoogleFonts.notoSansKr(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
