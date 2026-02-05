import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visaScoreProvider = ChangeNotifierProvider<VisaScoreProvider>((ref) {
  return VisaScoreProvider();
});

class VisaScoreProvider extends ChangeNotifier {
  // --- State Variables ---
  String? selectedAge;
  String? educationLevel; // 박사, 석사, 학사, 전문학사
  bool isStemOrDoubleMajor = false; // 이공계 or 복수전공
  bool _isBachelor = false; // 학사 여부
  String? koreanLevel;
  String? incomeBracket;

  VisaScoreProvider() {
    _loadAllData();
  }

  void _loadAllData() {
    final ls = LocalStorageService();
    isSpecWalletLinked = ls.getWalletLink();
    
    selectedAge = ls.getString('f27_age');
    educationLevel = ls.getString('f27_education');
    _isBachelor = (educationLevel == '학사' || educationLevel == '전문학사');
    isStemOrDoubleMajor = ls.getBool('f27_stem');
    koreanLevel = ls.getString('f27_korean');
    incomeBracket = ls.getString('f27_income');
    uniBonusType = ls.getString('f27_uni_bonus');
    kiipCompleted = ls.getBool('f27_kiip');
    highTechIndustry = ls.getBool('f27_hightech');
    govRecommendation = ls.getBool('f27_gov');
    warVeteran = ls.getBool('f27_veteran');
    volunteerBonus = ls.getString('f27_volunteer');
    regionalScore = ls.getInt('f27_region');
    immigrationViolation = ls.getBool('f27_immigration');
    criminalPunishment = ls.getBool('f27_criminal');

    if (isSpecWalletLinked && selectedAge == null) {
       loadMockData();
    }
  }

  // --- Bonus Items ---
  String? uniBonusType; // 'top_global', 'domestic', or null
  bool kiipCompleted = false; // 사회통합 5단계 이수
  bool highTechIndustry = false; // 첨단분야 종사
  bool govRecommendation = false; // 중앙행정기관장 추천
  bool warVeteran = false; // 참전국 우수인재
  String? volunteerBonus; // 봉사활동 (3년/2년/1년)
  
  // Regional Score (Input)
  int regionalScore = 0; 
  
  // --- Penalty Items ---
  bool immigrationViolation = false;
  bool criminalPunishment = false;

  // --- UI State ---
  bool isSpecWalletLinked = LocalStorageService().getWalletLink();

  // --- Actions ---

  void updateAge(String? value) {
    selectedAge = value;
    LocalStorageService().saveString('f27_age', value ?? '');
    notifyListeners();
  }

  void updateEducation(String? level) {
    educationLevel = level;
    _isBachelor = (level == '학사' || level == '전문학사');
    LocalStorageService().saveString('f27_education', level ?? '');
    notifyListeners();
  }

  void updateStemStatus(bool value) {
    isStemOrDoubleMajor = value;
    LocalStorageService().saveBool('f27_stem', value);
    notifyListeners();
  }

  void updateKoreanLevel(String? level) {
    koreanLevel = level;
    LocalStorageService().saveString('f27_korean', level ?? '');
    notifyListeners();
  }

  void updateIncome(String? bracket) {
    incomeBracket = bracket;
    LocalStorageService().saveString('f27_income', bracket ?? '');
    notifyListeners();
  }

  void updateUniBonus(String? type) {
    uniBonusType = type;
    LocalStorageService().saveString('f27_uni_bonus', type ?? '');
    notifyListeners();
  }

  void updateKiipBonus(bool value) {
    kiipCompleted = value;
    LocalStorageService().saveBool('f27_kiip', value);
    notifyListeners();
  }

  void updateHighTechBonus(bool value) {
    highTechIndustry = value;
    LocalStorageService().saveBool('f27_hightech', value);
    notifyListeners();
  }

  void updateGovBonus(bool value) {
    govRecommendation = value;
    LocalStorageService().saveBool('f27_gov', value);
    notifyListeners();
  }

  void updateVeteranBonus(bool value) {
    warVeteran = value;
    LocalStorageService().saveBool('f27_veteran', value);
    notifyListeners();
  }

