import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuty_app/providers/survey_provider.dart';
import 'package:cuty_app/providers/document_provider.dart';
import 'package:cuty_app/providers/user_provider.dart';

// -------------------------------------------------------------
// 1. Data Models
// -------------------------------------------------------------

enum VisaStatus {
  ELIGIBLE,   // 적합 (초록불)
  INELIGIBLE, // 부적합 (빨간불)
  WARNING,    // 주의 (노란불 - optional)
}

class DiagnosisResult {
  final VisaStatus visaStatus;
  final int score;
  final String tier; // S, A, B, C
  final List<String> missingSpecs; // 점수를 못 받은 항목들
  final Map<String, int> metricScores; // Radar Chart Data

  DiagnosisResult({
    required this.visaStatus,
    required this.score,
    required this.tier,
    required this.missingSpecs,
    required this.metricScores,
  });

  // 초기 상태 (아직 분석 안 함)
  factory DiagnosisResult.initial() {
    return DiagnosisResult(
      visaStatus: VisaStatus.ELIGIBLE, // Default
      score: 0,
      tier: '-',
      missingSpecs: [],
      metricScores: {
        '전공 역량': 0,
        '어학 점수': 0,
        '실무 경험': 0,
        '자격증': 0,
        '비자 안정성': 0,
      },
    );
  }
}

class DiagnosisState {
  final bool isAnalyzing;
  final DiagnosisResult resultData;

  DiagnosisState({
    this.isAnalyzing = false,
    required this.resultData,
  });

  DiagnosisState copyWith({
    bool? isAnalyzing,
    DiagnosisResult? resultData,
  }) {
    return DiagnosisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      resultData: resultData ?? this.resultData,
    );
  }
}

// -------------------------------------------------------------
// 2. Notifier (Logic Core)
// -------------------------------------------------------------

class DiagnosisNotifier extends StateNotifier<DiagnosisState> {
  final Ref ref;

  DiagnosisNotifier(this.ref)
      : super(DiagnosisState(resultData: DiagnosisResult.initial())) {
        _analyze(); // 초기화 시 자동 분석 (또는 필요할 때 호출)
      }

  // 외부에서 호출 가능 (예: 버튼 누를 때 다시 분석)
  void refreshDiagnosis() {
    _analyze();
  }

  void reset() {
    state = state.copyWith(resultData: DiagnosisResult.initial());
  }

  void _analyze() {
    // 1. 데이터 가져오기 (Soft Data & Hard Data)
    final survey = ref.read(surveyProvider);
    final documents = ref.read(documentProvider);
    final user = ref.read(userProvider);

    // ---------------------------------------------------------
    // Track 1: 비자 적합성 (Visa Eligibility)
    // ---------------------------------------------------------
    VisaStatus visaStatus = VisaStatus.ELIGIBLE;
    
    // 로직: 희망 직무 vs 전공 유사성 판단
    // (현재 백엔드 API가 없으므로 간단한 키워드 매칭 시뮬레이션)
    final String desiredJob = survey.job ?? "";
    final String majorInfo = user.university; // "한국대 경영학과"

    // 시뮬레이션: 'IT'를 희망하는데 전공에 '컴퓨터'나 '소프트웨어'가 없으면 주의
    if (desiredJob.contains("IT") || desiredJob.contains("개발")) {
      if (!majorInfo.contains("컴퓨터") && !majorInfo.contains("소프트웨어") && !majorInfo.contains("공학")) {
        // 엄격하게 하진 않고 일단 ELIGIBLE로 두되, 로그만 남김 (기획서: "기본 ELIGIBLE")
        // visaStatus = VisaStatus.WARNING; 
      }
    }
    
    // ---------------------------------------------------------
    // Track 2: 스펙 점수 산출 (Competitiveness)
    // ---------------------------------------------------------
    int score = 0;
    List<String> missing = [];

    // (1) 직무 전문성 (40점) - 성적증명서 OR 자격증
    bool hasTranscript = documents.any((d) => d.title.contains("성적증명서"));
    bool hasCert = documents.any((d) => d.title.contains("자격증") || d.title.contains("산업기사"));
    
    if (hasTranscript || hasCert) {
      score += 40;
    } else {
      missing.add("직무 전문성 (성적증명서 또는 자격증 필요)");
    }

    // (2) 실무 경험 (30점) - 인턴 OR 경력증명서
    bool hasIntern = documents.any((d) => d.title.contains("인턴") || d.title.contains("수료증"));
    bool hasCareer = documents.any((d) => d.title.contains("경력증명서"));

    if (hasIntern || hasCareer) {
      score += 30;
    } else {
      missing.add("실무 경험 (인턴 수료증 또는 경력증명서 필요)");
    }

    // (3) 어학 능력 (20점) - 토픽
    bool hasTopik = documents.any((d) => d.title.contains("토픽") || d.title.contains("TOPIK"));
    
    if (hasTopik) {
      score += 20;
    } else {
      missing.add("어학 능력 (TOPIK 증명서 필요)");
    }

    // (4) 가산점 (10점) - 봉사활동 OR 거주지
    bool hasVolunteer = documents.any((d) => d.title.contains("봉사"));
    bool hasResidence = documents.any((d) => d.title.contains("거주지") || d.title.contains("등록증"));

    if (hasVolunteer || hasResidence) {
      score += 10;
    } else {
      missing.add("추가 가산점 (봉사활동 또는 거주지 증명)");
    }

    // ---------------------------------------------------------
    // Tier Calculation
    // ---------------------------------------------------------
    String tier = 'C';
    if (score >= 90) tier = 'S';
    else if (score >= 70) tier = 'A';
    else if (score >= 50) tier = 'B';

    // ---------------------------------------------------------
    // Radar Chart Metrics (Mock Logic)
    // ---------------------------------------------------------
    Map<String, int> metrics = {
      '전공 역량': hasTranscript ? 90 : 30, // 성적증명서 있으면 높게
      '어학 점수': hasTopik ? 85 : 40,      // 토픽 있으면 높게
      '실무 경험': (hasIntern || hasCareer) ? 95 : 20, // 인턴/경력 있으면 높게
      '자격증': hasCert ? 80 : 20,         // 자격증 있으면 높게
      '비자 안정성': (tier == 'S' || tier == 'A') ? 90 : 50, // 점수 기반
    };

    // 결과 업데이트
    state = state.copyWith(
      resultData: DiagnosisResult(
        visaStatus: visaStatus,
        score: score,
        tier: tier,
        missingSpecs: missing,
        metricScores: metrics,
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Provider Definition
// -------------------------------------------------------------
final diagnosisProvider = StateNotifierProvider<DiagnosisNotifier, DiagnosisState>((ref) {
  // Provider가 생성될 때 다른 Provider의 변화를 감지하여 자동 갱신하고 싶다면:
  ref.watch(surveyProvider);
  ref.watch(documentProvider);
  ref.watch(userProvider);
  
  return DiagnosisNotifier(ref);
});
