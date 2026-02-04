enum VisaStatus { GREEN, YELLOW, RED }

class CareerExperience {
  final String category; // '인턴십', '시간제 취업(알바)', '과거 E-7 근무'
  final String detailType; // '사무/행정', '식당/서빙', '기타' etc.
  final String? customInput; // User typed input or E-7 code

  CareerExperience({
    required this.category, 
    required this.detailType, 
    this.customInput
  });

  factory CareerExperience.fromJson(Map<String, dynamic> json) {
    return CareerExperience(
      category: json['category'] ?? '',
      detailType: json['detailType'] ?? '',
      customInput: json['customInput'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'detailType': detailType,
      'customInput': customInput,
    };
  }
}

class SurveyAnswer {
  // 1. 희망 직무 (Multi-select)
  final List<String> targetJobs;
  // 2. 선호 지역 (Multi-select)
  final List<String> preferredLocations;
  // 3. 한국어 실력 (Description)
  final String koreanLevel;
  // 4. 경력 사항 (Detailed List)
  final List<CareerExperience> experiences;

  SurveyAnswer({
    this.targetJobs = const [],
    this.preferredLocations = const [],
    this.koreanLevel = '',
    this.experiences = const [],
  });

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) {
    return SurveyAnswer(
      targetJobs: List<String>.from(json['targetJobs'] ?? []),
      preferredLocations: List<String>.from(json['preferredLocations'] ?? []),
      koreanLevel: json['koreanLevel'] ?? '',
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((e) => CareerExperience.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetJobs': targetJobs,
      'preferredLocations': preferredLocations,
      'koreanLevel': koreanLevel,
      'experiences': experiences.map((e) => e.toJson()).toList(),
    };
  }

  SurveyAnswer copyWith({
    List<String>? targetJobs,
    List<String>? preferredLocations,
    String? koreanLevel,
    List<CareerExperience>? experiences,
  }) {
    return SurveyAnswer(
      targetJobs: targetJobs ?? this.targetJobs,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      koreanLevel: koreanLevel ?? this.koreanLevel,
      experiences: experiences ?? this.experiences,
    );
  }
}

class JobAnalysisData {
  final String jobCode; // "2351"
  final String jobName; // "General Engineer"
  final VisaStatus visaStatus;
  
  // 5-Axis Scores
  final Map<String, int> myScores; // { "언어": 80, "직무": 60 ... }
  final Map<String, int> avgScores; // Benchmarking { "언어": 90 ... }
  
  final String avgSalary; // "3,200만원"

  JobAnalysisData({
    required this.jobCode,
    required this.jobName,
    required this.visaStatus,
    required this.myScores,
    required this.avgScores,
    required this.avgSalary,
  });

  factory JobAnalysisData.fromJson(Map<String, dynamic> json) {
    return JobAnalysisData(
      jobCode: json['jobCode'] ?? '',
      jobName: json['jobName'] ?? '',
      visaStatus: VisaStatus.values.firstWhere(
          (e) => e.name == json['visaStatus'], 
          orElse: () => VisaStatus.RED),
      myScores: Map<String, int>.from(json['myScores'] ?? {}),
      avgScores: Map<String, int>.from(json['avgScores'] ?? {}),
      avgSalary: json['avgSalary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobCode': jobCode,
      'jobName': jobName,
      'visaStatus': visaStatus.name,
      'myScores': myScores,
      'avgScores': avgScores,
      'avgSalary': avgSalary,
    };
  }
}

class DiagnosisResult {
  // Key: Job Code (e.g., "2351") -> Data
  final Map<String, JobAnalysisData> analysisResults;
  final List<String> solutionDocs; 
  
  // Total Competency Score
  final int totalScore;
  final String totalTier; // "Diamond", "Gold", etc.
  final String tierDescription;

  DiagnosisResult({
    required this.analysisResults,
    required this.solutionDocs,
    required this.totalScore,
    required this.totalTier,
    required this.tierDescription,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      analysisResults: (json['analysisResults'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, JobAnalysisData.fromJson(v as Map<String, dynamic>)),
      ) ?? {},
      solutionDocs: List<String>.from(json['solutionDocs'] ?? []),
      totalScore: json['totalScore'] ?? 0,
      totalTier: json['totalTier'] ?? "Unranked",
      tierDescription: json['tierDescription'] ?? "진단을 시작해주세요.",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysisResults': analysisResults.map((k, v) => MapEntry(k, v.toJson())),
      'solutionDocs': solutionDocs,
      'totalScore': totalScore,
      'totalTier': totalTier,
      'tierDescription': tierDescription,
    };
  }

  // Factory for empty/initial state
  factory DiagnosisResult.empty() {
    return DiagnosisResult(
      analysisResults: {},
      solutionDocs: [],
      totalScore: 0,
      totalTier: "Unranked",
      tierDescription: "진단을 시작해주세요.",
    );
  }

  // Get Primary Result (First one or empty) - Helper for UI
  JobAnalysisData? get primary => analysisResults.isNotEmpty ? analysisResults.values.first : null;
}
