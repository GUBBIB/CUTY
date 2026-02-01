import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbaPermitState {
  final int currentStep; 
  // Step 0: Selection
  // Step 1: Visa Link
  // Step 2: Guide (Checks)
  // Step 3: Camera (3 stages)
  // Step 4: Info Confirm
  // Step 5: Signature
  // Step 6: Submit Complete (Pending School)
  // Step 7: School Approved (Show Stamp)
  // Step 8: Final Folder / HiKorea Guide
  // Step 9: Final Permit (Success)

  // Step 1 Data
  final bool isVisaLinked;

  // Step 2 Data
  final bool consentChecked;
  final bool purposeChecked;

  // Step 3 Data (Camera)
  final int cameraStep; // 0, 1, 2
  final String? bizLicenseImage;
  final String? contractImage;
  final String? idCardImage;

  // Step 4 & 5 Data (Detailed Form)
  // Student Info (Mock for now)
  final String studentName;
  final String studentRegNo;
  final String studentMajor;
  final String studentSemester;
  final String studentPhone;
  final String studentEmail;

  // Employer Info
  final String companyName;
  final String bizNo;
  final String ownerName;
  final String sectors; // 업종
  final String address;
  final String employerPhone;
  final String employmentPeriod;
  final String hourlyWage;
  final String weekdayWork; // 평일 근무
  final String weekendWork; // 주말 근무 (휴무)

  // Step 4 Data
  final bool infoCorrectChecked;

  // Step 5 Data (Signature)
  final List<Offset?> signaturePoints;
  final bool isSignatureSaved;

  // Step 8 Data
  final bool isPdfDownloaded;

  AlbaPermitState({
    this.currentStep = 0,
    this.isVisaLinked = false,
    this.consentChecked = false,
    this.purposeChecked = false,
    this.cameraStep = 0,
    this.bizLicenseImage,
    this.contractImage,
    this.idCardImage,
    
    // Student Defaults
    this.studentName = '김쿠티',
    this.studentRegNo = '990101-1234567',
    this.studentMajor = '컴퓨터공학과',
    this.studentSemester = '2학기',
    this.studentPhone = '010-1234-5678',
    this.studentEmail = 'cuty@university.ac.kr',

    // Employer Defaults
    this.companyName = '(주)쿠티카페테리아',
    this.bizNo = '123-45-67890',
    this.ownerName = '김쿠티',
    this.sectors = '음식점업',
    this.address = '부산광역시 해운대구 우동 123',
    this.employerPhone = '051-123-4567',
    this.employmentPeriod = '2024.03.01 ~ 2024.08.31 (6개월)',
    this.hourlyWage = '10,030원',
    this.weekdayWork = '18:00 ~ 22:00 (4시간)',
    this.weekendWork = '휴무',

    this.infoCorrectChecked = false,
    this.signaturePoints = const [],
    this.isSignatureSaved = false,
    this.isPdfDownloaded = false,
  });

  AlbaPermitState copyWith({
    int? currentStep,
    bool? isVisaLinked,
    bool? consentChecked,
    bool? purposeChecked,
    int? cameraStep,
    String? bizLicenseImage,
    String? contractImage,
    String? idCardImage,
    String? studentName,
    String? studentRegNo,
    String? studentMajor,
    String? studentSemester,
    String? studentPhone,
    String? studentEmail,
    String? companyName,
    String? bizNo,
    String? ownerName,
    String? sectors,
    String? address,
    String? employerPhone,
    String? employmentPeriod,
    String? hourlyWage,
    String? weekdayWork,
    String? weekendWork,
    bool? infoCorrectChecked,
    List<Offset?>? signaturePoints,
    bool? isSignatureSaved,
    bool? isPdfDownloaded,
  }) {
    return AlbaPermitState(
      currentStep: currentStep ?? this.currentStep,
      isVisaLinked: isVisaLinked ?? this.isVisaLinked,
      consentChecked: consentChecked ?? this.consentChecked,
      purposeChecked: purposeChecked ?? this.purposeChecked,
      cameraStep: cameraStep ?? this.cameraStep,
      bizLicenseImage: bizLicenseImage ?? this.bizLicenseImage,
      contractImage: contractImage ?? this.contractImage,
      idCardImage: idCardImage ?? this.idCardImage,
      studentName: studentName ?? this.studentName,
      studentRegNo: studentRegNo ?? this.studentRegNo,
      studentMajor: studentMajor ?? this.studentMajor,
      studentSemester: studentSemester ?? this.studentSemester,
      studentPhone: studentPhone ?? this.studentPhone,
      studentEmail: studentEmail ?? this.studentEmail,
      companyName: companyName ?? this.companyName,
      bizNo: bizNo ?? this.bizNo,
      ownerName: ownerName ?? this.ownerName,
      sectors: sectors ?? this.sectors,
      address: address ?? this.address,
      employerPhone: employerPhone ?? this.employerPhone,
      employmentPeriod: employmentPeriod ?? this.employmentPeriod,
      hourlyWage: hourlyWage ?? this.hourlyWage,
      weekdayWork: weekdayWork ?? this.weekdayWork,
      weekendWork: weekendWork ?? this.weekendWork,
      infoCorrectChecked: infoCorrectChecked ?? this.infoCorrectChecked,
      signaturePoints: signaturePoints ?? this.signaturePoints,
      isSignatureSaved: isSignatureSaved ?? this.isSignatureSaved,
      isPdfDownloaded: isPdfDownloaded ?? this.isPdfDownloaded,
    );
  }
}

