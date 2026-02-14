import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';
import 'package:cuty_app/screens/consulting/consulting_detail_screen.dart';

class VisaConsultingBanner extends StatelessWidget {
  const VisaConsultingBanner({super.key});

  @override
  @override
  @override
  @override
  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, 
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF152349), // Deep Blue
            Color(0xFF203A6F), // Royal Blue
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37), // Simple Gold Border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge, // Clip the ribbon
      child: Stack(
        children: [
          // 1. Corner Decorations (Top-Left & Bottom-Right)
          Positioned(
            top: 8,
            left: 8,
            child: Icon(Icons.auto_awesome, color: const Color(0xFFD4AF37).withOpacity(0.3), size: 16),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Icon(Icons.auto_awesome, color: const Color(0xFFD4AF37).withOpacity(0.3), size: 16),
          ),

          // 2. Main Content
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConsultingDetailScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    // Character
                    Hero(
                      tag: 'visa_consulting_char',
                      child: Image.asset(
                        'assets/images/capy_business.png',
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Texts
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.banner_vip_label,
                            style: GoogleFonts.notoSansKr(
                              color: const Color(0xFFD4AF37),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFFE082), Color(0xFFD4AF37)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              AppLocalizations.of(context)!.banner_consulting_title,
                              style: GoogleFonts.notoSansKr(
                                color: Colors.white, // Masked by shader
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.of(context)!.banner_consulting_desc,
                            style: GoogleFonts.notoSansKr(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // Custom Gold Outlined Button
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF152349), // Matches Gradient Start
                              border: Border.all(color: const Color(0xFFD4AF37), width: 1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.banner_btn_details,
                                  style: GoogleFonts.notoSansKr(
                                    color: const Color(0xFFD4AF37),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios, size: 8, color: Color(0xFFD4AF37)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 3. Diagonal Ribbon Banner (Top Right)
          Positioned(
            top: 12,
            right: -32,
            child: Transform.rotate(
              angle: 0.785, // 45 degrees (pi/4)
              child: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFC107), // Amber
                      Color(0xFFFFE082), // Pale Gold
                      Color(0xFFD4AF37), // Metallic Gold
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.banner_ribbon_text,
                  style: GoogleFonts.oswald( // Elegant condensed font or similar
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723), // Dark Brown
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
