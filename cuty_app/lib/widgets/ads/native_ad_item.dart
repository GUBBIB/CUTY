import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/community_model.dart';
import '../../models/ad_model.dart';

class NativeAdItem extends StatelessWidget {
  final BoardType? boardType;

  const NativeAdItem({
    super.key,
    this.boardType,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch Targeted Ad
    final ads = AdItem.getAds(boardType);
    final ad = ads.isNotEmpty ? ads.first : AdItem.dummyAds.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
           bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Sponsor + Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Text(
                  'Sponsored',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ad.sponsorName, // Dynamic
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          
          // Content Layout (Image + Text)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title, // Dynamic
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '지금 바로 확인해보세요! ${ad.sponsorName}가 제공하는 특별한 혜택.', // Mock Description
                      style: GoogleFonts.notoSansKr(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Ad Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                   image: const DecorationImage(
                      image: AssetImage('assets/images/ad_placeholder.png'), // Should use ad.imageUrl if valid asset exists, else placeholder
                      fit: BoxFit.cover,
                    ),
                ),
                // child: const Icon(Icons.shopping_cart, color: Colors.grey), // Removed
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          // CTA Button (Native Style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Light Blue
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '지금 확인하기',
              style: GoogleFonts.notoSansKr(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1976D2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
