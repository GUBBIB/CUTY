import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterNotifier extends StateNotifier<String> {
  // 초기값: 가장 무난한 인사하는 카피바라
  CharacterNotifier() : super('assets/images/capy_hello.png') {
    pickRandomCharacter();
  }

  // ★ 스크린샷 기반 필터링된 이미지 리스트 (정장/비즈니스 제외)
  final List<String> _characters = [
    'assets/images/capy_hello.png',
    'assets/images/capy_happy.png',
    'assets/images/capy_sit.png',
    'assets/images/capy_stand.png',
    'assets/images/capy_wink.png',
    'assets/images/capy_joy.png',
    'assets/images/capy_gym.png',      // 운동
    'assets/images/capy_cook.png',     // 요리
    'assets/images/capy_laptop.png',   // 노트북
    'assets/images/capy_travel.png',   // 여행
    'assets/images/capy_sleep_bed.png',// 침대
    'assets/images/capy_snack.png',    // 간식
    'assets/images/capy_study_glasses.png', // 공부
    'assets/images/capy_bow.png',      // 인사
    'assets/images/capy_fortune_hold.png', // 포춘쿠키 들고있음
    // 필요 시 assets 폴더의 다른 파일명 추가 가능
  ];

  void pickRandomCharacter() {
    if (_characters.isEmpty) return;
    state = _characters[Random().nextInt(_characters.length)];
  }
}

final characterProvider = StateNotifierProvider<CharacterNotifier, String>((ref) {
  return CharacterNotifier();
});
