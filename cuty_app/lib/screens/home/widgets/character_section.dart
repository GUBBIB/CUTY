import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/character_provider.dart';
import '../../../../providers/fortune_provider.dart'; // [Added]
import 'speech_bubble_widget.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';

class CharacterSection extends ConsumerWidget {
  const CharacterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fortuneState = ref.watch(fortuneProvider);
    final randomCharacter = ref.watch(characterProvider);

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
          // 1. 캐릭터 이미지
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              displayImage,
              height: 200, // 340 * 0.7 = 238 (약 30% 축소)
              // ★ 핵심: 이미지가 영역보다 클 때만 비율 유지하며 줄어듬 (작으면 원본 유지)
              fit: BoxFit.scaleDown, 
              alignment: Alignment.bottomCenter,
            ),
          ),
          
          // 2. 말풍선 (캐릭터 머리 위)
           Positioned(
            top: -60, 
            child: SpeechBubbleWidget(
              message: AppLocalizations.of(context)!.homeCheerMessage,
            ),
          ),
        ],
      ),
    );
  }
}
