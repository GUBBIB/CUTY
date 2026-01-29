import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/banner_item.dart';
import '../providers/job_providers.dart';

class PromotionBanner extends ConsumerStatefulWidget {
  const PromotionBanner({super.key});

  @override
  ConsumerState<PromotionBanner> createState() => _PromotionBannerState();
}

class _PromotionBannerState extends ConsumerState<PromotionBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int next = _currentPage + 1;
        if (next > 2) next = 0;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onArrowTap() {
    _resetTimer(); // Reset timer on interaction
    if (_pageController.hasClients) {
      int next = _currentPage + 1;
      if (next > 2) next = 0;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the banner list provider instead of just theme
    final bannersAsync = ref.watch(bannerListProvider);

    return Column(
      children: [
        // Main Banner Area with Slider
        SizedBox(
          height: 140,
          child: bannersAsync.when(
            data: (banners) {
              if (banners.isEmpty) return const SizedBox.shrink(); // Hide if empty
              
              // Ensure currentPage is valid if banner count changes
              // If controller is past the new count, reset to 0
              if (banners.length == 1 && _currentPage != 0) {
                 _currentPage = 0;
                 if (_pageController.hasClients) {
                   // Use post frame callback to avoid build-phase jumping
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     if (_pageController.hasClients) _pageController.jumpToPage(0);
                   });
                 }
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Listener(
                    onPointerDown: (_) => _timer?.cancel(),
                    onPointerUp: (_) => _startAutoScroll(),
                    onPointerCancel: (_) => _startAutoScroll(),
                    child: PageView.builder(
                      controller: _pageController,
                      clipBehavior: Clip.none,
                      itemCount: banners.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                         return _buildBannerItem(banners[index]);
                      },
                    ),
                  ),

                  // Global Arrow Button (Persistent)
                  if (banners.length > 1)
                  Positioned(
                    right: 35,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _onArrowTap,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => const SizedBox(height: 140),
          ),
        ),

        const SizedBox(height: 16),

        // Indicator Dots - Only show if we have banners
        bannersAsync.maybeWhen(
          data: (banners) {
            if (banners.length <= 1) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                final isActive = index == _currentPage;
                final theme = ref.watch(jobThemeProvider); // Get theme for indicator color needed here
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 24 : 8,
                  decoration: BoxDecoration(
                    color: isActive ? theme.primaryColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBannerItem(BannerItem item) {
    // 🎯 [팩토리 로직] 아이템 속성에 따라 적절한 위젯 반환
    if (item.title.contains("시간제 취업 허가")) {
      return AlbaPermitBanner(item: item);
    } else if (item.title.contains("첫 알바")) {
      return AlbaFirstStepBanner(item: item);
    } else if (item.title.contains("근로계약서")) {
      return AlbaContractBanner(item: item);
    } else if (item.imagePath != null && item.imagePath!.contains('semicut')) {
      return CareerMainBanner(item: item);
    } else if (item.title.contains("자소서") || item.title.contains("첨삭")) {
      return const CareerResumeBanner();
    } else {
      return CareerRocketBanner(item: item);
    }
  }
}

// -------------------------------------------------------
// 🟦 1. 시간제 취업 허가 (Mint-Purple / 캐릭터형)
// -------------------------------------------------------
class AlbaPermitBanner extends StatelessWidget {
  final BannerItem item;
  const AlbaPermitBanner({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseAlbaBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFB2EBF2), Color(0xFFE1BEE7)],
      ),
      leading: item.imagePath != null 
          ? Image.asset(item.imagePath!, height: 120) 
          : const SizedBox.shrink(),
      title: item.title,
      subtitle: item.subtitle,
      buttonStyle: _AlbaButtonStyle.white,
      leadingAlignment: Alignment.bottomCenter,
      onButtonTap: () => debugPrint("Clicked: 시간제 취업 허가"),
    );
  }
}

// -------------------------------------------------------
// 🟧 2. 첫 알바, 무엇부터? (Peach-Yellow / 아이콘형)
// -------------------------------------------------------
class AlbaFirstStepBanner extends StatelessWidget {
  final BannerItem item;
  const AlbaFirstStepBanner({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseAlbaBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFECB3), Color(0xFFFFCC80)], // 따뜻한 옐로우-피치
      ),
      leading: const Text("❓", style: TextStyle(fontSize: 60)),
      title: item.title,
      subtitle: item.subtitle,
      buttonStyle: _AlbaButtonStyle.white,
      buttonText: "확인하기",
      onButtonTap: () => debugPrint("Clicked: 첫 알바 가이드"),
    );
  }
}

