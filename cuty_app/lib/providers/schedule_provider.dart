import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_model.dart';

// [1] 노티파이어: 시간표 로직 관리
class ScheduleNotifier extends StateNotifier<List<Schedule>> {
  ScheduleNotifier() : super([]) {
    // 초기 더미 데이터 설정 (테스트용)
    state = [
      Schedule(id: 1, title: "경제론", classroom: "경적 304", day: "Mon", startTime: 10, duration: 1), 
      Schedule(id: 2, title: "마케팅원론", classroom: "경영관 B103", day: "Tue", startTime: 14, duration: 1),
      Schedule(id: 3, title: "데이터분석", classroom: "공학관 201", day: "Wed", startTime: 11, duration: 1),
    ];
    
    // (테스트용) 오늘이 평일이라면, 오늘 날짜의 수업을 하나 강제로 추가해둠
    final todayWeekday = DateTime.now().weekday;
    final dayMap = {1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};
    
    if (todayWeekday <= 5) {
       state = [
         ...state,
         Schedule(
           id: 999, 
           title: "오늘의수업", 
           classroom: "테스트룸", 
           day: dayMap[todayWeekday] ?? "Mon", 
           startTime: DateTime.now().hour + 1, 
           duration: 1
         ),
       ];
    }
  }

  // --- [기능 1] 홈 화면용: 다음 수업 찾기 ---
  Schedule? getNextClass() { // Changed return type to nullable Schedule
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1(Mon)..7(Sun)
    final dayMap = {1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};
    final currentDayStr = dayMap[currentWeekday];
    final currentHour = now.hour;

    // 1. 오늘 요일의 수업만 필터링
    final todayClasses = state.where((item) => item.day == currentDayStr).toList();

    // 2. 시간순 정렬
    todayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));

    // 3. 현재 시간 이후의 수업 중 가장 빠른 것 찾기
    for (var item in todayClasses) {
      if (item.startTime > currentHour) {
        return item;
      }
    }
    
    return null; // 수업 없음
  }

  // --- [기능 2] 마이페이지 주간 시간표용 ---
  List<Schedule> getClassesForDay(int dayInt) { // dayInt: 1=Mon, etc.
    final dayMap = {1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};
    final dayStr = dayMap[dayInt];
    return state.where((item) => item.day == dayStr).toList();
  }

  // --- [기능 2] 시간표 관리용: 추가/삭제 ---
  bool addClass(Schedule item) {
    // 1. 중복 체크
    final isDuplicate = state.any((existing) => 
      existing.day == item.day && 
      existing.startTime == item.startTime 
    );

    if (isDuplicate) {
      return false; // 추가 실패
    }

    state = [...state, item];
    return true;
  }

  void removeClass(String title) {
    state = state.where((item) => item.title != title).toList();
  }
}

// [3] 프로바이더 정의
final scheduleProvider = StateNotifierProvider<ScheduleNotifier, List<Schedule>>((ref) {
  return ScheduleNotifier();
});
