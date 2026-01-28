import 'package:flutter/material.dart';
import '../../../../config/app_assets.dart'; // Use AppAssets

class PromotionBanner extends StatelessWidget {
  const PromotionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140, // Height based on mockup
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB2DFDB), // Lighter Teal
            Color(0xFF7986CB), // Indigo/Purple accent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Text Content
          Positioned(
            left: 110, // Make room for image on left
            top: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '시간제 취업 허가,',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E), // Dark Navy
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '쿠티와 함께 쉽고 정확하게!',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF1A1A2E).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Character Image (Left)
          Positioned(
            left: 10,
            bottom: 0,
            child: Image.asset(
              AppAssets.capyBow, // Using Bow as placeholder for "Business" look
              width: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.white.withValues(alpha: 0.5),
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          // Arrow Icon (Right)
          Positioned(
            right: 15,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
