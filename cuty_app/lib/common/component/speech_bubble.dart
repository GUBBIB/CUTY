import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: const Color(0xFF1D3561), width: 1.5),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Color(0xFF1D3561),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        CustomPaint(
          painter: _TrianglePainter(),
          size: const Size(20, 15),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF1D3561)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    final borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(size.width / 2, size.height);
    borderPath.lineTo(size.width, 0);
    canvas.drawPath(borderPath, borderPaint);

    final eraserPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0;
    canvas.drawLine(Offset(2, 0), Offset(size.width - 2, 0), eraserPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}