import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SchoolVisaScreen extends ConsumerStatefulWidget {
  const SchoolVisaScreen({super.key});

  @override
  ConsumerState<SchoolVisaScreen> createState() => _SchoolVisaScreenState();
}

class _SchoolVisaScreenState extends ConsumerState<SchoolVisaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '학교생활형 비자',
          style: GoogleFonts.notoSansKr(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '학교생활형 비자 준비 중입니다.',
              style: GoogleFonts.notoSansKr(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
