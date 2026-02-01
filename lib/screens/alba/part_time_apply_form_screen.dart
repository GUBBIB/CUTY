import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/user_provider.dart';

class PartTimeApplyFormScreen extends ConsumerWidget {
  const PartTimeApplyFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("시간제 취업 신청서", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "마지막 단계입니다!\n사업주 정보를 확인해주세요.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 32),

            // 1. 유저 정보 (자동 입력됨)
            const Text("신청자 정보", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildInfoRow("이름", user.name),
                  const SizedBox(height: 8),
                  _buildInfoRow("소속", user.university),
                  const SizedBox(height: 8),
                  _buildInfoRow("비자", user.visaType),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. 사업주/근로계약 정보 (Mock)
            const Text("근로지 정보", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildTextField("상호명 (사업자 등록증 상)", "쿠티 편의점 역삼점"),
            const SizedBox(height: 16),
            _buildTextField("사업자 등록번호", "123-45-67890"),
            const SizedBox(height: 16),
            _buildTextField("담당자 연락처", "010-1234-5678"),
            
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: const Text("신청 완료"),
                       content: const Text("시간제 취업 허가 신청이 완료되었습니다.\n심사 결과는 약 3일 내에 통보됩니다."),
                       actions: [
                         TextButton(
                           onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close Form
                              Navigator.pop(context); // Close Check
                              Navigator.pop(context); // Close Consent (Back to Home)
                           },
                           child: const Text("확인"),
                         )
                       ],
                     )
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Blue-900
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "최종 신청하기",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        )
      ],
    );
  }
}
