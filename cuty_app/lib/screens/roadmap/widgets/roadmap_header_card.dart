import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadmapHeaderCard extends StatelessWidget {
  final String currentVisa;
  final String targetVisa;

  const RoadmapHeaderCard({
    super.key,
    required this.currentVisa,
    required this.targetVisa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Purple Theme Gradient
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A148C), // Dark Purple
            Color(0xFF7B1FA2), // Purple Accent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Goal Title & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 목표',
                    style: GoogleFonts.notoSansKr(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        targetVisa,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(연구/거주)',
                        style: GoogleFonts.notoSansKr(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Bottom Row: Roadmap Flow
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
             decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Step 1: D-2 (Current)
                _buildStep(
                  label: 'D-2',
                  isCurrent: true,
                ),
                
                 // Arrow
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),

                // Step 2: D-10
                _buildStep(
                  label: 'D-10',
                  isCurrent: false,
                ),

                // Arrow
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 14),

                // Step 3: Target
                _buildStep(
                  label: targetVisa.split(' ')[0], // Take first part if it has spaces
                  isCurrent: false,
                  isTarget: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String label,
    bool isCurrent = false,
    bool isTarget = false,
  }) {
    // Current Step Style
    if (isCurrent) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Badge
          Positioned(
            top: -18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE040FB), // Create a bright accent for badge
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Current',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Main Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4A148C), // Match Theme
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }
    
    // Inactive/Target Step Style
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: isTarget ? Border.all(color: Colors.white.withOpacity(0.5)) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
        ),
      ),
    );
  }
}
