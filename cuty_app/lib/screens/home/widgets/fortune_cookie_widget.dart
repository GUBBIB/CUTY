import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/fortune_provider.dart';
import 'fortune_cookie_dialog.dart';

class FortuneCookieWidget extends ConsumerStatefulWidget {
  const FortuneCookieWidget({super.key});

  @override
  ConsumerState<FortuneCookieWidget> createState() => _FortuneCookieWidgetState();
}

class _FortuneCookieWidgetState extends ConsumerState<FortuneCookieWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fortuneState = ref.watch(fortuneProvider);

    return Visibility(
      visible: !fortuneState.isHidden,
      maintainSize: true, 
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () {
          if (fortuneState.isHidden) return;
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const FortuneCookieDialog(),
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: sin(_controller.value * 2 * pi) * 0.05, // -0.05 ~ 0.05 rad (약 3도)
              child: child,
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
        ),
      ),
    );
  }
}
