import 'package:flutter/material.dart';

class NoticeBanner extends StatelessWidget {

  final String content;
  final String icon;
  final VoidCallback? onTab;

  const NoticeBanner({
    required this.content,
    required this.icon,
    this.onTab,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),


        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 18)),

            SizedBox(width: 8),

            Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
      )
    );
  }
}