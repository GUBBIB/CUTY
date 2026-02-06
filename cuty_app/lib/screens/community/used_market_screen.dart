import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsedMarketScreen extends StatefulWidget {
  const UsedMarketScreen({super.key});

  @override
  State<UsedMarketScreen> createState() => _UsedMarketScreenState();
}

class _UsedMarketScreenState extends State<UsedMarketScreen> {
  // Filter state
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['전체', '판매', '나눔', '구해요'];

  // Mock Data
  final List<Map<String, dynamic>> _posts = [
    {
      'category': '판매',
      'title': '아이패드 에어 5세대 64GB 스페이스 그레이 팝니다',
      'content': '작년 3월 구매했고 찍힘이나 기스 전혀 없습니다. 박스 풀셋이에요.',
      'price': 650000,
      'author': '사과농장',
      'time': '5분 전',
      'likes': 12,
      'comments': 3,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?ipad,tablet',
      'status': '판매중',
    },
    {
      'category': '나눔',
      'title': '전공책 나눔합니다 (경영학원론, 마케팅관리)',
      'content': '필기 조금 되어있는데 공부하는데 지장 없습니다. 학교 정문에서 드려요.',
      'price': 0,
      'author': '졸업반',
      'time': '30분 전',
      'likes': 24,
      'comments': 15,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?book',
      'status': '예약중',
    },
    {
      'category': '판매',
      'title': '자취방 정리합니다 (전자레인지, 행거, 전신거울)',
      'content': '일괄 구매하시면 네고 해드립니다. 직접 가져가셔야 해요.',
      'price': 50000,
      'author': '떠나는나그네',
      'time': '1시간 전',
      'likes': 8,
      'comments': 6,
      'imageUrl': 'https://source.unsplash.com/random/200x200/?furniture',
      'status': '판매중',
    },
    {
      'category': '구해요',
      'title': '토픽(TOPIK) 2급 책 구합니다',
      'content': '깨끗한 책 우대합니다. 정가보다 싸게 사고 싶어요.',
      'price': 0, // Requesting usually doesn't show price or shows budget
      'author': '한국어초보',
      'time': '3시간 전',
      'likes': 2,
      'comments': 1,
      'imageUrl': null, // No image required for requests
      'status': '구하는중',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '중고장터',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
               border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[index],
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Post List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _posts.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                return _buildUnifiedListItem(_posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('물건 등록하기 (Mock)')));
        },
        backgroundColor: const Color(0xFF43A047), // Green for Market
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildUnifiedListItem(Map<String, dynamic> post) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thumbnail (Left Side) - Mandatory
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post['imageUrl'] ?? '',
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 84,
                        height: 84,
                        color: Colors.grey[200],
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Status Overlay (e.g., Sold Out, Reserved)
                  if (post['status'] != '판매중' && post['status'] != '구하는중')
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            post['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // 2. Text Info (Right Side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      post['title'],
                      style: GoogleFonts.notoSansKr(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Price (Functionally replaces Content)
                    Text(
                      "${_formatPrice(post['price'])}원",
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        Text(
                          post['author'],
                          style: GoogleFonts.notoSansKr(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " · ${post['time']}",
                          style: GoogleFonts.notoSansKr(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                         Icon(Icons.favorite_border, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          '${post['likes']}',
                          style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 8),
                         Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          '${post['comments']}',
                          style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatPrice(int price) {
    if (price == 0) return "나눔";
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}
