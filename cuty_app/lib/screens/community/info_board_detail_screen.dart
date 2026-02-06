import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBoardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const InfoBoardDetailScreen({super.key, required this.post});

  @override
  State<InfoBoardDetailScreen> createState() => _InfoBoardDetailScreenState();
}

class _InfoBoardDetailScreenState extends State<InfoBoardDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Mock Data for Card News Pages
  final List<Map<String, String>> _pages = [
    {
      'image': 'https://source.unsplash.com/random/800x1200/?paper,document',
      'title': 'Step 1. 서류 준비하기',
      'description': '가장 먼저 필요한 서류를 준비해야 합니다.\n여권, 외국인등록증, 통합신청서, 수수료 등을 미리 챙겨주세요.',
    },
    {
      'image': 'https://source.unsplash.com/random/800x1200/?office,desk',
      'title': 'Step 2. 방문 예약하기',
      'description': '하이코리아(Hikorea) 웹사이트에서\n미리 방문 예약을 해야 대기 시간을 줄일 수 있습니다.',
    },
    {
      'image': 'https://source.unsplash.com/random/800x1200/?handshake,meeting',
      'title': 'Step 3. 창구 접수 및 심사',
      'description': '예약한 시간에 맞춰 출입국 관리 사무소를 방문하세요.\n번호표를 뽑고 순서를 기다리면 됩니다.',
    },
    {
      'image': 'https://source.unsplash.com/random/800x1200/?stamp,approved',
      'title': 'Step 4. 결과 확인 및 수령',
      'description': '심사가 완료되면 문자로 알림이 옵니다.\n여권을 지참하여 등록증을 수령하거나 우편으로 받을 수 있습니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Total pages = Content pages + Ending page
    final int totalPages = _pages.length + 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. PageView (Content)
          PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              if (index < _pages.length) {
                return _buildContentPage(_pages[index]);
              } else {
                return _buildEndingPage();
              }
            },
          ),

          // 2. Overlay Navigation (Top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        '${_currentPage + 1} / $totalPages',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / totalPages,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Action Bar (Fixed) - Hide on Ending Page if desired, or keep generic actions
          if (_currentPage < _pages.length)
            Positioned(
              bottom: 30,
              right: 20,
              child: Column(
                children: [
                  _buildSideAction(Icons.favorite_border, "1.2k"),
                  const SizedBox(height: 16),
                  _buildSideAction(Icons.bookmark_border, "Scrap"),
                  const SizedBox(height: 16),
                  _buildSideAction(Icons.share, "Share"),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentPage(Map<String, String> page) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          page['image']!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
        ),
        
        // Gradient Overlay (Bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),

        // Text Content
        Positioned(
          bottom: 50,
          left: 20,
          right: 80, // Space for side buttons
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page['title']!,
                style: GoogleFonts.notoSansKr(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                page['description']!,
                style: GoogleFonts.notoSansKr(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEndingPage() {
    return Container(
      color: const Color(0xFF121212), // Dark background
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 60),
          const SizedBox(height: 20),
          Text(
            "이 정보가 도움이 되셨나요?",
            style: GoogleFonts.notoSansKr(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          
          // Big Like Button
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.thumb_up, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "좋아요 누르기",
                    style: GoogleFonts.notoSansKr(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Business Link Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white30),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  "관련 중고장터 매물 보기",
                  style: GoogleFonts.notoSansKr(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
