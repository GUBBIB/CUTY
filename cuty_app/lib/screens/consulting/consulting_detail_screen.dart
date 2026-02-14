import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultingDetailScreen extends StatelessWidget {
  const ConsultingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "1:1 프리미엄 컨설팅",
          style: GoogleFonts.notoSansKr(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.support_agent,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              "서비스 준비 중입니다.",
              style: GoogleFonts.notoSansKr(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "상세 커리큘럼과 진단 로직을 기획하고 있습니다.",
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
