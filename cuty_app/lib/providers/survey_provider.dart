import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyState {
  final String? job;
  final int? koreanLevel;
  
  SurveyState({this.job, this.koreanLevel});

  bool get isSurveyCompleted => job != null && koreanLevel != null;

  SurveyState copyWith({String? job, int? koreanLevel}) {
    return SurveyState(
      job: job ?? this.job,
      koreanLevel: koreanLevel ?? this.koreanLevel,
    );
  }
}

class SurveyNotifier extends StateNotifier<SurveyState> {
  SurveyNotifier() : super(SurveyState());

  void setJob(String job) {
    state = state.copyWith(job: job);
  }
  
  void setKoreanLevel(int level) {
    state = state.copyWith(koreanLevel: level);
  }

  void reset() {
    state = SurveyState();
  }
}

final surveyProvider = StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  return SurveyNotifier();
});
