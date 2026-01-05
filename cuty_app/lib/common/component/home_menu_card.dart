import 'package:flutter/material.dart';

class HomeMenuCard extends StatelessWidget{
  final Color backgroundColor;
  final String label;
  final Widget icon;

  const HomeMenuCard({
    super.key,
    required this.backgroundColor,
    required this.label,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, height: 100, // 일단 고정
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}