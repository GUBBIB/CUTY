
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['전체', '내 지역 (부산)', '내 학교 (경성대)'];

  // Mock Data with Types
  final List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'type': 'text',
      'nationality': {'emoji': '🇻🇳', 'name': '베트남'},
      'region': '부산',
      'school': '경성대',
      'gender': 'Female',
      'content': '한국에서 알바 구할 때 한국어 능력 얼마나 중요해? 토픽 4급인데 힘들까?\n사장님들이 보통 뭐 물어보시는지 궁금해 ㅠㅠ',
      'likes': 12,
      'comments': 5,
      'time': '10분 전',
    },
    {
      'id': 2,
      'type': 'image',
      'nationality': {'emoji': '🇨🇳', 'name': '중국'},
      'region': '서울',
      'school': '건국대',
      'gender': 'Secret',
      'content': '이번 학기 시간표 망했다... 수강신청 실패해서 공강 4시간 생김.\n학교 근처 맛집 추천 좀 해줘! 혼밥 하기 좋은 곳으로.',
      'likes': 8,
      'comments': 14,
      'time': '35분 전',
    },
    {
      'id': 3,
      'type': 'poll',
      'nationality': {'emoji': '🇺🇸', 'name': '미국'},
      'region': '대전',
      'school': 'KAIST',
      'gender': 'Male',
      'content': 'What is better for lunch today? Help me choose!',
      'poll_options': ['Korean BBQ', 'Pizza & Pasta'],
      'poll_votes': [12, 5],
      'likes': 25,
      'comments': 8,
      'time': '1시간 전',
    },
     {
      'id': 4,
      'type': 'text',
      'nationality': {'emoji': '🇯🇵', 'name': '일본'},
      'region': '서울',
      'school': '연세대',
      'gender': 'Female',
      'content': '신촌 근처에서 자취방 구하고 있는데 월세 시세가 보통 어떻게 돼? \n보증금 1000에 60이면 적당한건가?',
      'likes': 5,
      'comments': 2,
      'time': '2시간 전',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자유게시판', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('글쓰기 화면으로 이동 (Mock)')));
        },
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.edit),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: const Color(0xFF1565C0),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // Feed List
          Expanded(
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final post = posts[index];
                return _FeedItem(post: post);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedItem extends StatelessWidget {
  final Map<String, dynamic> post;

  const _FeedItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('익명', style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E))),
                  Text(post['time'], style: GoogleFonts.notoSansKr(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag(text: '${post['nationality']['emoji']} ${post['nationality']['name']}', color: const Color(0xFFFFF3E0), textCol: const Color(0xFFEF6C00)),
              _buildTag(text: '${post['region']} ${post['school']}', color: const Color(0xFFF5F5F5), textCol: const Color(0xFF616161)),
              _buildGenderTag(post['gender']),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Text(post['content'], style: GoogleFonts.notoSansKr(fontSize: 14, color: const Color(0xFF1A1A2E), height: 1.5)),
          const SizedBox(height: 12),

          // Type-specific Content (Image/Poll)
          if (post['type'] == 'image') _buildImageContent(),
          if (post['type'] == 'poll') _buildPollContent(post['poll_options'], post['poll_votes']),

          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              _buildFooterItem(Icons.favorite_border_rounded, '${post['likes']}'),
              const SizedBox(width: 16),
              _buildFooterItem(Icons.chat_bubble_outline_rounded, '${post['comments']}'),
              const Spacer(),
              _buildTranslateButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Icon(Icons.image_rounded, color: Colors.grey, size: 40)),
    );
  }

  Widget _buildPollContent(List<String> options, List<int> votes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: List.generate(options.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(options[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('${votes[index]}표', style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTag({required String text, required Color color, required Color textCol}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: textCol)),
    );
  }

  Widget _buildGenderTag(String gender) {
    // Simplified logic for brevity
    Color bg = gender == 'Male' ? const Color(0xFFE3F2FD) : (gender == 'Female' ? const Color(0xFFFCE4EC) : const Color(0xFFF5F5F5));
    Color tx = gender == 'Male' ? const Color(0xFF1976D2) : (gender == 'Female' ? const Color(0xFFC2185B) : const Color(0xFF9E9E9E));
    IconData icon = gender == 'Male' ? Icons.male_rounded : (gender == 'Female' ? Icons.female_rounded : Icons.lock_outline_rounded);
    String label = gender == 'Male' ? '남성' : (gender == 'Female' ? '여성' : '비공개');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 12, color: tx), const SizedBox(width: 2), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tx))],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String count) {
    return Row(children: [Icon(icon, size: 18, color: Colors.grey[400]), const SizedBox(width: 4), Text(count, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }

  Widget _buildTranslateButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: const [
          Icon(Icons.g_translate_rounded, size: 14, color: Color(0xFF7B1FA2)),
          SizedBox(width: 4),
          Text('번역 보기', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
        ],
      ),
    );
  }
}
