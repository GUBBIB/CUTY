import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/gen/app_localizations.dart';

class F27ConceptCard extends StatelessWidget {
  const F27ConceptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2B4D).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF6C63FF), size: 24),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.conceptTitle,
                style: GoogleFonts.notoSansKr(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2B4D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Concept Formula (Visual Equation)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFormulaBadge(AppLocalizations.of(context)!.conceptFormula1, Colors.grey[700]!, Colors.grey[200]!),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.add_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    _buildFormulaBadge(AppLocalizations.of(context)!.conceptFormula2, const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey[600]),
                    ),
                    Expanded(
                      child: _buildFormulaBadge(AppLocalizations.of(context)!.conceptFormula3, const Color(0xFF6C63FF), const Color(0xFFEDE7F6)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Text Update
                Text(
                  AppLocalizations.of(context)!.conceptDesc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Comparison Table
          Text(
            AppLocalizations.of(context)!.conceptWhy,
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2B4D),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              // Header Row
              Row(
                children: [
                  const SizedBox(width: 70), // Spacer for title
                  Expanded(child: Center(child: Text(AppLocalizations.of(context)!.conceptVisaE7, style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(AppLocalizations.of(context)!.conceptVisaF27, style: GoogleFonts.notoSansKr(fontSize: 12, color: const Color(0xFF6C63FF), fontWeight: FontWeight.bold)))),
                ],
              ),
              const SizedBox(height: 8),

              _buildCompareListRow(AppLocalizations.of(context)!.conceptRow1Title, AppLocalizations.of(context)!.conceptRow1Bad, AppLocalizations.of(context)!.conceptRow1Good),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow(AppLocalizations.of(context)!.conceptRow2Title, AppLocalizations.of(context)!.conceptRow2Bad, AppLocalizations.of(context)!.conceptRow2Good),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow(AppLocalizations.of(context)!.conceptRow3Title, AppLocalizations.of(context)!.conceptRow3Bad, AppLocalizations.of(context)!.conceptRow3Good),
              Container(height: 1, color: Colors.grey[100]),
              _buildCompareListRow(AppLocalizations.of(context)!.conceptRow4Title, AppLocalizations.of(context)!.conceptRow4Bad, AppLocalizations.of(context)!.conceptRow4Good),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansKr(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompareListRow(String title, String bad, String good) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bad,
                    style: GoogleFonts.notoSansKr(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    good,
                    style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF6C63FF)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
