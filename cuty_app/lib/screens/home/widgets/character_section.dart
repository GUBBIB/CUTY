import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/character_provider.dart';
import '../../../../providers/fortune_provider.dart';
import 'fortune_cookie_widget.dart'; // [Added for animation]
import 'speech_bubble_widget.dart'; // [Added]
import 'package:cuty_app/l10n/gen/app_localizations.dart';

import '../../../../providers/message_provider.dart'; // [Added]

class CharacterSection extends ConsumerWidget {
  const CharacterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fortuneState = ref.watch(fortuneProvider);
    final randomCharacter = ref.watch(characterProvider);
    final msgIndex = ref.watch(messageProvider);
    final l10n = AppLocalizations.of(context)!;

    // [메시지 로직]
    final msgs = [
      l10n.homeMsg01, l10n.homeMsg02, l10n.homeMsg03, 
      l10n.homeMsg04, l10n.homeMsg05, l10n.homeMsg06
    ];
    final displayMsg = msgs[msgIndex % msgs.length];

    // [Logic] Cookie exists ? Hello/Happy(50:50) : Random
    String displayImage;
    if (!fortuneState.isHidden) {
      // 1. Cookie visible: Randomly show Hello or Happy based on hash
      // (Uses randomCharacter hash to change only on refresh)
      final bool useHappy = randomCharacter.hashCode % 2 == 0;
      displayImage = useHappy 
          ? 'assets/images/capy_happy.png' 
          : 'assets/images/capy_hello.png';
    } else {
      // 2. Cookie opened: Show random character
      displayImage = randomCharacter;
    }

    return Container(
      // ★ [안전장치] 높이 340: 캐릭터가 아무리 커도 이 영역 밖으로 못 나감 (에러 방지)
      height: 340, 
      width: double.infinity,
      alignment: Alignment.bottomCenter, // 내부 요소를 바닥에 붙임
      child: Stack(
        alignment: Alignment.bottomCenter, 
        clipBehavior: Clip.none, 
        children: [
          // 1. 캐릭터 이미지 & 쿠키 (한 몸처럼 움직이게 Grouping)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  displayImage,
                  height: 230, // 340 * 0.7 = 238 (약 30% 축소)
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomCenter,
                ),
                
                // 쿠키 위치: 캐릭터 기준 상대 좌표 (Proportional Positioning)
                // y: -0.1 (이미지 중심보다 살짝 위, 기존 110px 위치에 근접)
                // x: 0.7 (오른쪽 팔 근처로 약간 당김)
                const Align(
                  alignment: Alignment(0.52, 0.16), 
                  child: FortuneCookieWidget(),
                ),
              ],
            ),
          ),
          
          // 2. 말풍선 (캐릭터 머리 위)
           Positioned(
            top: 42,
            left: 0,
            right: 0, 
            child: Center(
              child: SpeechBubbleWidget(
                message: displayMsg, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
