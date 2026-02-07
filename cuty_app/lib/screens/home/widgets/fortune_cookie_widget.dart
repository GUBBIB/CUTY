import 'package:flutter/material.dart';
import 'fortune_cookie_dialog.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/fortune_provider.dart';

class FortuneCookieWidget extends ConsumerWidget {
  const FortuneCookieWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final hasOpened = ref.read(fortuneProvider);

        if (hasOpened) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.msgFortuneAlreadyOpened),
              duration: const Duration(seconds: 2),
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
            SnackBar(content: Text(AppLocalizations.of(context)!.msgDevFortuneReset)),
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