  void updateVolunteerBonus(String? val) {
    volunteerBonus = val;
    LocalStorageService().saveString('f27_volunteer', val ?? '');
    notifyListeners();
  }

  void updateRegionalScore(int score) {
    regionalScore = score;
    LocalStorageService().saveInt('f27_region', score);
    notifyListeners();
  }

  void updateImmigrationPenalty(bool value) {
    immigrationViolation = value;
    LocalStorageService().saveBool('f27_immigration', value);
    notifyListeners();
  }

  void updateCriminalPenalty(bool value) {
    criminalPunishment = value;
    LocalStorageService().saveBool('f27_criminal', value);
    notifyListeners();
  }

  void toggleSpecWallet(bool value) {
    isSpecWalletLinked = value;
    // 상태 변경 시 즉시 저장
    LocalStorageService().saveWalletLink(value);

    if (value) {
      loadMockData(); 
      // Save all mocked data
      final ls = LocalStorageService();
      ls.saveString('f27_age', selectedAge ?? '');
      ls.saveString('f27_education', educationLevel ?? '');
      ls.saveBool('f27_stem', isStemOrDoubleMajor);
      ls.saveString('f27_korean', koreanLevel ?? '');
      ls.saveString('f27_income', incomeBracket ?? '');
      ls.saveString('f27_uni_bonus', uniBonusType ?? '');
      ls.saveBool('f27_kiip', kiipCompleted);
      ls.saveBool('f27_hightech', highTechIndustry);
      ls.saveBool('f27_gov', govRecommendation);
      ls.saveBool('f27_veteran', warVeteran);
      ls.saveString('f27_volunteer', volunteerBonus ?? '');
      ls.saveInt('f27_region', regionalScore);
      ls.saveBool('f27_immigration', immigrationViolation);
      ls.saveBool('f27_criminal', criminalPunishment);
    } else {
      reset();
      // Save all reset data (cleared)
      final ls = LocalStorageService();
      ls.saveString('f27_age', '');
      ls.saveString('f27_education', '');
      ls.saveBool('f27_stem', false);
      ls.saveString('f27_korean', '');
      ls.saveString('f27_income', '');
      ls.saveString('f27_uni_bonus', '');
      ls.saveBool('f27_kiip', false);
      ls.saveBool('f27_hightech', false);
      ls.saveBool('f27_gov', false);
      ls.saveBool('f27_veteran', false);
      ls.saveString('f27_volunteer', '');
      ls.saveInt('f27_region', 0);
      ls.saveBool('f27_immigration', false);
      ls.saveBool('f27_criminal', false);
    }
    notifyListeners();
  }

  void reset() {
    selectedAge = null;
    educationLevel = null;
    isStemOrDoubleMajor = false;
    koreanLevel = null;
    incomeBracket = null;
    uniBonusType = null;
    kiipCompleted = false;
    highTechIndustry = false;
    govRecommendation = false;
    warVeteran = false;
    volunteerBonus = null;
    regionalScore = 0;
    immigrationViolation = false;
    criminalPunishment = false;
    isSpecWalletLinked = false;
    notifyListeners();
  }

  void loadMockData() {
    // "Golden Path" Scenario
    selectedAge = '25~29세'; // 25
    educationLevel = '석사'; // 17 (Normal) / 20 (STEM)
    isStemOrDoubleMajor = true; // -> 20
    koreanLevel = 'TOPIK 5~6급 / KIIP 5단계'; // 20
    incomeBracket = '3천만 ~ 4천만 미만'; // 30
    // Bonus
    uniBonusType = 'domestic'; // +7 (Master)
    // Calc: 25 + 20 + 20 + 30 + 7 = 102 (Wow)
    notifyListeners();
  }

