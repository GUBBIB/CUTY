
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/community_post_item.dart';

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
        'flag': '🇰🇷',
        'uni': '본부',
        'imageUrl': null,
      },
      {
        'title': '[꿀팁] 학교 앞 가성비 식당 리스트 정리 (24년 ver)',
        'content': '선배들이 추천하는 진짜 맛집만 모았습니다. 점심 시간 피해서 가세요.',
        'author': '쩝쩝박사',
        'date': '2024.02.01',
        'likes': 85,
        'comments': 42,
        'flag': '🇻🇳',
        'uni': '경성대',
        'imageUrl': 'https://picsum.photos/200/200',
      },
      {
        'title': '교양 "영화의 이해" 수강 후기',
        'content': '팀플 없고 과제도 영화 감상문 하나라 편해요. 교수님도 좋으심.',
        'author': '익명',
        'date': '2024.01.28',
        'likes': 64,
        'comments': 8,
        'flag': '🇨🇳', 
        'uni': '부경대',
        'imageUrl': null,
      },
      {
        'title': '자취생을 위한 분리수거 가이드',
        'content': '헷갈리는 플라스틱, 비닐 분리수거 방법 확실하게 정리해드립니다.',
        'author': '자취만렙',
        'date': '2024.01.25',
        'likes': 52,
        'comments': 12,
        'flag': '🇯🇵',
        'uni': '부산대',
        'imageUrl': 'https://source.unsplash.com/random/200x200/?recycling',
      },
      {
        'title': '도서관 스터디룸 예약 방법 변경 안내',
        'content': '이제 모바일 앱으로도 예약 가능합니다. 당일 예약은 불가능하니 참고하세요.',
        'author': '도서관자치위',
        'date': '2024.01.20',
        'likes': 30,
        'comments': 4,
        'flag': '🇺🇸',
        'uni': '동아대',
        'imageUrl': null,
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
                  // Use standardized CommunityPostItem
                  return CommunityPostItem(
                    post: post,
                    showBoardName: false, // Don't verify board name for this specific list if not needed, or true if desired
                    contentMaxLines: 2, // Standard 2 lines
                    showMetadata: true, // Show Footer (Likes, Comments, User)
                  );
                },
              ),
            );
          }
        }
