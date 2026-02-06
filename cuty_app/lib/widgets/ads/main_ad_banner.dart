import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../models/ad_model.dart';
import '../../models/community_model.dart'; // For BoardType

class MainAdBanner extends StatefulWidget {
  final BoardType? boardType; // Targeted Ads support

  const MainAdBanner({
    super.key,
    this.boardType,
  });

  @override
  State<MainAdBanner> createState() => _MainAdBannerState();
}

class _MainAdBannerState extends State<MainAdBanner> {
  final PageController _pageController = PageController();
  late List<AdItem> _ads; // Late init
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ads = AdItem.getAds(widget.boardType); // Use logic
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= _ads.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _ads.length,
            itemBuilder: (context, index) {
              final ad = _ads[index];
              return GestureDetector(
                onTapDown: (_) => _stopAutoScroll(), // Pause on touch
                onTapUp: (_) => _startAutoScroll(),  // Resume on release
                onTapCancel: () => _startAutoScroll(),
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${ad.sponsorName} 광고 클릭됨 (Link: ${ad.linkUrl})')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Fallback color
                    borderRadius: BorderRadius.circular(16),
                     image: const DecorationImage(
                      image: AssetImage('assets/images/ad_placeholder.png'), // Fallback/Placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Overlay Gradient for Text Readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Text Content
                      Positioned(
                        left: 20,
                        bottom: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.sponsorName,
                              style: GoogleFonts.notoSansKr(
                                color: Colors.yellowAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ad.title,
                              style: GoogleFonts.notoSansKr(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // [AD] Badge (Top Right of the banner area, slightly inside)
          Positioned(
            top: 10,
            right: 26, // 16 margin + 10 padding
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 0.5),
              ),
              child: const Text(
                'AD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _ads.asMap().entries.map((entry) {
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