  // --- Calculation Logic ---
  int calculateTotalScore() {
    int total = 0;

    // A. Age
    if (selectedAge == '25~29세') {
      total += 25;
    } else if (selectedAge == '18~24세' || selectedAge == '30~34세') {
      total += 23;
    } else if (selectedAge == '35~39세') {
      total += 20;
    } else if (selectedAge == '40~44세') {
      total += 12;
    } else if (selectedAge == '45~50세') {
      total += 8;
    } else if (selectedAge == '51세 이상') {
      total += 3;
    }

    // B. Education
    // Levels: 박사, 석사, 학사, 전문학사
    if (educationLevel == '박사') {
      total += (isStemOrDoubleMajor ? 25 : 20);
    } else if (educationLevel == '석사') {
      total += (isStemOrDoubleMajor ? 20 : 17);
    } else if (educationLevel == '학사') {
      total += (isStemOrDoubleMajor ? 17 : 15);
    } else if (educationLevel == '전문학사') {
      total += (isStemOrDoubleMajor ? 15 : 10);
    }

    // C. Korean
    if (koreanLevel == 'TOPIK 5~6급 / KIIP 5단계') {
      total += 20;
    } else if (koreanLevel == 'TOPIK 4급 / KIIP 4단계') {
      total += 15;
    } else if (koreanLevel == 'TOPIK 3급 / KIIP 3단계') {
      total += 10;
    } else if (koreanLevel == 'TOPIK 2급 / KIIP 2단계') {
      total += 5;
    } else if (koreanLevel == 'TOPIK 1급 / KIIP 1단계') {
      total += 3;
    }

    // D. Income
    if (incomeBracket == '1억 원 이상') {
      total += 60;
    } else if (incomeBracket == '9천만 ~ 1억 미만') {
      total += 58;
    } else if (incomeBracket == '8천만 ~ 9천만 미만') {
      total += 56;
    } else if (incomeBracket == '7천만 ~ 8천만 미만') {
      total += 53;
    } else if (incomeBracket == '6천만 ~ 7천만 미만') {
      total += 50;
    } else if (incomeBracket == '5천만 ~ 6천만 미만') {
      total += 45;
    } else if (incomeBracket == '4천만 ~ 5천만 미만') {
      total += 40;
    } else if (incomeBracket == '3천만 ~ 4천만 미만') {
      total += 30;
    } else if (incomeBracket == '최저임금 ~ 3천만 미만') {
      total += 10;
    }
    // '없음 / 미취업' -> 0 (Default)

    // E. Bonus (Max 40)
    int bonus = 0;
    
    // E-1. University
    if (uniBonusType == 'top_global') {
      if (educationLevel == '박사') {
        bonus += 30;
      } else if (educationLevel == '석사') {
        bonus += 20;
      } else if (educationLevel == '학사') {
        bonus += 15;
      }
    } else if (uniBonusType == 'domestic') {
       if (educationLevel == '박사') {
         bonus += 10;
       } else if (educationLevel == '석사') {
         bonus += 7;
       } else if (educationLevel == '학사') {
         bonus += 5;
       }
    }

    // E-2. Policy
    if (kiipCompleted) bonus += 10;
    if (highTechIndustry) bonus += 20;
    if (govRecommendation) bonus += 20;
    if (warVeteran) bonus += 20;

    // E-3. Volunteer
    if (volunteerBonus == '3년 이상') {
      bonus += 7;
    } else if (volunteerBonus == '2년 이상') {
      bonus += 5;
    } else if (volunteerBonus == '1년 이상') {
      bonus += 1;
    }

    // E-4. Regional
    bonus += regionalScore;

    // Cap
    if (bonus > 40) bonus = 40;
    total += bonus;

    // F. Deductions
    if (immigrationViolation) total -= 30;
    if (criminalPunishment) total -= 40;

    return total;
  }

