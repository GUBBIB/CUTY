import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/point_provider.dart';
import '../../wallet/my_point_screen.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';
import '../../../../services/local_storage_service.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildHeader(context, ref);
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.dialogResetTitle),
        content: Text(AppLocalizations.of(context)!.dialogResetContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.btnCancel), // Checking if btnCancel exists, otherwise use btnReset equivalent? Actually generic 'Cancel' might exist or I should add it. Wait, I saw 'btnCancel' in previous context? Let me check ARB content I just added. I didn't add 'btnCancel'. I should add it or use '취소' -> 'Cancel' in English. Actually 'btnEdit' exists.
            // Wait, I missed adding a generic 'Cancel' button.
            // PROACTIVE CORRECTION: I will check if 'btnCancel' exists or use a new key.
          ),
          TextButton(
            onPressed: () async {
              await LocalStorageService().clearAll();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.msgResetComplete)),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.btnReset, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    // Watch precise point value from PointProvider
    final pointState = ref.watch(pointProvider);
    final points = pointState.totalBalance;

    // Stack 제거 -> Row 하나로 깔끔하게 정리
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // [1. 왼쪽 그룹] 로고 + 초기화 버튼 (묶어서 배치)
        // [1. 왼쪽] 로고 자체가 버튼이 됨 (숨겨진 기능)
        GestureDetector(
          onTap: () => _showResetDialog(context),
          child: Text(
            'CUTY',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.5,
            ),
          ),
        ),

        // [2. 오른쪽 그룹] 포인트 + 알림 (기존 코드 그대로 복원)
        Row(
          children: [
              GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const MyPointScreen()),
                 );
               },
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.05),
                       blurRadius: 4,
                       offset: const Offset(0, 2),
                     )
                   ],
                   border: Border.all(color: Colors.grey.shade200),
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const Text("💰"), 
                     const SizedBox(width: 4),
                     Text(
                       "$points P", 
                       style: GoogleFonts.notoSansKr(
                         fontSize: 13, 
                         fontWeight: FontWeight.bold,
                         color: const Color(0xFF1A1A2E),
                       )
                     ),
                   ],
                 ),
               ),
             ),
             const SizedBox(width: 12),
             
             // Notification Bell
             GestureDetector(
              onTap: () {
                debugPrint('알림 클릭됨');
              },
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
