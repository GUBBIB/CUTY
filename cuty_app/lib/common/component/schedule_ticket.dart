import 'package:flutter/material.dart';

class ScheduleTicket extends StatelessWidget {

  final String startTime;
  final String subject;
  final String room;

  const ScheduleTicket({
    required this.startTime,
    required this.subject,
    required this.room,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      clipper: const TicketClipper(holeRadius: 10),

      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildInfoColumn(
              icon: Icons.access_time,
              text: startTime,
              isBold: true
            ),

            const VerticalDivider(
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
              width: 30,
            ),

            Expanded(
              child: Center(
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const VerticalDivider(
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
              width: 30,
            ),

            _buildInfoColumn(
              icon: null,
              title: "Room",
              text: room,
              isBold: true
            )
          ],
        )
      )
    );
  }

  Widget _buildInfoColumn({IconData? icon, String? title, required String text, bool isBold = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(icon != null) ...[
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(height: 4),
        ] else if (title != null) ...[
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  const TicketClipper({
    required this.holeRadius
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = 20.0;

    path.moveTo(r, 0);

    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    path.lineTo(w, (h / 2) - holeRadius);
    path.arcToPoint(
      Offset(w, (h / 2) + holeRadius),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );

    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));

    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));

    path.lineTo(0, (h / 2) + holeRadius);
    path.arcToPoint(
      Offset(0, (h / 2) - holeRadius),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );

    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
  
  
}