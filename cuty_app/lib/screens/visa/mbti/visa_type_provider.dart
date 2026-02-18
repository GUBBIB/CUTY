import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// 1. Data Models
// -----------------------------------------------------------------------------

/// 결과 데이터 모델
class VisaTypeResult {
  final String title;
  final String description;
  final String imagePath;
  final String goalKey; // VisaProvider와 연동될 키 (research, employment, startup, global, school)
  final String goalName; // 화면 표시용 이름

  const VisaTypeResult({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.goalKey,
    required this.goalName,
  });
}

// -----------------------------------------------------------------------------
// 2. Logic Controller
// -----------------------------------------------------------------------------

class VisaTypeState {
  final int currentQuestionIndex;
  final VisaTypeResult? result;

  const VisaTypeState({
    this.currentQuestionIndex = 0,
    this.result,
  });

  VisaTypeState copyWith({
    int? currentQuestionIndex,
    VisaTypeResult? result,
  }) {
    return VisaTypeState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      result: result ?? this.result,
    );
  }
}

class VisaTypeNotifier extends StateNotifier<VisaTypeState> {
  VisaTypeNotifier() : super(const VisaTypeState());

  // 질문 로직 (분기형)
  // Q1: 졸업 후 계획은?
  // A: 한국 취업/창업 -> Q2 이동
  // B: 대학원 진학 -> [연구형] (research)
  // C: 본국 귀국/해외 -> [글로벌형] (global)
  // D: 잘 모르겠음 -> [학교생활형] (school)
  
  void answerQuestion1(String answerCode) {
    if (answerCode == 'A') {
      // Q2로 이동
      state = state.copyWith(currentQuestionIndex: 1);
    } else if (answerCode == 'B') {
      state = state.copyWith(result: _researchResult);
    } else if (answerCode == 'C') {
      state = state.copyWith(result: _globalResult);
    } else {
      state = state.copyWith(result: _schoolResult);
    }
  }

  // Q2: 선호하는 업무 스타일?
  // A: 안정적 월급 -> [취업형] (employment)
  // B: 내 사업 -> [창업형] (startup)
  void answerQuestion2(String answerCode) {
    if (answerCode == 'A') {
      state = state.copyWith(result: _employmentResult);
    } else {
      state = state.copyWith(result: _startupResult);
    }
  }

  void reset() {
    state = const VisaTypeState();
  }

  // ---------------------------------------------------------------------------
  // Pre-defined Results
  // ---------------------------------------------------------------------------
  static const _researchResult = VisaTypeResult(
    title: '스마트한 연구생 카피바라',
    description: '깊이 있는 탐구를 즐기는 당신!\n대학원 진학이나 연구직이 딱이에요. 🎓',
    imagePath: 'assets/images/capy_study_glasses.png',
    goalKey: 'research',
    goalName: '대학원/연구 (F-2-7)',
  );

  static const _employmentResult = VisaTypeResult(
    title: '성실한 직장인 카피바라',
    description: '안정적인 커리어를 쌓고 싶군요!\n전문직 취업 비자를 목표로 해봐요. 👔',
    imagePath: 'assets/images/class_job.jpg',
    goalKey: 'employment',
    goalName: '취업 (E-7)',
  );

  static const _startupResult = VisaTypeResult(
    title: '야망있는 CEO 카피바라',
    description: '나만의 아이디어로 세상을 바꾸고 싶나요?\n창업 비자에 도전해보세요! 🚀',
    imagePath: 'assets/images/capy_laptop.png',
    goalKey: 'startup',
    goalName: '기술창업 (D-8-4)',
  );

  static const _globalResult = VisaTypeResult(
    title: '자유로운 글로벌 카피바라',
    description: '한국 경험을 발판으로 세계로!\n글로벌 역량을 키워보세요. 🌏',
    imagePath: 'assets/images/class_global.png',
    goalKey: 'global',
    goalName: '글로벌 인재',
  );

  static const _schoolResult = VisaTypeResult(
    title: '즐거운 캠퍼스 카피바라',
    description: '아직은 고민 중이어도 괜찮아요.\n먼저 즐거운 학교생활부터 챙겨볼까요? 🏫',
    imagePath: 'assets/images/class_basic.png', // Fixed
    goalKey: 'school',
    goalName: '학교생활 적응',
  );
}

final visaTypeProvider = StateNotifierProvider.autoDispose<VisaTypeNotifier, VisaTypeState>((ref) {
  return VisaTypeNotifier();
});
