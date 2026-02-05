import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_goal_selection_screen.dart';

class GlobalVisaScreen extends StatelessWidget {
  const GlobalVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context), 
        ),
        title: Text(
          '글로벌형 로드맵', 
          style: GoogleFonts.poppins(color: const Color(0xFF1A1A2E), fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VisaGoalSelectionScreen(
                     onGoalSelected: (goal) {}, // Required parameter dummy
                  )), 
                );
              },
              icon: const Icon(Icons.swap_horiz, size: 20, color: Color(0xFF6C63FF)),
              label: Text("Class 변경", style: GoogleFonts.poppins(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text("글로벌형 비자 로드맵 준비 중입니다.", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
