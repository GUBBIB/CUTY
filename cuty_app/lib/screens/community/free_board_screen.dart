import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import 'widgets/community_post_item.dart' as widgets;

class FreeBoardScreen extends ConsumerStatefulWidget {
  const FreeBoardScreen({super.key});

  @override
  ConsumerState<FreeBoardScreen> createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends ConsumerState<FreeBoardScreen> {
  // Filter state
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['전체', '잡담', '질문', '정보', '후기'];

  // Mock Data
  final List<Map<String, dynamic>> _posts = [
    {
      'title': '한국에서 알바 구할 때 한국어 능력 얼마나 중요해?',
      'content': '토픽 4급인데 힘들까? 사장님들이 보통 뭐 물어보시는지 궁금해 ㅠㅠ 면접 꿀팁 좀 알려주라...',
      'author': '비빔밥러버', // Changed nickname
      'flag': '🇻🇳',
      'uni': '경성대',
      'time': '10분 전',
      'likes': 12,
      'comments': 5,
      'imageUrl': null, 
    },
    {
      'title': '이번 학기 수강신청 망했는데 시간표 좀 봐줘',
      'content': '공강 4시간 실화냐... 학교 근처에서 시간 때울만한 곳 추천 좀. 카페 말고 다른 곳 있어?',
      'author': '배고픈대학생',
      'flag': '🇨🇳',
      'uni': '부경대',
      'time': '35분 전',
      'likes': 8,
      'comments': 14,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?university',
    },
    {
      'title': 'D-2 비자 연장 후기 (하이코리아 방문 예약 필수)',
      'content': '오늘 출입국 관리 사무소 다녀왔는데 사람이 진짜 많더라고. 서류 미리 안 챙겼으면 큰일 날 뻔...',
      'author': '비자마스터',
      'flag': '🇯🇵',
      'uni': '부산대',
      'time': '1시간 전',
      'likes': 45,
      'comments': 22,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?passport,document',
    },
    {
      'title': '신촌 근처 자취방 월세 시세 어떻게 돼?',
      'content': '보증금 1000에 60이면 적당한건가? 신축 오피스텔 기준이야!',
      'author': '자취꿈나무',
      'flag': '🇲🇳',
      'uni': '동아대',
      'time': '2시간 전',
      'likes': 5,
      'comments': 2,
      'imageUrl': null,
    },
     {
      'title': '2026년 1학기 장학금 신청 기간 정리',
      'content': '다들 놓치지 말고 신청해! 성적 장학금이랑 근로 장학금 중복 수혜 가능한지도 확인해봐.',
      'author': '장학금사냥꾼',
      'flag': '🇺🇸',
      'uni': '해양대',
      'time': '3시간 전',
      'likes': 82,
      'comments': 15,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?money,student',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '자유게시판',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Post List
          Expanded(
            child: ListView.separated(
              itemCount: _posts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                return widgets.CommunityPostItem(post: _posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('글쓰기 (Mock)')));
        },
        backgroundColor: const Color(0xFF1E1E1E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
