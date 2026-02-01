import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeechBubbleWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const SpeechBubbleWidget({
    super.key, 
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('말풍선 클릭됨');
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E), // Dark Navy
          ),
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
