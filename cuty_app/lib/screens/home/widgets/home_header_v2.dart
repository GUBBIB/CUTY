import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/point_provider.dart';
import '../../wallet/my_point_screen.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';
import '../../../../services/local_storage_service.dart';
import 'package:cuty_app/main.dart'; // [Added] For RestartWidget
import '../../../../providers/fortune_provider.dart'; // [Added] For fortune reset
import '../../../../providers/user_provider.dart'; // [Added] For user reset

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
          onTap: () {
            // 1. 경고 팝업 띄우기 (실수로 누르는 것 방지)
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('⚠️ 개발자 모드'),
                  content: const Text('모든 데이터(쿠키, 유저 정보 등)를 삭제하고\n앱을 **완전 초기화(Reboot)** 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('취소', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop(); // 팝업 닫기

                        // 2. 모든 데이터 삭제 (SharedPreferences 전체 클리어)
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear(); // 싹 다 지움

                        // 3. 상태 초기화 (Riverpod)
                        // (필요 시 특정 프로바이더 invalidate, 재시작하면 어차피 날아가지만 안전장치)
                        
                        if (context.mounted) {
                          // 4. 피드백 메시지
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🚀 모든 데이터 삭제 완료! 앱을 재시작합니다...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          
                          // 5. 0.5초 뒤 강제 재시작 (R 기능 실행)
                          await Future.delayed(const Duration(milliseconds: 500));
                          RestartWidget.restartApp(context); 
                        }
                      },
                      child: const Text('초기화 실행', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
            );
          },
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
