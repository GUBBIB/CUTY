import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/diagnosis_model.dart';
import '../models/document_model.dart';
import '../services/local_storage_service.dart';
import 'document_provider.dart';

class DiagnosisState {
  final SurveyAnswer answer;
  final DiagnosisResult? result;
  final bool isAnalyzing;

  DiagnosisState({
    required this.answer,
    this.result,
    this.isAnalyzing = false,
  });

  DiagnosisState copyWith({
    SurveyAnswer? answer,
    DiagnosisResult? result,
    bool? isAnalyzing,
  }) {
    return DiagnosisState(
      answer: answer ?? this.answer,
      result: result ?? this.result,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
    );
  }
  
  bool get isAnalysisDone => result != null;
}

class DiagnosisNotifier extends StateNotifier<DiagnosisState> {
  final Ref ref;

  DiagnosisNotifier(this.ref)
      : super(DiagnosisState(answer: SurveyAnswer())) {
          _loadDiagnosis();
      }

  void _loadDiagnosis() {
    final map = LocalStorageService().getDiagnosis();
    if (map != null) {
      final loadedAnswer = map['answer'] != null ? SurveyAnswer.fromJson(map['answer']) : SurveyAnswer();
      final loadedResult = map['result'] != null ? DiagnosisResult.fromJson(map['result']) : null;
      state = state.copyWith(answer: loadedAnswer, result: loadedResult);
    }
  }

  void _saveDiagnosis() {
    LocalStorageService().saveDiagnosis({
      'answer': state.answer.toJson(),
      'result': state.result?.toJson(),
    });
  }

  // 1. Update Survey Input
  void updateAnswer(SurveyAnswer newAnswer) {
    state = state.copyWith(answer: newAnswer);
    _saveDiagnosis();
  }

  // 2. Perform Analysis
  Future<void> analyze({required bool useDocuments}) async {
    state = state.copyWith(isAnalyzing: true);
    
    // Simulate thinking time for UX
    // If using documents, it takes longer (Wallet opening)
    await Future.delayed(Duration(seconds: useDocuments ? 3 : 2));

    // Get Objective Data (Documents)
    final myDocs = useDocuments ? ref.read(documentProvider) : <Document>[];
    
    // Logic Execution
    final result = _calculateResult(state.answer, myDocs);

    state = state.copyWith(
      result: result,
      isAnalyzing: false,
    );
    _saveDiagnosis();
    _saveDiagnosis();
  }

  // 3. Reset Diagnosis
  void reset() {
    state = DiagnosisState(answer: SurveyAnswer());
    _saveDiagnosis();
  }