class AlbaPermitNotifier extends StateNotifier<AlbaPermitState> {
  AlbaPermitNotifier() : super(AlbaPermitState());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void prevStep() {
    if (state.currentStep > 0) {
      // Step 4 is now Camera (was 3)
      if (state.currentStep == 4 && state.cameraStep > 0) {
        state = state.copyWith(cameraStep: state.cameraStep - 1);
      } else {
        state = state.copyWith(currentStep: state.currentStep - 1);
      }
    }
  }

  // Step 1: Visa Link
  void linkVisa() {
     state = state.copyWith(isVisaLinked: true);
  }

  // Step 2: Checks
  void toggleConsent() => state = state.copyWith(consentChecked: !state.consentChecked);
  void togglePurpose() => state = state.copyWith(purposeChecked: !state.purposeChecked);

  // Step 3: Camera
  void advanceCameraStep() {
    if (state.cameraStep < 2) {
      state = state.copyWith(cameraStep: state.cameraStep + 1);
    } else {
      nextStep(); 
    }
  }

  // Step 4: Form Updates
  void updateCompanyName(String v) => state = state.copyWith(companyName: v);
  void updateBizNo(String v) => state = state.copyWith(bizNo: v);
  void updateOwnerName(String v) => state = state.copyWith(ownerName: v);
  void updateAddress(String v) => state = state.copyWith(address: v);
  void updateHourlyWage(String v) => state = state.copyWith(hourlyWage: v);
  void updateWorkingHours(String v) {
    // In the simple form, we map this to weekdayWork for now, or split it if needed.
    // simpler to just update weekdayWork as the primary display
    state = state.copyWith(weekdayWork: v);
  }
  
  void toggleInfoCorrect() => state = state.copyWith(infoCorrectChecked: !state.infoCorrectChecked);

  // Step 5: Signature
  void addSignaturePoint(Offset? point) {
    if (state.isSignatureSaved) return;
    final newPoints = List<Offset?>.from(state.signaturePoints)..add(point);
    state = state.copyWith(signaturePoints: newPoints);
  }

  void clearSignature() {
    state = state.copyWith(signaturePoints: [], isSignatureSaved: false);
  }

  void saveSignature() {
    state = state.copyWith(isSignatureSaved: true);
  }

  // Step 8: PDF Download
  void downloadPdf() {
    state = state.copyWith(isPdfDownloaded: true);
  }
}

final albaPermitProvider = StateNotifierProvider.autoDispose<AlbaPermitNotifier, AlbaPermitState>((ref) {
  return AlbaPermitNotifier();
});
