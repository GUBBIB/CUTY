import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/user_provider.dart';

class PrivacySettingsModal extends ConsumerWidget {
  const PrivacySettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);

    if (user == null) {
      return const SizedBox(height: 200, child: Center(child: Text("로그인이 필요합니다.")));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔒 선택적 프로필 공개',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '커뮤니티 활동 시 보여질 정보를 선택하세요.',
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Options
            // 1. Nickname
            _buildPrivacyOption(
              context: context,
              label: "닉네임 공개",
              description: "비공개 시 '익명'으로 표시됩니다.",
              icon: Icons.person_outline,
              isPublic: !user.isNicknameHidden,
              onChanged: (value) => notifier.togglePrivacy('nickname'),
            ),
            const Divider(height: 1),
            
            // 2. Nationality (Reordered)
            _buildPrivacyOption(
              context: context,
              label: "국적 공개",
              description: "국기(🇻🇳) 아이콘이 표시됩니다.",
              icon: Icons.flag,
              isPublic: !user.isNationalityHidden,
              onChanged: (value) => notifier.togglePrivacy('nationality'),
            ),
            const Divider(height: 1),

            // 3. Gender
            _buildPrivacyOption(
              context: context,
              label: "성별 공개",
              description: "성별 아이콘이 표시됩니다.",
              icon: Icons.wc,
              isPublic: !user.isGenderHidden,
              onChanged: (value) => notifier.togglePrivacy('gender'),
            ),
            const Divider(height: 1),

            // 4. School
            _buildPrivacyOption(
              context: context,
              label: "학교명 공개",
              description: "학교 이름이 표시됩니다.",
              icon: Icons.school,
              isPublic: !user.isSchoolHidden,
              onChanged: (value) => notifier.togglePrivacy('school'),
            ),
            
            const SizedBox(height: 32),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A2E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption({
    required BuildContext context,
    required String label,
    required String description,
    required IconData icon,
    required bool isPublic,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isPublic,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A1A2E), // Custom active color
          ),
        ],
      ),
    );
  }
}