  // Core Business Logic
  DiagnosisResult _calculateResult(SurveyAnswer answer, List<Document> docs) {
    // -------------------------------------------------------------
    // 1. Scoring Logic (5 Axis)
    // -------------------------------------------------------------
    
    // A. Language (TOPIK + Survey)
    int langScore = 0;
    switch (answer.koreanLevel) {
      case '기초 (인사말 정도)': langScore = 20; break;
      case '일상회화 (식당/마트 이용)': langScore = 40; break;
      case '비즈니스 (토론 가능)': langScore = 70; break;
      case '원어민 수준': langScore = 100; break;
      default: langScore = 10;
    }
    bool hasTopik = docs.any((d) => d.name.toUpperCase().contains('TOPIK'));
    if (hasTopik) langScore = (langScore + 30).clamp(0, 100);

    // B. Experience (Intern, Alba, E7)
    int expScore = 0;
    for (var exp in answer.experiences) {
      if (exp.category == '인턴십') {
        expScore += 30;
      } else if (exp.category == '시간제 취업(알바)') expScore += 20;
      else if (exp.category == '과거 E-7 근무') expScore += 50;
    }
    expScore = expScore.clamp(0, 100);

    // C. Expertise (Job Match + Degree)
    int expertiseScore = 40; // Base
    bool hasDegree = docs.any((d) => d.name.contains('졸업') || d.name.contains('학위'));
    if (hasDegree) expertiseScore += 40;
    // Boost if experience details match target job
    // Simple check: if any target job matches experience detail
    bool expMatch = false;
    for (var job in answer.targetJobs) {
       // Check detailType and customInput
       if (answer.experiences.any((e) {
          final detail = e.detailType;
          final custom = e.customInput ?? '';
          return (detail.contains(job) || custom.contains(job)) || (detail.contains('호텔') && job.contains('관광'));
       })) {
          expMatch = true;
       }
    }
    if (expMatch) expertiseScore += 20;
    expertiseScore = expertiseScore.clamp(0, 100);

    // D. Korea Understanding (Duration + Culture) - Simulated
    int koreaScore = 60; // Default
    if (langScore > 70) koreaScore += 20;
    if (docs.any((d) => d.name.contains('GKS') || d.name.contains('사회통합'))) koreaScore += 20;
    koreaScore = koreaScore.clamp(0, 100);

    // E. Sincerity/Reputation (GPA + Attendance) - Simulated
    int sincerityScore = 70; // Default
    if (expScore > 50) sincerityScore += 10;
    if (hasDegree) sincerityScore += 10;
    sincerityScore = sincerityScore.clamp(0, 100);

    // -------------------------------------------------------------
    // 2. Benchmarking & Result Generation
    // -------------------------------------------------------------
    Map<String, JobAnalysisData> results = {};
    List<String> solutions = [];

    // Common Solutions
    if (!hasTopik) solutions.add("TOPIK 보완 (3급 이상 권장)");
    if (!hasDegree) solutions.add("전공 학위 증명서");
    if (answer.experiences.isEmpty) solutions.add("관련 인턴십 경험");

    // Helper to Create Data
    void addResult(String code, String name, int avgSalaryInt, {int bonus = 0}) {
      VisaStatus status = VisaStatus.RED;
      // Simple Pass Logic
      if (expertiseScore + bonus >= 70 && langScore >= 40) {
        status = VisaStatus.GREEN;
      } else if (expertiseScore + bonus >= 50) status = VisaStatus.YELLOW;

      results[code] = JobAnalysisData(
        jobCode: code,
        jobName: name,
        visaStatus: status,
        myScores: {
          "언어": langScore,
          "전문성": (expertiseScore + bonus).clamp(0, 100),
          "경력": expScore,
          "한국이해": koreaScore,
          "성실성": sincerityScore,
        },
        avgScores: {
          "언어": 85,
          "전문성": 80,
          "경력": 70,
          "한국이해": 75,
          "성실성": 90,
        },
        avgSalary: "$avgSalaryInt만원",
      );
    }

    // Generate Results based on Multi-select Targets
    for (var job in answer.targetJobs) {
      if (job.contains('IT') || job.contains('기술')) {
          addResult('1332', '응용 S/W 개발자', 3800);
          addResult('2351', '데이터 전문가', 4200, bonus: -10);
      } else if (job.contains('마케팅') || job.contains('무역')) {
          addResult('2733', '해외 영업원', 3400);
          addResult('2742', '상품 기획 전문가', 3200, bonus: -5);
      } else if (job.contains('관광') || job.contains('서비스') || job.contains('호텔')) {
          addResult('3991', '관광 통역 안내원', 2800);
          addResult('3910', '호텔 접수 사무원', 2900, bonus: 10);
      } else if (job.contains('교육')) {
          addResult('2591', '외국어 강사', 3000);
      } else if (job.contains('의료')) {
          addResult('S392', '의료 코디네이터', 3100);
      } else {
         // Default fallback
         addResult('3922', '여행 상품 개발자', 3000);
      }
    }
    
    // Fallback if no jobs generated
    if (results.isEmpty) {
       addResult('3991', '관광 통역 안내원', 2800);
    }

    // -------------------------------------------------------------
    // 3. Total Score & Tier Calculation
    // -------------------------------------------------------------
    int totalScore = 50; // Base Score

    // Lang (+10 ~ +30)
    if (answer.koreanLevel.contains('기초')) {
      totalScore += 10;
    } else if (answer.koreanLevel.contains('일상')) totalScore += 20;
    else if (answer.koreanLevel.contains('비즈니스') || answer.koreanLevel.contains('원어민')) totalScore += 30;

    // Edu (+10 ~ +20)
    // Simple heuristic: if any degree doc exists, give +20 for now as we don't distinguish degree types yet
    if (hasDegree) totalScore += 20;

    // Experience (+5 per item, max 10)
    int expBonus = (answer.experiences.length * 5).clamp(0, 10);
    totalScore += expBonus;

    totalScore = totalScore.clamp(0, 100);

    // Tier
    String totalTier = "Silver";
    String tierDescription = "가능성의 씨앗! 이제부터 하나씩 준비해보아요.";
    
    if (totalScore >= 90) {
      totalTier = "Diamond";
      tierDescription = "준비된 인재! 이미 충분한 경쟁력을 갖추셨군요.";
    } else if (totalScore >= 80) {
      totalTier = "Platinum";
      tierDescription = "우수 인재! 조금만 더 다듬으면 완벽합니다.";
    } else if (totalScore >= 70) {
      totalTier = "Gold";
      tierDescription = "성장하는 인재! 기본 역량을 잘 갖추고 계시네요.";
    } 

    return DiagnosisResult(
      analysisResults: results,
      solutionDocs: solutions,
      totalScore: totalScore,
      totalTier: totalTier,
      tierDescription: tierDescription,
    );
  }
}

final diagnosisProvider = StateNotifierProvider<DiagnosisNotifier, DiagnosisState>((ref) {
  return DiagnosisNotifier(ref);
});
