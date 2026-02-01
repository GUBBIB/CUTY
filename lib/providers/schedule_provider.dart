import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// [1] 데이터 모델: 수업 정보
class ClassItem {
  final String title;    // 과목명 (예: 경제론)
  final String room;     // 강의실 (예: 경적 304)
  final int day;         // 요일 (1=월, 2=화, ... 5=금)
  final int startTime;   // 시작 교시 (예: 10 -> 10시)
  final int duration;    // 수업 시간 (시간 단위)
  final Color color;     // 시간표 색상

  ClassItem({
    required this.title,
    required this.room,
    required this.day,
    required this.startTime,
    this.duration = 1,
    this.color = Colors.blueAccent,
  });
}

// [2] 노티파이어: 시간표 로직 관리
class ScheduleNotifier extends StateNotifier<List<ClassItem>> {
  ScheduleNotifier() : super([]) {
    // 초기 더미 데이터 설정 (테스트용)
    state = [
      ClassItem(title: "경제론", room: "경적 304", day: 1, startTime: 10, color: const Color(0xFFE3F2FD)), // 월 10시
      ClassItem(title: "마케팅원론", room: "경영관 B103", day: 2, startTime: 14, color: const Color(0xFFFFF3E0)), // 화 14시
      ClassItem(title: "데이터분석", room: "공학관 201", day: 3, startTime: 11, color: const Color(0xFFE8F5E9)), // 수 11시
      // 테스트를 위해 '오늘' 요일에 맞는 수업 하나를 자동으로 추가하는 로직이 있으면 좋지만, 일단 더미로 유지
    ];
    
    // (테스트용) 오늘이 평일이라면, 오늘 날짜의 수업을 하나 강제로 추가해둠 (개발 편의성)
    final today = DateTime.now().weekday;
    if (today <= 5) {
       state = [
         ...state,
         ClassItem(title: "오늘의수업", room: "테스트룸", day: today, startTime: DateTime.now().hour + 1, color: const Color(0xFFF3E5F5)),
       ];
    }
  }

  // --- [기능 1] 홈 화면용: 다음 수업 찾기 ---
  ClassItem getNextClass() {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1(월)~7(일)
    final currentHour = now.hour;

    // 1. 오늘 요일의 수업만 필터링
    final todayClasses = state.where((item) => item.day == currentDay).toList();

    // 2. 시간순 정렬
    todayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));

    // 3. 현재 시간 이후의 수업 중 가장 빠른 것 찾기
    for (var item in todayClasses) {
      if (item.startTime > currentHour) {
        return item;
      }
    }
    
    // 수업 없으면 빈 객체 반환
    return ClassItem(title: "", room: "오늘 수업 끝! 🎉", day: 0, startTime: 0, color: Colors.transparent);
  }

  // --- [기능 2] 마이페이지 주간 시간표용 ---
  List<ClassItem> getClassesForDay(int day) {
    return state.where((item) => item.day == day).toList();
  }

  // --- [기능 2] 시간표 관리용: 추가/삭제 ---
  bool addClass(ClassItem item) {
    // 1. 중복 체크: 같은 요일, 같은 시간대에 수업이 있는지 확인
    final isDuplicate = state.any((existing) => 
      existing.day == item.day && 
      existing.startTime == item.startTime // 단순화: 시작 시간이 같으면 중복으로 처리 (겹치는 시간 정교한 로직은 추후)
    );

    if (isDuplicate) {
      return false; // 추가 실패
    }

    state = [...state, item];
    return true; // 추가 성공
  }

  void removeClass(String title) {
    state = state.where((item) => item.title != title).toList();
  }
}

// [3] 프로바이더 정의
final scheduleProvider = StateNotifierProvider<ScheduleNotifier, List<ClassItem>>((ref) {
  return ScheduleNotifier();
});