  List<String> getSmartAdvice() {
    // 0. Pre-calculate local variables needed for logic
    int _koreanScore = 0;
    if (koreanLevel == 'TOPIK 5~6급 / KIIP 5단계') {
      _koreanScore = 20;
    } else if (koreanLevel == 'TOPIK 4급 / KIIP 4단계') {
      _koreanScore = 15;
    } else if (koreanLevel == 'TOPIK 3급 / KIIP 3단계') {
      _koreanScore = 10;
    } else if (koreanLevel == 'TOPIK 2급 / KIIP 2단계') {
      _koreanScore = 5;
    } else if (koreanLevel == 'TOPIK 1급 / KIIP 1단계') {
      _koreanScore = 3;
    }

    bool _socialIntegrationBonus = kiipCompleted; // +10 bonus

    int _volunteerScore = 0;
    if (volunteerBonus == '3년 이상') {
      _volunteerScore = 7;
    } else if (volunteerBonus == '2년 이상') {
      _volunteerScore = 5;
    } else if (volunteerBonus == '1년 이상') {
      _volunteerScore = 1;
    }

    // --- User Logic Start ---
    int currentScore = calculateTotalScore();
    
    // [0단계] 블라인드 처리
    if (currentScore == 0) return [];

    List<String> advice = [];
    int gap = 80 - currentScore;

    // [1단계] 학사 입구컷 (이미 적용된 로직 유지)
    if (_isBachelor) {
      advice.add("🚫 **유학생 특례 대상 아님 (학사)**\n선택하신 학위는 **학사**입니다.\nF-2-7 유학생 특례(D-2 → F-2-7)는 **석사 학위 이상**만 신청 가능합니다.\n점수가 80점을 넘더라도 이 전형으로는 신청할 수 없습니다.");
      return advice; 
    }

    // [2단계] 합격권
    if (gap <= 0) {
      advice.add("🎉 **축하합니다! 합격 안정권**\n석사 이상의 학위와 80점 이상의 점수를 모두 충족했습니다.");
      if (currentScore <= 82) {
        advice.add("⚠️ **나이 감점 주의 (Age Cliff)**\n점수가 합격선에 딱 걸쳐 있습니다. 해가 바뀌어 나이 감점이 발생하기 전에 최대한 빨리 신청하세요.");
      }
      return advice;
    }

    // [3단계] 잠재력 계산
    int potentialKorean = (30 - (_koreanScore + (_socialIntegrationBonus ? 10 : 0)));
    int potentialVolunteer = (_volunteerScore == 0) ? 1 : 0;

    // [4단계] 시나리오별 솔루션

    // Case A: 딱 1점 부족 -> 봉사 추천
    if (gap == 1 && potentialVolunteer > 0) {
      advice.add("🤝 **초강력 추천: 사회봉사 1년 (+1점)**\n합격까지 딱 **1점** 부족합니다! 어렵게 공부할 필요 없이 사회봉사(헌혈 등 포함)로 1점을 채우면 바로 합격입니다.");
    }

    // Case B: 한국어만으로 해결 가능
    else if (potentialKorean >= gap) {
      if (!_socialIntegrationBonus) {
        advice.add("💡 **1순위 추천: KIIP 5단계 (+10점)**\n사회통합프로그램 이수증(10점)을 챙기세요. 가장 확실한 합격 전략입니다.");
      } else {
        advice.add("📚 **한국어 점수 보강**\n현재 점수에서 **${gap}점**이 더 필요합니다. TOPIK 등급을 올려서 합격선을 넘겨보세요.");
      }
    }

    // Case C: [New] 콤보 전략 (한국어 만점 + 봉사 1점 필수)
    // 예: 69점 -> 한국어(+10) 해도 79점 -> 봉사(+1) 해야 80점
    else if ((potentialKorean + potentialVolunteer) >= gap) {
      advice.add("🧩 **최후의 전략 (한국어 만점 + 봉사)**\n한국어 점수를 끝까지 올려도 **1점**이 부족하게 됩니다.\n이 경우 **한국어(TOPIK/KIIP) 최고 등급** 달성과 함께 **사회봉사(1점)**까지 모두 챙겨야 겨우 80점을 맞출 수 있습니다.");
    }

    // Case D: 불가능
    else {
      advice.add("✅ **놓친 항목 체크**\n점수 차이가 큽니다. 혹시 놓친 가점이 있는지 확인해보세요.\n- **이공계 석사** (+3점)\n- **QS 500위 우수 대학** (+15~20점)\n- **국내 대학** 학위 (+5~10점)");
      advice.add("🛑 **현실적인 조언**\n위 항목 해당사항이 없다면, 올해 소득을 높여 **내년에 재도전**하거나 E-7 등 다른 비자를 고려하는 것이 좋습니다.");
    }

    return advice;
  }
}
