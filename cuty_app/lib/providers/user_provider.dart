import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String name;
  final String university;
  final String major;
  final String visaType; // Added field
  
  UserState({
    this.name = '김쿠티',
    this.university = '한국대학교',
    this.major = '경영학과',
    this.visaType = 'D-2', // Default value
  });
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());
  
  void updateUser({String? name, String? university, String? major, String? visaType}) {
    state = UserState(
      name: name ?? state.name,
      university: university ?? state.university,
      major: major ?? state.major,
      visaType: visaType ?? state.visaType,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
