import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  final String assetPath;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double size;
  final double iconSize;

  const SocialLoginButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.size = 50.0,
    this.iconSize = 50.0
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}