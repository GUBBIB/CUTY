import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/point_provider.dart';
import '../../wallet/my_point_screen.dart';
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
        title: const Text("데이터 초기화"),
        content: const Text("저장된 모든 설정과 데이터를 삭제하시겠습니까? (앱 재시작 필요)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              await LocalStorageService().clearAll();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("초기화 완료. 터미널에서 대문자 R을 눌러 재시작해주세요.")),
                );
              }
            },
            child: const Text("초기화", style: TextStyle(color: Colors.red)),
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
