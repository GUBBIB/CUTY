import 'package:flutter/material.dart';
import 'fortune_cookie_dialog.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/fortune_provider.dart';
import '../../../../providers/point_provider.dart';

class FortuneCookieWidget extends ConsumerWidget {
  const FortuneCookieWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final hasOpened = ref.read(fortuneProvider);

        if (hasOpened) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("오늘의 행운은 이미 받으셨어요! 내일 또 만나요 🌙"),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Open Intro Dialog (Logic handled inside dialog)
          showDialog(
            context: context,
            barrierDismissible: false, // Force flow
            builder: (context) => const FortuneCookieDialog(),
          );
        }
      },
      onLongPress: () {
         // Developer Reset Feature
         ref.read(fortuneProvider.notifier).reset();
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("개발자 모드: 운세 기회가 초기화되었습니다! 🔄")),
         );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/item_fortune_cookie.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
