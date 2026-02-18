import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_type_screen.dart';

class VisaTypeTestBanner extends StatelessWidget {
  const VisaTypeTestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VisaTypeScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100, // Fixed height for banner feel
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)], // Lavender -> Pink
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA18CD1).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Pattern (Optional bubble effect)
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "나는 어떤 비자 카피바라일까? 🤔",
                          style: GoogleFonts.notoSansKr(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "30초 만에 내 유형 알아보기! >",
                            style: GoogleFonts.notoSansKr(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Image
                  Image.asset(
                    'assets/images/capy_wink.png', // Using fallback as requested/planned
                    width: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (_,__,___) => const Icon(Icons.search, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
