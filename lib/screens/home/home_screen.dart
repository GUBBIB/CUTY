import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_assets.dart';
import 'home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      // backgroundColor removed, handled by Container gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFEF5), // Bright Ivory
              Color(0xFFFFE4C4), // Warm Apricot/Beige
            ],
          ),
        ),
        // Modified SafeArea: bottom=false allows the white sheet to extend to the very bottom device edge
        child: SafeArea(
          bottom: false, 
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(homeViewModelProvider.notifier).refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 12, 0),
                    child: _HomeHeader(),
                  ),
                  const _QuickAccessMenu(),
                  // [Layout Logic] Top Gap Added to Push Content Down (Re-balancing)
                  const SizedBox(height: 30), 

                  // [Z-Layered Hero Stack]
                  SizedBox(
                    height: 345, // Reduced from 380 to pull everything up
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Layer 1: Schedule Card (Background Platform)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : state.schedule.isNotEmpty
                                  ? _ScheduleCard(item: state.schedule.first)
                                  : const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(child: Text("일정이 없습니다.")),
                                    ),
                        ),
                        // Layer 2: Contact Shadow (Middle - On top of Card)
                        Positioned(
                          bottom: 80, // Lowered from 85 to match slimmer card
                          child: Container(
                            height: 6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.15),
                              borderRadius: const BorderRadius.all(Radius.elliptical(100, 10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Layer 3: Character (Front - Standing on everything)
                        Positioned(
                          bottom: 80, // Lowered from 85 for alignment
                          left: 0,
                          right: 0,
                          child: _CharacterSection(
                            imagePath: state.characterImage,
                            message: "오늘도 힘내보자!",
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gap between Card and Community
                  const SizedBox(height: 20),

                  // [Community Section] - FULL WIDTH SHEET
                  Container(
                    width: double.infinity, // Key: Full Width
                    margin: EdgeInsets.zero, // Key: No Margins
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0), // Key: Internal Padding Reduced (15->12)
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                  GestureDetector(
                                    onTap: () {
                                      print('더보기 클릭됨');
                                    },
                                    child: Text(
                                      '더보기', // See more
                                      style: GoogleFonts.notoSansKr(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          const SizedBox(height: 10), // Reduced gap (15->10)
                          // Horizontal List
                          SizedBox(
                            height: 100, // Reduced List Height (110->100)
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: 3,
                              separatorBuilder: (_, __) => const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFEEEEEE)),
                                  ),
                                  child: Material(
                                    color: const Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.circular(16),
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      onTap: () {
                                        print('${index == 0 ? "인기글" : "정보"} 클릭됨');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15), // Further reduced vertical padding (8->4)
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                         decoration: BoxDecoration(
                                           color: const Color(0xFFFFF3E0),
                                           borderRadius: BorderRadius.circular(8),
                                         ),
                                         child: Text(
                                           index == 0 ? "🔥 인기글" : "💡 정보",
                                           style: GoogleFonts.notoSansKr(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.orange),
                                         ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        index == 0 ? "수강신청 꿀팁!" : "오늘 학식 추천",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.notoSansKr(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "성공하셨나요? 저는...",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.notoSansKr(
                                          fontSize: 11,
                                          color: const Color(0xFF9E9E9E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                              },
                            ),
                          ),
                          // Extra space for visual balance
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CUTY',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        IconButton(
          onPressed: () {
            print('알림 클릭됨');
          },
          icon: const Icon(
            Icons.notifications_none,
            size: 32,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _QuickAccessMenu extends StatelessWidget {
  const _QuickAccessMenu();

  @override
  Widget build(BuildContext context) {
    // Define menu items
    final List<Map<String, dynamic>> menuItems = [
      {
        'label': '비자',
        'icon': Icons.public_outlined,
        'bg': const Color(0xFFE1F5FE), // Light Blue
        'iconColor': const Color(0xFF0277BD), // Deep Blue
      },
      {
        'label': '서류지갑',
        'icon': Icons.wallet_outlined,
        'bg': const Color(0xFFFFF9C4), // Light Yellow
        'iconColor': const Color(0xFFF57F17), // Deep Yellow/Orange
      },
      {
        'label': '알바/취업',
        'icon': Icons.work_outline,
        'bg': const Color(0xFFE0F2F1), // Light Mint
        'iconColor': const Color(0xFF00695C), // Deep Teal
      },
      {
        'label': '학사정보',
        'icon': Icons.school_outlined,
        'bg': const Color(0xFFF3E5F5), // Light Purple
        'iconColor': const Color(0xFF6A1B9A), // Deep Purple
      },
      {
        'label': '맛집',
        'icon': Icons.restaurant_menu,
        'bg': const Color(0xFFFFE0B2), // Light Orange
        'iconColor': const Color(0xFFEF6C00), // Deep Orange
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12), // Removed bottom padding
      child: Row(
        children: [
          for (int i = 0; i < menuItems.length; i++) ...[
            _MenuCard(
              icon: menuItems[i]['icon'] as IconData,
              label: menuItems[i]['label'] as String,
              backgroundColor: menuItems[i]['bg'] as Color,
              iconColor: menuItems[i]['iconColor'] as Color,
            ),
            if (i < menuItems.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            print('$label 메뉴 클릭됨');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48, // Adjusted width to fit smoothly within 72 - 16 padding
                  height: 40, // Height matching design feel
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 4), // Tight spacing
                Text(
                  label,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 11, // Slightly smaller for compact feel
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E), // Dark Navy
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterSection extends StatelessWidget {
  final String imagePath;
  final String message;

  const _CharacterSection({required this.imagePath, required this.message});

  @override
  Widget build(BuildContext context) {
    // [Layout Logic] Stack을 사용하여 이미지의 투명 여백 위로 말풍선을 겹쳐 올림
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none, // Allow bubble to float above bounds
      children: [
        // Layer 1: Character Base
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // Reduced from 60 to 20 to save vertical space
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Layer 1: Body (Base)
              Image.asset(
                'assets/images/capy_wink.png',
                width: MediaQuery.of(context).size.width * 0.40, // 40% Width (Micro-Size)
                fit: BoxFit.fitWidth,
                color: Colors.white.withOpacity(0.1), // Tone Up: Brighten slightly
                colorBlendMode: BlendMode.screen,
              ),
              // Layer 2: Item (Overlay - Fortune Cookie)
              Positioned(
                right: -15, // Solved: Just a bit more to the right
                bottom: 95, // Kept same
                child: GestureDetector(
                  onTap: () {
                    print('포춘쿠키 클릭됨');
                  },
                  child: Image.asset(
                    'assets/images/item_fortune_cookie.png',
                    width: 45, // Requested size
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Layer 2: Speech Bubble Overlay
        Positioned(
          top: -45, // Moved up significantly (negative) to absolutely clear head
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.45, // Slightly wider than body
            ),
            child: GestureDetector(
              onTap: () {
                print('말풍선 클릭됨');
              },
              child: SpeechBubble(message: message),
            ),
          ),
        ),
      ],
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Increased padding
      margin: const EdgeInsets.only(bottom: 0), // Tail space handled by shape
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: const _SpeechBubbleBorder(),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.notoSansKr(
          fontSize: 15, // Reduced to 15.0 for micro layout
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A2E), // Dark Navy
        ),
      ),
    );
  }
}

class _SpeechBubbleBorder extends ShapeBorder {
  final double tailWidth;
  final double tailHeight;
  final double radius;

  const _SpeechBubbleBorder({
    this.tailWidth = 20.0,
    this.tailHeight = 10.0,
    this.radius = 24.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: tailHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - tailHeight);
    
    return Path()
      ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(radius)))
      ..moveTo(r.center.dx - tailWidth / 2, r.bottom)
      ..lineTo(r.center.dx, rect.bottom)
      ..lineTo(r.center.dx + tailWidth / 2, r.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}



class _ScheduleCard extends StatelessWidget {
  final dynamic item;

  const _ScheduleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), // Floating Style
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Rounded 16
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            print('스케줄 카드 클릭됨'); // Log for backend
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), // Adjusted for overlap (Slimmer)
            child: Row(
              children: [
                // Left: Time
                Text(
                  "10:00", // Hardcoded for design or use item.time
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 20),
                // Middle: Divider
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFEEEEEE),
                ),
                const SizedBox(width: 20),
                // Right: Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "경제론", // Economics
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "사회관 304호", // Social Bldg 304
                        style: GoogleFonts.notoSansKr(
                          fontSize: 14,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1E2B4D),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: '상점'),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이'),
      ],
      currentIndex: 1,
      onTap: (index) {},
    );
  }
}
