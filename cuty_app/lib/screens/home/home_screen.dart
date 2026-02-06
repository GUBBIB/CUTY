import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view_model.dart';
import '../../providers/home_view_provider.dart';
import '../jobs/jobs_home_screen.dart';
import 'widgets/home_header_v2.dart';
import 'widgets/home_menu_grid.dart';
import 'widgets/schedule_list.dart';
import 'widgets/character_section.dart';
import 'widgets/popular_posts_preview.dart';
import '../schedule/schedule_screen.dart';
import 'widgets/fortune_cookie_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Note: In ConsumerState, ref is available directly as a property
    final state = ref.watch(homeViewModelProvider);

    // View Switching Logic
    if (ref.watch(homeViewProvider) == 'job') {
       return Container(
        color: Colors.white, // Job Screen Background
        width: double.infinity,
        height: double.infinity,
        child: const SafeArea(
          bottom: false,
          child: JobHomeScreen(),
        ),
      );
    }

    // Default Dashboard View
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 12, 0),
                      child: HomeHeader(),
                    ),
                    const HomeMenuGrid(),
                    
                    // Flexible Gap 1
                    const Spacer(flex: 2),

                    // [Character Hero Section]
                    SizedBox(
                      height: 300, 
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          // Character (Centered)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: const IgnorePointer(
                              child: CharacterSection(),
                            ),
                          ),
                          // Speech Bubble (Above Character)
                          Positioned(
                            top: 30, 
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      "오늘도 힘내! 🍀",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // Optional Triangle Tail
                                  CustomPaint(
                                    painter: _TrianglePainter(Colors.white),
                                    size: const Size(12, 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Fortune Cookie (Character's Right Hand -> Screen Left)
                          Positioned(
                            bottom: 110, 
                            right: 80,   
                            child: const FortuneCookieWidget(),
                          ),
                        ],
                      ),
                    ),

                    // Flexible Gap 2
                    const Spacer(flex: 1),

                    // [Status Message Card] (ScheduleList)
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                            );
                          },
                          child: const ScheduleList(),
                        ),
                      ),
                    ),

                    // Flexible Gap 3
                    const Spacer(flex: 1),

                    // [Community Section] - FULL WIDTH SHEET
                    const PopularPostsPreview(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