// -------------------------------------------------------
// 🟩 3. 안전한 근로계약서 (Teal-Cyan / 아이콘형)
// -------------------------------------------------------
class AlbaContractBanner extends StatelessWidget {
  final BannerItem item;
  const AlbaContractBanner({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return _BaseAlbaBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFB2DFDB), Color(0xFF80DEEA)], // 시원한 티일-시안
      ),
      leading: const Text("🛡️", style: TextStyle(fontSize: 60)),
      title: item.title,
      subtitle: item.subtitle,
      buttonStyle: _AlbaButtonStyle.white,
      buttonText: "확인하기",
      onButtonTap: () => debugPrint("Clicked: 근로계약서"),
    );
  }
}

// -------------------------------------------------------
// 🟥 4. 취업 탭 메인 배너 (독립 위젯)
// -------------------------------------------------------
class CareerMainBanner extends StatelessWidget {
  final BannerItem item;
  const CareerMainBanner({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24, top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // const 제거 (버튼 때문에)
              children: [ 
                const Text(
                  "취업역량 점수: --점", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const Text(
                  "취업비자연계 진단", 
                  style: TextStyle(fontSize: 14, color: Colors.white70)
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => debugPrint("Clicked: 스펙 진단하기"),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "스펙 진단하기",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 15, 
            bottom: 0, 
            child: Image.asset('assets/images/capy_corp_semicut.png', height: 130)
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 📄 5. [신규/복구] 자소서 첨삭 배너 (Indigo / 문서 이모지)
// -------------------------------------------------------
class CareerResumeBanner extends StatelessWidget {
  const CareerResumeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      // User requested "left: 15". Assuming left alignment of the content.
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Adjusted padding for better layout
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFFFAB91), // 예쁜 주황색
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Left align as per 'left: 15' suggestion
        children: [
          const Text("📄", style: TextStyle(fontSize: 48)), // 문서 이모지
          const SizedBox(width: 16), // Gap between emoji and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "전문가 자소서 첨삭", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const Text(
                  "합격률을 높이는 이력서 완성", 
                  style: TextStyle(fontSize: 13, color: Colors.white)
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 70.0), // Pulled back more (was 8)
                    child: GestureDetector(
                      onTap: () => debugPrint("Clicked: 자소서 첨삭 신청하기"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Text(
                          "신청하기", 
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 🚀 5. 취업 탭 로켓 배너 (독립 위젯)
// -------------------------------------------------------
class CareerRocketBanner extends StatelessWidget {
  final BannerItem item;
  const CareerRocketBanner({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 15), // Add padding for content spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF29B6F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🚀", style: TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "IT/스타트업 인턴십", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const Text(
                  "한국 스타트업에서 커리어를 시작하세요.", 
                  style: TextStyle(fontSize: 13, color: Colors.white)
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 70.0), // Pulled back more (was 8)
                    child: GestureDetector(
                      onTap: () => debugPrint("Clicked: IT/스타트업 인턴십 신청하기"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Text(
                          "신청하기", 
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 🛠️ 알바 배너 전용 공통 베이스 (디테일 분리)
// -------------------------------------------------------
enum _AlbaButtonStyle { gradient, white }

class _BaseAlbaBanner extends StatelessWidget {
  final Gradient gradient;
  final Widget leading;
  final String title;
  final String subtitle;
  final _AlbaButtonStyle buttonStyle;
  final String buttonText; // 버튼 텍스트 추가
  final AlignmentGeometry? leadingAlignment;

  const _BaseAlbaBanner({
    required this.gradient, 
    required this.leading,
    required this.title, 
    required this.subtitle, 
    required this.buttonStyle,
    this.buttonText = "신청하러 가기", // 기본값 설정
    this.leadingAlignment,
    this.onButtonTap, // Callback for button tap
  });

  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        gradient: gradient,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 25, 
            top: 0, 
            bottom: 0, 
            child: Align(
              alignment: leadingAlignment ?? Alignment.center,
              child: leading
            )
          ),
          Positioned(
            left: 145, 
            top: 0, 
            bottom: 0,
            right: 20,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2)
                  ),
                  Text(
                    subtitle, 
                    style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.2)
                  ),
                  const SizedBox(height: 12),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    if (buttonStyle == _AlbaButtonStyle.gradient) {
      // 그라데이션 버튼
      return GestureDetector(
        onTap: onButtonTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [Color(0xFF4DB6AC), Color(0xFF7E57C2)]),
            boxShadow: [
               BoxShadow(
                 color: const Color(0xFF7986CB).withValues(alpha: 0.4), 
                 blurRadius: 8,
                 offset: const Offset(0, 4),
               ),
             ],
          ),
          child: Text(
            buttonText, 
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
          ),
        ),
      );
    } else {
      // 화이트 버튼
      return GestureDetector(
        onTap: onButtonTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            buttonText, 
            style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)
          ),
        ),
      );
    }
  }
}
