import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharacterSection extends StatelessWidget {
  final String imagePath;
  final String message;

  const CharacterSection({
    super.key, 
    required this.imagePath, 
    required this.message,
  });

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
                'assets/images/capy_wink.png', // Note: hardcoded in original, should probably use imagePath or handle logic if imagePath differs
                width: MediaQuery.of(context).size.width * 0.40, // 40% Width (Micro-Size)
                fit: BoxFit.fitWidth,
                color: Colors.white.withValues(alpha: 0.1), // Tone Up: Brighten slightly
                colorBlendMode: BlendMode.screen,
              ),
              // Layer 2: Item (Overlay - Fortune Cookie)
              Positioned(
                right: -15, // Solved: Just a bit more to the right
                bottom: 95, // Kept same
                child: GestureDetector(
                  onTap: () {
                    debugPrint('포춘쿠키 클릭됨');
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
                debugPrint('말풍선 클릭됨');
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
            color: Colors.black.withValues(alpha: 0.05),
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
  final double tailWidth = 20.0;
  final double tailHeight = 10.0;
  final double radius = 24.0;

  const _SpeechBubbleBorder();

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
