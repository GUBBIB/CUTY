import 'package:flutter/material.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final String? imagePath; // For local assets like Capybara
  final IconData? icon;    // For simple icons

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.imagePath,
    this.icon,
  });
}
