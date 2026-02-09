import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'유니링크'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get navShop;

  /// No description provided for @navMy.
  ///
  /// In ko, this message translates to:
  /// **'마이'**
  String get navMy;

  /// No description provided for @navCommunity.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티'**
  String get navCommunity;

  /// No description provided for @goalSelectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'목표 설정'**
  String get goalSelectionTitle;

  /// No description provided for @goalSelectionSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'비자 목표를 선택해주세요.'**
  String get goalSelectionSubtitle;

  /// No description provided for @goalSchoolTitle.
  ///
  /// In ko, this message translates to:
  /// **'학교 생활형 (기본형)'**
  String get goalSchoolTitle;

  /// No description provided for @goalSchoolSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'일단은 학교 생활에 집중할래요'**
  String get goalSchoolSubtitle;

  /// No description provided for @goalSchoolDesc.
  ///
  /// In ko, this message translates to:
  /// **'일단은 즐거운 캠퍼스 라이프가 우선이죠! 출석률 관리와 학점, 비자 연장에 필요한 기본기부터 탄탄하게 다져봐요.'**
  String get goalSchoolDesc;

  /// No description provided for @goalResearchTitle.
  ///
  /// In ko, this message translates to:
  /// **'연구/거주형'**
  String get goalResearchTitle;

  /// No description provided for @goalResearchSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'대학원 진학 예정 & F-2-7(거주) 목표'**
  String get goalResearchSubtitle;

  /// No description provided for @goalResearchDesc.
  ///
  /// In ko, this message translates to:
  /// **'단순 취업비자(E-7)에 만족하지 마세요. 석사 학위를 활용해 더 자유로운 F-2-7(거주 비자)로 바로 업그레이드 할 수 있습니다. 80점 달성을 위한 족집게 전략을 알려드릴게요.'**
  String get goalResearchDesc;

  /// No description provided for @goalJobTitle.
  ///
  /// In ko, this message translates to:
  /// **'실전 취업형 (E-7)'**
  String get goalJobTitle;

  /// No description provided for @goalJobSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'학사 졸업 후 한국에 취업할래요 (E-7 비자)'**
  String get goalJobSubtitle;

  /// No description provided for @goalJobDesc.
  ///
  /// In ko, this message translates to:
  /// **'D-10 구직비자 자격 진단부터 E-7 직종 코드 확인, 취업 역량 분석까지 한번에! 졸업 후 한국 기업 취업을 위한 A to Z를 이 로드맵에 다 담았어요.'**
  String get goalJobDesc;

  /// No description provided for @goalStartupTitle.
  ///
  /// In ko, this message translates to:
  /// **'창업형 (D-8-4)'**
  String get goalStartupTitle;

  /// No description provided for @goalStartupSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'나만의 아이디어로 기술창업 도전'**
  String get goalStartupSubtitle;

  /// No description provided for @goalStartupDesc.
  ///
  /// In ko, this message translates to:
  /// **'D-10-1(구직)과 다릅니다. 창업 준비를 위해 최대 2년간 체류하며 OASIS 점수를 채우는 비자입니다.'**
  String get goalStartupDesc;

  /// No description provided for @goalGlobalTitle.
  ///
  /// In ko, this message translates to:
  /// **'글로벌형'**
  String get goalGlobalTitle;

  /// No description provided for @goalGlobalSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'한국 학위 취득 후 본국/해외 진출'**
  String get goalGlobalSubtitle;

  /// No description provided for @goalGlobalDesc.
  ///
  /// In ko, this message translates to:
  /// **'한국에서의 학업을 마치고 더 넓은 세상으로! 원활한 귀국 준비나 제3국 진출을 위한 서류 작업을 도와드릴게요.'**
  String get goalGlobalDesc;

  /// No description provided for @msgGoalChangeInfo.
  ///
  /// In ko, this message translates to:
  /// **'class는 자유롭게 변경 가능해요!'**
  String get msgGoalChangeInfo;

  /// No description provided for @btnLookAround.
  ///
  /// In ko, this message translates to:
  /// **'다른 거 볼래요'**
  String get btnLookAround;

  /// No description provided for @btnConfirmGoal.
  ///
  /// In ko, this message translates to:
  /// **'이걸로 결정!'**
  String get btnConfirmGoal;

  /// No description provided for @roadmapClassChange.
  ///
  /// In ko, this message translates to:
  /// **'수강신청 변경 기간'**
  String get roadmapClassChange;

  /// No description provided for @roadmapConsultant.
  ///
  /// In ko, this message translates to:
  /// **'F-2-7 비자 컨설턴트'**
  String get roadmapConsultant;

  /// No description provided for @roadmapConsultantDesc.
  ///
  /// In ko, this message translates to:
  /// **'모의 점수를 계산하면 AI가 맞춤형 합격 전략을 분석해드려요.'**
  String get roadmapConsultantDesc;

  /// No description provided for @roadmapCalculator.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산기'**
  String get roadmapCalculator;

  /// No description provided for @btnRecalculate.
  ///
  /// In ko, this message translates to:
  /// **'다시 계산'**
  String get btnRecalculate;

  /// No description provided for @btnCalculate.
  ///
  /// In ko, this message translates to:
  /// **'계산하기'**
  String get btnCalculate;

  /// No description provided for @conceptTitle.
  ///
  /// In ko, this message translates to:
  /// **'F-2-7 비자 개념 잡기'**
  String get conceptTitle;

  /// No description provided for @conceptFormula1.
  ///
  /// In ko, this message translates to:
  /// **'E-7 직종'**
  String get conceptFormula1;

  /// No description provided for @conceptFormula2.
  ///
  /// In ko, this message translates to:
  /// **'80점'**
  String get conceptFormula2;

  /// No description provided for @conceptFormula3.
  ///
  /// In ko, this message translates to:
  /// **'F-2-7'**
  String get conceptFormula3;

  /// No description provided for @conceptDesc.
  ///
  /// In ko, this message translates to:
  /// **'직종은 같습니다. (E-7-1 전문직) 하지만 석사 이상 학위에 점수(80점)를 채우면 비자가 업그레이드됩니다.'**
  String get conceptDesc;

  /// No description provided for @conceptWhy.
  ///
  /// In ko, this message translates to:
  /// **'왜 업그레이드 해야 할까요?'**
  String get conceptWhy;

  /// No description provided for @conceptVisaE7.
  ///
  /// In ko, this message translates to:
  /// **'일반 취업(E-7)'**
  String get conceptVisaE7;

  /// No description provided for @conceptVisaF27.
  ///
  /// In ko, this message translates to:
  /// **'거주 비자(F-2-7)'**
  String get conceptVisaF27;

  /// No description provided for @conceptRow1Title.
  ///
  /// In ko, this message translates to:
  /// **'이직의 자유'**
  String get conceptRow1Title;

  /// No description provided for @conceptRow1Bad.
  ///
  /// In ko, this message translates to:
  /// **'회사 허가 필수'**
  String get conceptRow1Bad;

  /// No description provided for @conceptRow1Good.
  ///
  /// In ko, this message translates to:
  /// **'자유로운 이직'**
  String get conceptRow1Good;

  /// No description provided for @conceptRow2Title.
  ///
  /// In ko, this message translates to:
  /// **'체류 기간'**
  String get conceptRow2Title;

  /// No description provided for @conceptRow2Bad.
  ///
  /// In ko, this message translates to:
  /// **'1~2년 (단기)'**
  String get conceptRow2Bad;

  /// No description provided for @conceptRow2Good.
  ///
  /// In ko, this message translates to:
  /// **'최대 5년 (장기)'**
  String get conceptRow2Good;

  /// No description provided for @conceptRow3Title.
  ///
  /// In ko, this message translates to:
  /// **'가족 혜택'**
  String get conceptRow3Title;

  /// No description provided for @conceptRow3Bad.
  ///
  /// In ko, this message translates to:
  /// **'배우자 취업 불가'**
  String get conceptRow3Bad;

  /// No description provided for @conceptRow3Good.
  ///
  /// In ko, this message translates to:
  /// **'배우자 취업 가능'**
  String get conceptRow3Good;

  /// No description provided for @lblMyGoal.
  ///
  /// In ko, this message translates to:
  /// **'나의 목표'**
  String get lblMyGoal;

  /// No description provided for @lblResidencyVisa.
  ///
  /// In ko, this message translates to:
  /// **'연구/거주형 (F-2)'**
  String get lblResidencyVisa;

  /// No description provided for @itemCategoryCafe.
  ///
  /// In ko, this message translates to:
  /// **'카페/간식'**
  String get itemCategoryCafe;

  /// No description provided for @itemCategoryStore.
  ///
  /// In ko, this message translates to:
  /// **'편의점'**
  String get itemCategoryStore;

  /// No description provided for @itemCategoryVoucher.
  ///
  /// In ko, this message translates to:
  /// **'상품권'**
  String get itemCategoryVoucher;

  /// No description provided for @msgPointShopComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'포인트 상점 준비 중입니다.'**
  String get msgPointShopComingSoon;

  /// No description provided for @bannerAdPoint.
  ///
  /// In ko, this message translates to:
  /// **'광고보고 포인트 받기!'**
  String get bannerAdPoint;

  /// No description provided for @tagAd.
  ///
  /// In ko, this message translates to:
  /// **'광고'**
  String get tagAd;

  /// No description provided for @bannerNewDiscount.
  ///
  /// In ko, this message translates to:
  /// **'신규 제휴 할인'**
  String get bannerNewDiscount;

  /// No description provided for @tagEvent.
  ///
  /// In ko, this message translates to:
  /// **'이벤트'**
  String get tagEvent;

  /// No description provided for @bannerInviteFriend.
  ///
  /// In ko, this message translates to:
  /// **'친구 초대하고 포인트 받기'**
  String get bannerInviteFriend;

  /// No description provided for @tagInvite.
  ///
  /// In ko, this message translates to:
  /// **'초대'**
  String get tagInvite;

  /// No description provided for @tabShop.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get tabShop;

  /// No description provided for @tabHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get tabHome;

  /// No description provided for @tabMy.
  ///
  /// In ko, this message translates to:
  /// **'마이'**
  String get tabMy;

  /// No description provided for @dashboardTitle.
  ///
  /// In ko, this message translates to:
  /// **'비자 대시보드'**
  String get dashboardTitle;

  /// No description provided for @dashboardVisaStatus.
  ///
  /// In ko, this message translates to:
  /// **'현재 비자 상태'**
  String get dashboardVisaStatus;

  /// No description provided for @dashboardUnlinked.
  ///
  /// In ko, this message translates to:
  /// **'미연동'**
  String get dashboardUnlinked;

  /// No description provided for @dashboardSafe.
  ///
  /// In ko, this message translates to:
  /// **'안전'**
  String get dashboardSafe;

  /// No description provided for @dashboardWorkPermit.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 허가'**
  String get dashboardWorkPermit;

  /// No description provided for @statusApproved.
  ///
  /// In ko, this message translates to:
  /// **'승인됨'**
  String get statusApproved;

  /// No description provided for @statusPending.
  ///
  /// In ko, this message translates to:
  /// **'심사중'**
  String get statusPending;

  /// No description provided for @scheduleTitle.
  ///
  /// In ko, this message translates to:
  /// **'주간 시간표'**
  String get scheduleTitle;

  /// No description provided for @btnEdit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get btnEdit;

  /// No description provided for @labelClass.
  ///
  /// In ko, this message translates to:
  /// **'수업'**
  String get labelClass;

  /// No description provided for @menuSpecWallet.
  ///
  /// In ko, this message translates to:
  /// **'스펙 지갑'**
  String get menuSpecWallet;

  /// No description provided for @menuCommunityActivity.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티 활동'**
  String get menuCommunityActivity;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @appSettingsSection.
  ///
  /// In ko, this message translates to:
  /// **'앱 설정'**
  String get appSettingsSection;

  /// No description provided for @languageSetting.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSetting;

  /// No description provided for @notificationSetting.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSetting;

  /// No description provided for @screenSetting.
  ///
  /// In ko, this message translates to:
  /// **'화면 설정'**
  String get screenSetting;

  /// No description provided for @infoSection.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get infoSection;

  /// No description provided for @versionInfo.
  ///
  /// In ko, this message translates to:
  /// **'버전 정보'**
  String get versionInfo;

  /// No description provided for @termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @accountSection.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get accountSection;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get deleteAccount;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogContent.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 하시겠습니까?'**
  String get logoutDialogContent;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In ko, this message translates to:
  /// **'정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.'**
  String get deleteAccountDialogContent;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴'**
  String get delete;

  /// No description provided for @displayThemeTitle.
  ///
  /// In ko, this message translates to:
  /// **'화면 테마'**
  String get displayThemeTitle;

  /// No description provided for @displayThemeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get displayThemeSystem;

  /// No description provided for @displayThemeLight.
  ///
  /// In ko, this message translates to:
  /// **'라이트 모드'**
  String get displayThemeLight;

  /// No description provided for @displayThemeDark.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get displayThemeDark;

  /// No description provided for @menuVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전 정보'**
  String get menuVersion;

  /// No description provided for @menuTerms.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get menuTerms;

  /// No description provided for @menuPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get menuPrivacy;

  /// No description provided for @sectionAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get sectionAccount;

  /// No description provided for @menuLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get menuLogout;

  /// No description provided for @msgLogout.
  ///
  /// In ko, this message translates to:
  /// **'정말 로그아웃 하시겠습니까?'**
  String get msgLogout;

  /// No description provided for @settingDeleteAccount.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get settingDeleteAccount;

  /// No description provided for @menuLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get menuLanguage;

  /// No description provided for @hintComment.
  ///
  /// In ko, this message translates to:
  /// **'댓글을 입력하세요'**
  String get hintComment;

  /// No description provided for @docARC.
  ///
  /// In ko, this message translates to:
  /// **'외국인등록증'**
  String get docARC;

  /// No description provided for @docStudentId.
  ///
  /// In ko, this message translates to:
  /// **'학생증'**
  String get docStudentId;

  /// No description provided for @docPassport.
  ///
  /// In ko, this message translates to:
  /// **'여권 사본'**
  String get docPassport;

  /// No description provided for @docResidenceProof.
  ///
  /// In ko, this message translates to:
  /// **'거주지 증빙'**
  String get docResidenceProof;

  /// No description provided for @docResidenceCert.
  ///
  /// In ko, this message translates to:
  /// **'거주지증명서'**
  String get docResidenceCert;

  /// No description provided for @docLease.
  ///
  /// In ko, this message translates to:
  /// **'임대차증명서'**
  String get docLease;

  /// No description provided for @docDorm.
  ///
  /// In ko, this message translates to:
  /// **'기숙사입사확인서'**
  String get docDorm;

  /// No description provided for @docResidenceConfirm.
  ///
  /// In ko, this message translates to:
  /// **'거주숙소제공확인서'**
  String get docResidenceConfirm;

  /// No description provided for @docEnrollment.
  ///
  /// In ko, this message translates to:
  /// **'재학증명서'**
  String get docEnrollment;

  /// No description provided for @docTranscript.
  ///
  /// In ko, this message translates to:
  /// **'성적증명서'**
  String get docTranscript;

  /// No description provided for @docCompletion.
  ///
  /// In ko, this message translates to:
  /// **'수료증명서'**
  String get docCompletion;

  /// No description provided for @docTopik.
  ///
  /// In ko, this message translates to:
  /// **'TOPIK 성적표'**
  String get docTopik;

  /// No description provided for @docKiip.
  ///
  /// In ko, this message translates to:
  /// **'사회통합프로그램'**
  String get docKiip;

  /// No description provided for @docForeignLang.
  ///
  /// In ko, this message translates to:
  /// **'외국어 성적'**
  String get docForeignLang;

  /// No description provided for @docVolunteer.
  ///
  /// In ko, this message translates to:
  /// **'봉사활동 확인서'**
  String get docVolunteer;

  /// No description provided for @docCareer.
  ///
  /// In ko, this message translates to:
  /// **'경력증명서'**
  String get docCareer;

  /// No description provided for @docAward.
  ///
  /// In ko, this message translates to:
  /// **'수상경력'**
  String get docAward;

  /// No description provided for @docCertificate.
  ///
  /// In ko, this message translates to:
  /// **'자격증'**
  String get docCertificate;

  /// No description provided for @docLicense.
  ///
  /// In ko, this message translates to:
  /// **'면허증'**
  String get docLicense;

  /// No description provided for @docOther.
  ///
  /// In ko, this message translates to:
  /// **'기타 서류'**
  String get docOther;

  /// No description provided for @specWalletTitle.
  ///
  /// In ko, this message translates to:
  /// **'내 서류 지갑'**
  String get specWalletTitle;

  /// No description provided for @specSectionIdentity.
  ///
  /// In ko, this message translates to:
  /// **'필수 신분/체류'**
  String get specSectionIdentity;

  /// No description provided for @specSectionIdentityDesc.
  ///
  /// In ko, this message translates to:
  /// **'안전한 체류를 위한 필수 서류'**
  String get specSectionIdentityDesc;

  /// No description provided for @specSectionAcademic.
  ///
  /// In ko, this message translates to:
  /// **'학력/성적'**
  String get specSectionAcademic;

  /// No description provided for @specSectionAcademicDesc.
  ///
  /// In ko, this message translates to:
  /// **'학교 관련 서류'**
  String get specSectionAcademicDesc;

  /// No description provided for @specSectionCareer.
  ///
  /// In ko, this message translates to:
  /// **'스펙/경력'**
  String get specSectionCareer;

  /// No description provided for @specSectionCareerDesc.
  ///
  /// In ko, this message translates to:
  /// **'취업 증빙 서류'**
  String get specSectionCareerDesc;

  /// No description provided for @lblRegistered.
  ///
  /// In ko, this message translates to:
  /// **'등록됨'**
  String get lblRegistered;

  /// No description provided for @btnCheckDoc.
  ///
  /// In ko, this message translates to:
  /// **'서류 확인'**
  String get btnCheckDoc;

  /// No description provided for @msgDocEmpty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 서류가 없습니다.'**
  String get msgDocEmpty;

  /// No description provided for @msgDocLoading.
  ///
  /// In ko, this message translates to:
  /// **'서류를 불러오는 중...'**
  String get msgDocLoading;

  /// No description provided for @btnUploadPdf.
  ///
  /// In ko, this message translates to:
  /// **'PDF 업로드'**
  String get btnUploadPdf;

  /// No description provided for @msgDocReward.
  ///
  /// In ko, this message translates to:
  /// **'등록 시 포인트 지급'**
  String get msgDocReward;

  /// No description provided for @btnUploadCamera.
  ///
  /// In ko, this message translates to:
  /// **'카메라 촬영'**
  String get btnUploadCamera;

  /// No description provided for @btnDeleteDoc.
  ///
  /// In ko, this message translates to:
  /// **'문서 삭제'**
  String get btnDeleteDoc;

  /// No description provided for @msgDeleteNotReady.
  ///
  /// In ko, this message translates to:
  /// **'삭제 기능 준비 중'**
  String get msgDeleteNotReady;

  /// No description provided for @pointHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'포인트 내역'**
  String get pointHistoryTitle;

  /// No description provided for @pointCurrentBalance.
  ///
  /// In ko, this message translates to:
  /// **'보유 포인트'**
  String get pointCurrentBalance;

  /// No description provided for @pointActionUploadDoc.
  ///
  /// In ko, this message translates to:
  /// **'서류 등록'**
  String get pointActionUploadDoc;

  /// No description provided for @pointActionWriteReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 작성'**
  String get pointActionWriteReview;

  /// No description provided for @msgPointEmpty.
  ///
  /// In ko, this message translates to:
  /// **'포인트 내역이 없습니다.'**
  String get msgPointEmpty;

  /// No description provided for @homeCheerMessage.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 화이팅!'**
  String get homeCheerMessage;

  /// No description provided for @homeMsg01.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 파이팅! 🔥'**
  String get homeMsg01;

  /// No description provided for @homeMsg02.
  ///
  /// In ko, this message translates to:
  /// **'비자 준비는 잘 돼가? 🛂'**
  String get homeMsg02;

  /// No description provided for @homeMsg03.
  ///
  /// In ko, this message translates to:
  /// **'맛있는 거 챙겨 먹어! 밥심! 🍚'**
  String get homeMsg03;

  /// No description provided for @homeMsg04.
  ///
  /// In ko, this message translates to:
  /// **'잠깐 산책이라도 어때? 🌿'**
  String get homeMsg04;

  /// No description provided for @homeMsg05.
  ///
  /// In ko, this message translates to:
  /// **'넌 할 수 있어! 걱정 마! ✨'**
  String get homeMsg05;

  /// No description provided for @homeMsg06.
  ///
  /// In ko, this message translates to:
  /// **'좋은 일이 생길 거야! 🍀'**
  String get homeMsg06;

  /// No description provided for @msgFortuneAlreadyOpened.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 이미 포춘쿠키를 열었어요!'**
  String get msgFortuneAlreadyOpened;

  /// No description provided for @msgDevFortuneReset.
  ///
  /// In ko, this message translates to:
  /// **'개발용: 포춘쿠키 초기화됨'**
  String get msgDevFortuneReset;

  /// No description provided for @titleFortuneCookie.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 포춘쿠키'**
  String get titleFortuneCookie;

  /// No description provided for @descFortuneCookie.
  ///
  /// In ko, this message translates to:
  /// **'당신의 운세를 확인해보세요!'**
  String get descFortuneCookie;

  /// No description provided for @btnCheckFortune.
  ///
  /// In ko, this message translates to:
  /// **'운세 확인하기'**
  String get btnCheckFortune;

  /// No description provided for @msgPointsEarned.
  ///
  /// In ko, this message translates to:
  /// **'포인트 획득!'**
  String get msgPointsEarned;

  /// No description provided for @btnConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get btnConfirm;

  /// No description provided for @lblCommunityPreview.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티 인기글'**
  String get lblCommunityPreview;

  /// No description provided for @btnMore.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get btnMore;

  /// No description provided for @boardPopularTitle.
  ///
  /// In ko, this message translates to:
  /// **'인기게시판'**
  String get boardPopularTitle;

  /// No description provided for @boardPopularSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'지금 가장 핫한 이야기 모음'**
  String get boardPopularSubtitle;

  /// No description provided for @boardFreeTitle.
  ///
  /// In ko, this message translates to:
  /// **'자유게시판'**
  String get boardFreeTitle;

  /// No description provided for @boardFreeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'유학생들의 솔직한 수다 공간'**
  String get boardFreeSubtitle;

  /// No description provided for @boardQuestionTitle.
  ///
  /// In ko, this message translates to:
  /// **'질문게시판'**
  String get boardQuestionTitle;

  /// No description provided for @boardQuestionSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'궁금한 건 물어보세요'**
  String get boardQuestionSubtitle;

  /// No description provided for @boardInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'정보게시판'**
  String get boardInfoTitle;

  /// No description provided for @boardInfoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'학교 생할 꿀팁 & 강의 정보'**
  String get boardInfoSubtitle;

  /// No description provided for @boardMarketTitle.
  ///
  /// In ko, this message translates to:
  /// **'중고장터'**
  String get boardMarketTitle;

  /// No description provided for @boardMarketSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'전공책, 자취용품 사고 팔기'**
  String get boardMarketSubtitle;

  /// No description provided for @boardCreateTitle.
  ///
  /// In ko, this message translates to:
  /// **'게시판 생성'**
  String get boardCreateTitle;

  /// No description provided for @boardCreateSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'원하는 주제가 없나요? 직접 만들어 보세요!'**
  String get boardCreateSubtitle;

  /// No description provided for @msgCreateBoardDialog.
  ///
  /// In ko, this message translates to:
  /// **'새로운 게시판을 요청하시겠습니까?'**
  String get msgCreateBoardDialog;

  /// No description provided for @btnApply.
  ///
  /// In ko, this message translates to:
  /// **'신청하기'**
  String get btnApply;

  /// No description provided for @msgApplySuccess.
  ///
  /// In ko, this message translates to:
  /// **'신청되었습니다.'**
  String get msgApplySuccess;

  /// No description provided for @msgClassFinished.
  ///
  /// In ko, this message translates to:
  /// **'강의 일정 없음'**
  String get msgClassFinished;

  /// No description provided for @msgRest.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 더 이상 수업이 없어요!'**
  String get msgRest;

  /// No description provided for @msgNoClass.
  ///
  /// In ko, this message translates to:
  /// **'수업 없음'**
  String get msgNoClass;

  /// No description provided for @menuJobs.
  ///
  /// In ko, this message translates to:
  /// **'알바/취업'**
  String get menuJobs;

  /// No description provided for @menuSchedule.
  ///
  /// In ko, this message translates to:
  /// **'시간표'**
  String get menuSchedule;

  /// No description provided for @menuAcademics.
  ///
  /// In ko, this message translates to:
  /// **'학사'**
  String get menuAcademics;

  /// No description provided for @menuFood.
  ///
  /// In ko, this message translates to:
  /// **'학식'**
  String get menuFood;

  /// No description provided for @lblPreparing.
  ///
  /// In ko, this message translates to:
  /// **'준비중'**
  String get lblPreparing;

  /// No description provided for @dialogResetTitle.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get dialogResetTitle;

  /// No description provided for @dialogResetContent.
  ///
  /// In ko, this message translates to:
  /// **'정말 초기화 하시겠습니까?'**
  String get dialogResetContent;

  /// No description provided for @btnCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get btnCancel;

  /// No description provided for @btnReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get btnReset;

  /// No description provided for @msgResetComplete.
  ///
  /// In ko, this message translates to:
  /// **'초기화 되었습니다.'**
  String get msgResetComplete;

  /// No description provided for @msgNoJobs.
  ///
  /// In ko, this message translates to:
  /// **'등록된 채용 공고가 없습니다.'**
  String get msgNoJobs;

  /// No description provided for @jobListTitle.
  ///
  /// In ko, this message translates to:
  /// **'채용 공고'**
  String get jobListTitle;

  /// No description provided for @jobSalaryAnnual.
  ///
  /// In ko, this message translates to:
  /// **'연봉'**
  String get jobSalaryAnnual;

  /// No description provided for @jobSalaryHourly.
  ///
  /// In ko, this message translates to:
  /// **'시급'**
  String get jobSalaryHourly;

  /// No description provided for @jobFilterTitle.
  ///
  /// In ko, this message translates to:
  /// **'공고 필터링하기'**
  String get jobFilterTitle;

  /// No description provided for @careerMatchedCompanies.
  ///
  /// In ko, this message translates to:
  /// **'매칭된 기업'**
  String get careerMatchedCompanies;

  /// No description provided for @msgLockedReport.
  ///
  /// In ko, this message translates to:
  /// **'상세 리포트 잠김'**
  String get msgLockedReport;

  /// No description provided for @msgLockedReportSub.
  ///
  /// In ko, this message translates to:
  /// **'포인트를 사용해 확인하세요'**
  String get msgLockedReportSub;

  /// No description provided for @btnDiagnoseNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 진단하기'**
  String get btnDiagnoseNow;

  /// No description provided for @msgNoRecommendedJobs.
  ///
  /// In ko, this message translates to:
  /// **'추천 공고가 없습니다.'**
  String get msgNoRecommendedJobs;

  /// No description provided for @lblVisaReport.
  ///
  /// In ko, this message translates to:
  /// **'비자 리포트'**
  String get lblVisaReport;

  /// No description provided for @lblTier.
  ///
  /// In ko, this message translates to:
  /// **'등급'**
  String get lblTier;

  /// No description provided for @msgTierCongrat.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!'**
  String get msgTierCongrat;

  /// No description provided for @msgTierSuffix.
  ///
  /// In ko, this message translates to:
  /// **'등급입니다'**
  String get msgTierSuffix;

  /// No description provided for @lblRecJob.
  ///
  /// In ko, this message translates to:
  /// **'추천 공고'**
  String get lblRecJob;

  /// No description provided for @msgRecJobPrefix.
  ///
  /// In ko, this message translates to:
  /// **'당신에게 딱 맞는'**
  String get msgRecJobPrefix;

  /// No description provided for @msgRecJobSuffix.
  ///
  /// In ko, this message translates to:
  /// **'공고'**
  String get msgRecJobSuffix;

  /// No description provided for @insightPerfect.
  ///
  /// In ko, this message translates to:
  /// **'완벽해요'**
  String get insightPerfect;

  /// No description provided for @insightTopik.
  ///
  /// In ko, this message translates to:
  /// **'TOPIK'**
  String get insightTopik;

  /// No description provided for @insightInternship.
  ///
  /// In ko, this message translates to:
  /// **'인턴 경험'**
  String get insightInternship;

  /// No description provided for @jobTabPartTime.
  ///
  /// In ko, this message translates to:
  /// **'아르바이트'**
  String get jobTabPartTime;

  /// No description provided for @jobTabPartTimeSub.
  ///
  /// In ko, this message translates to:
  /// **'(Part-Time)'**
  String get jobTabPartTimeSub;

  /// No description provided for @jobTabCareer.
  ///
  /// In ko, this message translates to:
  /// **'취업'**
  String get jobTabCareer;

  /// No description provided for @jobTabCareerSub.
  ///
  /// In ko, this message translates to:
  /// **'(jobs)'**
  String get jobTabCareerSub;

  /// No description provided for @bannerJobScore.
  ///
  /// In ko, this message translates to:
  /// **'취업역량 점수: {score}'**
  String bannerJobScore(Object score);

  /// No description provided for @bannerDiagnosisTitle.
  ///
  /// In ko, this message translates to:
  /// **'내 취업 점수는 몇점일까요?'**
  String get bannerDiagnosisTitle;

  /// No description provided for @bannerActionTest.
  ///
  /// In ko, this message translates to:
  /// **'진단하기'**
  String get bannerActionTest;

  /// No description provided for @bannerActionRetest.
  ///
  /// In ko, this message translates to:
  /// **'다시 진단하기'**
  String get bannerActionRetest;

  /// No description provided for @labelWrite.
  ///
  /// In ko, this message translates to:
  /// **'글쓰기'**
  String get labelWrite;

  /// No description provided for @walletPending.
  ///
  /// In ko, this message translates to:
  /// **'처리상태: 대기중'**
  String get walletPending;

  /// No description provided for @filterInfo.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get filterInfo;

  /// No description provided for @boardPopular.
  ///
  /// In ko, this message translates to:
  /// **'인기게시판'**
  String get boardPopular;

  /// No description provided for @postTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력하세요'**
  String get postTitleHint;

  /// No description provided for @labelAnonymous.
  ///
  /// In ko, this message translates to:
  /// **'익명'**
  String get labelAnonymous;

  /// No description provided for @priceFree.
  ///
  /// In ko, this message translates to:
  /// **'나눔'**
  String get priceFree;

  /// No description provided for @menuSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get menuSettings;

  /// No description provided for @stepProposal.
  ///
  /// In ko, this message translates to:
  /// **'연구계획서'**
  String get stepProposal;

  /// No description provided for @stepApplication.
  ///
  /// In ko, this message translates to:
  /// **'심사신청'**
  String get stepApplication;

  /// No description provided for @stepPreliminary.
  ///
  /// In ko, this message translates to:
  /// **'예비심사'**
  String get stepPreliminary;

  /// No description provided for @stepDefense.
  ///
  /// In ko, this message translates to:
  /// **'본심사'**
  String get stepDefense;

  /// No description provided for @stepSubmission.
  ///
  /// In ko, this message translates to:
  /// **'최종제출'**
  String get stepSubmission;

  /// No description provided for @lblDaysLeft.
  ///
  /// In ko, this message translates to:
  /// **'남음'**
  String get lblDaysLeft;

  /// No description provided for @msgDocReady.
  ///
  /// In ko, this message translates to:
  /// **'서류 준비 완료'**
  String get msgDocReady;

  /// No description provided for @msgScoreGain.
  ///
  /// In ko, this message translates to:
  /// **'점수 획득'**
  String get msgScoreGain;

  /// No description provided for @scheduleDayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get scheduleDayMon;

  /// No description provided for @scheduleDayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get scheduleDayTue;

  /// No description provided for @scheduleDayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get scheduleDayWed;

  /// No description provided for @scheduleDayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get scheduleDayThu;

  /// No description provided for @scheduleDayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get scheduleDayFri;

  /// No description provided for @scheduleDaySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get scheduleDaySat;

  /// No description provided for @scheduleDaySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get scheduleDaySun;

  /// No description provided for @scheduleAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'일정 추가'**
  String get scheduleAddTitle;

  /// No description provided for @scheduleFieldTitle.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get scheduleFieldTitle;

  /// No description provided for @scheduleFieldRoom.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get scheduleFieldRoom;

  /// No description provided for @scheduleFieldDay.
  ///
  /// In ko, this message translates to:
  /// **'요일'**
  String get scheduleFieldDay;

  /// No description provided for @scheduleFieldTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get scheduleFieldTime;

  /// No description provided for @scheduleFieldDuration.
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get scheduleFieldDuration;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @walletTitle.
  ///
  /// In ko, this message translates to:
  /// **'서류 지갑'**
  String get walletTitle;

  /// No description provided for @boardFree.
  ///
  /// In ko, this message translates to:
  /// **'자유게시판'**
  String get boardFree;

  /// No description provided for @boardInfo.
  ///
  /// In ko, this message translates to:
  /// **'정보게시판'**
  String get boardInfo;

  /// No description provided for @boardQuestion.
  ///
  /// In ko, this message translates to:
  /// **'질문게시판'**
  String get boardQuestion;

  /// No description provided for @boardMarket.
  ///
  /// In ko, this message translates to:
  /// **'장터게시판'**
  String get boardMarket;

  /// No description provided for @timeJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String timeMinutesAgo(Object minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String timeHoursAgo(Object hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String timeDaysAgo(Object days);

  /// No description provided for @visaRoadmapStep3.
  ///
  /// In ko, this message translates to:
  /// **'나의 목표'**
  String get visaRoadmapStep3;

  /// No description provided for @visaGoalOasis.
  ///
  /// In ko, this message translates to:
  /// **'OASIS 프로그램'**
  String get visaGoalOasis;

  /// No description provided for @visaGoalApostille.
  ///
  /// In ko, this message translates to:
  /// **'아포스티유 인증'**
  String get visaGoalApostille;

  /// No description provided for @visaGoalCleanExit.
  ///
  /// In ko, this message translates to:
  /// **'출국 준비'**
  String get visaGoalCleanExit;

  /// No description provided for @visaGoalD10.
  ///
  /// In ko, this message translates to:
  /// **'구직 비자(D-10)'**
  String get visaGoalD10;

  /// No description provided for @jobCategoryService.
  ///
  /// In ko, this message translates to:
  /// **'서비스'**
  String get jobCategoryService;

  /// No description provided for @jobCategoryTourism.
  ///
  /// In ko, this message translates to:
  /// **'관광/여행'**
  String get jobCategoryTourism;

  /// No description provided for @jobCategoryTrade.
  ///
  /// In ko, this message translates to:
  /// **'무역/유통'**
  String get jobCategoryTrade;

  /// No description provided for @jobCategoryIT.
  ///
  /// In ko, this message translates to:
  /// **'IT/인터넷'**
  String get jobCategoryIT;

  /// No description provided for @jobCategoryMarketing.
  ///
  /// In ko, this message translates to:
  /// **'마케팅'**
  String get jobCategoryMarketing;

  /// No description provided for @jobCategoryEducation.
  ///
  /// In ko, this message translates to:
  /// **'교육'**
  String get jobCategoryEducation;

  /// No description provided for @jobCategoryMedical.
  ///
  /// In ko, this message translates to:
  /// **'의료'**
  String get jobCategoryMedical;

  /// No description provided for @jobCategoryOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get jobCategoryOther;

  /// No description provided for @locationSeoul.
  ///
  /// In ko, this message translates to:
  /// **'서울'**
  String get locationSeoul;

  /// No description provided for @locationGyeonggi.
  ///
  /// In ko, this message translates to:
  /// **'경기'**
  String get locationGyeonggi;

  /// No description provided for @locationBusan.
  ///
  /// In ko, this message translates to:
  /// **'부산'**
  String get locationBusan;

  /// No description provided for @locationDaegu.
  ///
  /// In ko, this message translates to:
  /// **'대구'**
  String get locationDaegu;

  /// No description provided for @locationDaejeon.
  ///
  /// In ko, this message translates to:
  /// **'대전'**
  String get locationDaejeon;

  /// No description provided for @locationGwangju.
  ///
  /// In ko, this message translates to:
  /// **'광주'**
  String get locationGwangju;

  /// No description provided for @locationAny.
  ///
  /// In ko, this message translates to:
  /// **'전국'**
  String get locationAny;

  /// No description provided for @consultingCheckingWallet.
  ///
  /// In ko, this message translates to:
  /// **'지갑 확인 중...'**
  String get consultingCheckingWallet;

  /// No description provided for @consultingAnalyzing.
  ///
  /// In ko, this message translates to:
  /// **'데이터 분석 중...'**
  String get consultingAnalyzing;

  /// No description provided for @consultingTitle.
  ///
  /// In ko, this message translates to:
  /// **'비자 진단'**
  String get consultingTitle;

  /// No description provided for @commonSelectComplete.
  ///
  /// In ko, this message translates to:
  /// **'선택 완료'**
  String get commonSelectComplete;

  /// No description provided for @consultingQuestionStep1.
  ///
  /// In ko, this message translates to:
  /// **'현재 비자 상태는?'**
  String get consultingQuestionStep1;

  /// No description provided for @consultingQuestionStep2.
  ///
  /// In ko, this message translates to:
  /// **'최종 학력은?'**
  String get consultingQuestionStep2;

  /// No description provided for @consultingQuestionStep3.
  ///
  /// In ko, this message translates to:
  /// **'한국어 능력은?'**
  String get consultingQuestionStep3;

  /// No description provided for @consultingQuestionStep4.
  ///
  /// In ko, this message translates to:
  /// **'연 소득 수준은?'**
  String get consultingQuestionStep4;

  /// No description provided for @consultingQuestionStep5.
  ///
  /// In ko, this message translates to:
  /// **'희망 직무는?'**
  String get consultingQuestionStep5;

  /// No description provided for @koreanLevelBasic.
  ///
  /// In ko, this message translates to:
  /// **'기초'**
  String get koreanLevelBasic;

  /// No description provided for @koreanLevelDaily.
  ///
  /// In ko, this message translates to:
  /// **'일상회화'**
  String get koreanLevelDaily;

  /// No description provided for @koreanLevelBusiness.
  ///
  /// In ko, this message translates to:
  /// **'비즈니스'**
  String get koreanLevelBusiness;

  /// No description provided for @koreanLevelNative.
  ///
  /// In ko, this message translates to:
  /// **'원어민 수준'**
  String get koreanLevelNative;

  /// No description provided for @conceptRow4Title.
  ///
  /// In ko, this message translates to:
  /// **'영주권'**
  String get conceptRow4Title;

  /// No description provided for @conceptRow4Bad.
  ///
  /// In ko, this message translates to:
  /// **'5년 거주 필요'**
  String get conceptRow4Bad;

  /// No description provided for @conceptRow4Good.
  ///
  /// In ko, this message translates to:
  /// **'3년 후 신청 가능'**
  String get conceptRow4Good;

  /// No description provided for @itemCategoryAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get itemCategoryAll;

  /// No description provided for @communityActivityTitle.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티 활동'**
  String get communityActivityTitle;

  /// No description provided for @communityActivityMyPosts.
  ///
  /// In ko, this message translates to:
  /// **'내가 쓴 글'**
  String get communityActivityMyPosts;

  /// No description provided for @communityActivitySettings.
  ///
  /// In ko, this message translates to:
  /// **'활동 설정'**
  String get communityActivitySettings;

  /// No description provided for @communityActivityEmptyPosts.
  ///
  /// In ko, this message translates to:
  /// **'작성한 글이 없습니다.'**
  String get communityActivityEmptyPosts;

  /// No description provided for @communityActivityInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'활동 정보'**
  String get communityActivityInfoTitle;

  /// No description provided for @communityActivityInfoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'내 활동 요약'**
  String get communityActivityInfoSubtitle;

  /// No description provided for @communityActivityNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get communityActivityNickname;

  /// No description provided for @communityActivityNicknameDesc.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티용 닉네임'**
  String get communityActivityNicknameDesc;

  /// No description provided for @communityActivityFlag.
  ///
  /// In ko, this message translates to:
  /// **'국기 표시'**
  String get communityActivityFlag;

  /// No description provided for @communityActivityFlagDesc.
  ///
  /// In ko, this message translates to:
  /// **'국적 아이콘 노출'**
  String get communityActivityFlagDesc;

  /// No description provided for @communityActivityGender.
  ///
  /// In ko, this message translates to:
  /// **'성별 표시'**
  String get communityActivityGender;

  /// No description provided for @communityActivityGenderDesc.
  ///
  /// In ko, this message translates to:
  /// **'성별 아이콘 노출'**
  String get communityActivityGenderDesc;

  /// No description provided for @communityActivitySchool.
  ///
  /// In ko, this message translates to:
  /// **'학교 표시'**
  String get communityActivitySchool;

  /// No description provided for @communityActivitySchoolDesc.
  ///
  /// In ko, this message translates to:
  /// **'학교명 노출'**
  String get communityActivitySchoolDesc;

  /// No description provided for @boardSecret.
  ///
  /// In ko, this message translates to:
  /// **'비밀게시판'**
  String get boardSecret;

  /// No description provided for @filterSell.
  ///
  /// In ko, this message translates to:
  /// **'팝니다'**
  String get filterSell;

  /// No description provided for @filterShare.
  ///
  /// In ko, this message translates to:
  /// **'나눔'**
  String get filterShare;

  /// No description provided for @filterRequest.
  ///
  /// In ko, this message translates to:
  /// **'구해요'**
  String get filterRequest;

  /// No description provided for @filterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get filterAll;

  /// No description provided for @filterChat.
  ///
  /// In ko, this message translates to:
  /// **'잡담'**
  String get filterChat;

  /// No description provided for @filterReview.
  ///
  /// In ko, this message translates to:
  /// **'후기'**
  String get filterReview;

  /// No description provided for @filterTips.
  ///
  /// In ko, this message translates to:
  /// **'팁'**
  String get filterTips;

  /// No description provided for @filterVisa.
  ///
  /// In ko, this message translates to:
  /// **'비자'**
  String get filterVisa;

  /// No description provided for @filterLife.
  ///
  /// In ko, this message translates to:
  /// **'생활'**
  String get filterLife;

  /// No description provided for @filterFood.
  ///
  /// In ko, this message translates to:
  /// **'맛집'**
  String get filterFood;

  /// No description provided for @filterQuestion.
  ///
  /// In ko, this message translates to:
  /// **'질문'**
  String get filterQuestion;

  /// No description provided for @msgTitleContentRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목과 내용을 입력해주세요.'**
  String get msgTitleContentRequired;

  /// No description provided for @modeNormal.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get modeNormal;

  /// No description provided for @modeCardNews.
  ///
  /// In ko, this message translates to:
  /// **'카드뉴스'**
  String get modeCardNews;

  /// No description provided for @labelAddCardNewsPhoto.
  ///
  /// In ko, this message translates to:
  /// **'카드뉴스 표지 추가'**
  String get labelAddCardNewsPhoto;

  /// No description provided for @labelBetPoints.
  ///
  /// In ko, this message translates to:
  /// **'포인트 걸기'**
  String get labelBetPoints;

  /// No description provided for @labelMyPoints.
  ///
  /// In ko, this message translates to:
  /// **'보유 포인트'**
  String get labelMyPoints;

  /// No description provided for @labelNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get labelNone;

  /// No description provided for @msgNotEnoughPoints.
  ///
  /// In ko, this message translates to:
  /// **'포인트가 부족합니다.'**
  String get msgNotEnoughPoints;

  /// No description provided for @hintPrice.
  ///
  /// In ko, this message translates to:
  /// **'가격 (원)'**
  String get hintPrice;

  /// No description provided for @hintContentCardNews.
  ///
  /// In ko, this message translates to:
  /// **'카드뉴스 설명을 입력하세요.'**
  String get hintContentCardNews;

  /// No description provided for @hintContentMarket.
  ///
  /// In ko, this message translates to:
  /// **'물품 상태, 거래 장소 등을 입력하세요.'**
  String get hintContentMarket;

  /// No description provided for @hintContentInfo.
  ///
  /// In ko, this message translates to:
  /// **'유용한 정보를 공유해주세요.'**
  String get hintContentInfo;

  /// No description provided for @hintContentDefault.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력하세요.'**
  String get hintContentDefault;

  /// No description provided for @msgNoQuestions.
  ///
  /// In ko, this message translates to:
  /// **'등록된 질문이 없습니다.'**
  String get msgNoQuestions;

  /// No description provided for @bannerPopularDesc.
  ///
  /// In ko, this message translates to:
  /// **'실시간 인기 게시글'**
  String get bannerPopularDesc;

  /// No description provided for @menuVisa.
  ///
  /// In ko, this message translates to:
  /// **'비자'**
  String get menuVisa;

  /// No description provided for @menuCommunity.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티'**
  String get menuCommunity;

  /// No description provided for @menuWallet.
  ///
  /// In ko, this message translates to:
  /// **'지갑'**
  String get menuWallet;

  /// No description provided for @adSponsored.
  ///
  /// In ko, this message translates to:
  /// **'Sponsored'**
  String get adSponsored;

  /// No description provided for @adDescriptionDefault.
  ///
  /// In ko, this message translates to:
  /// **'추천 광고'**
  String get adDescriptionDefault;

  /// No description provided for @btnCheckNow.
  ///
  /// In ko, this message translates to:
  /// **'확인하기'**
  String get btnCheckNow;

  /// No description provided for @msgLoginRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다.'**
  String get msgLoginRequired;

  /// No description provided for @titlePrivacySettings.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 설정'**
  String get titlePrivacySettings;

  /// No description provided for @descPrivacySettings.
  ///
  /// In ko, this message translates to:
  /// **'공개 범위를 설정하세요.'**
  String get descPrivacySettings;

  /// No description provided for @lblRevealNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임 공개'**
  String get lblRevealNickname;

  /// No description provided for @descRevealNickname.
  ///
  /// In ko, this message translates to:
  /// **'다른 사용자에게 닉네임을 공개합니다.'**
  String get descRevealNickname;

  /// No description provided for @lblRevealNationality.
  ///
  /// In ko, this message translates to:
  /// **'국적 공개'**
  String get lblRevealNationality;

  /// No description provided for @descRevealNationality.
  ///
  /// In ko, this message translates to:
  /// **'프로필에 국적을 표시합니다.'**
  String get descRevealNationality;

  /// No description provided for @lblRevealGender.
  ///
  /// In ko, this message translates to:
  /// **'성별 공개'**
  String get lblRevealGender;

  /// No description provided for @descRevealGender.
  ///
  /// In ko, this message translates to:
  /// **'프로필에 성별을 표시합니다.'**
  String get descRevealGender;

  /// No description provided for @lblRevealSchool.
  ///
  /// In ko, this message translates to:
  /// **'학교 공개'**
  String get lblRevealSchool;

  /// No description provided for @descRevealSchool.
  ///
  /// In ko, this message translates to:
  /// **'프로필에 학교명을 표시합니다.'**
  String get descRevealSchool;

  /// No description provided for @btnComplete.
  ///
  /// In ko, this message translates to:
  /// **'설정 완료'**
  String get btnComplete;

  /// No description provided for @insightPercentile.
  ///
  /// In ko, this message translates to:
  /// **'상위 {percent}%'**
  String insightPercentile(Object percent);

  /// No description provided for @jobFilterActive.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 선택'**
  String jobFilterActive(Object count);

  /// No description provided for @profileEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필 수정'**
  String get profileEditTitle;

  /// No description provided for @actionSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get actionSave;

  /// No description provided for @labelNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get labelNickname;

  /// No description provided for @labelSchool.
  ///
  /// In ko, this message translates to:
  /// **'학교'**
  String get labelSchool;

  /// No description provided for @roadmapSchoolTitle.
  ///
  /// In ko, this message translates to:
  /// **'학교 생활형 로드맵'**
  String get roadmapSchoolTitle;

  /// No description provided for @roadmapJobTitle.
  ///
  /// In ko, this message translates to:
  /// **'취업형 (E-7)'**
  String get roadmapJobTitle;

  /// No description provided for @roadmapGlobalTitle.
  ///
  /// In ko, this message translates to:
  /// **'글로벌형 (해외진출)'**
  String get roadmapGlobalTitle;

  /// No description provided for @roadmapStartupTitle.
  ///
  /// In ko, this message translates to:
  /// **'창업형 (D-8-4)'**
  String get roadmapStartupTitle;

  /// No description provided for @actionChangeClass.
  ///
  /// In ko, this message translates to:
  /// **'Class 변경'**
  String get actionChangeClass;

  /// No description provided for @stepSmartSchoolLife.
  ///
  /// In ko, this message translates to:
  /// **'슬기로운 학교생활'**
  String get stepSmartSchoolLife;

  /// No description provided for @descSmartSchoolLife.
  ///
  /// In ko, this message translates to:
  /// **'아직 정해진 건 없어요. 무엇이든 될 수 있습니다!'**
  String get descSmartSchoolLife;

  /// No description provided for @stepAdmission.
  ///
  /// In ko, this message translates to:
  /// **'입학'**
  String get stepAdmission;

  /// No description provided for @stepCampusLife.
  ///
  /// In ko, this message translates to:
  /// **'학교생활'**
  String get stepCampusLife;

  /// No description provided for @stepCareerChoice.
  ///
  /// In ko, this message translates to:
  /// **'진로선택'**
  String get stepCareerChoice;

  /// No description provided for @secVisaMandatory.
  ///
  /// In ko, this message translates to:
  /// **'비자 잃지 않으려면 (필수)'**
  String get secVisaMandatory;

  /// No description provided for @warnNoPermit.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 허가 없이 알바 절대 금지 (강제 출국 대상)'**
  String get warnNoPermit;

  /// No description provided for @warnAttendance.
  ///
  /// In ko, this message translates to:
  /// **'출석률 70% 미만 시 비자 연장 불가'**
  String get warnAttendance;

  /// No description provided for @warnGpa.
  ///
  /// In ko, this message translates to:
  /// **'학점 2.0 이상 유지 (권장)'**
  String get warnGpa;

  /// No description provided for @secKoreanValue.
  ///
  /// In ko, this message translates to:
  /// **'한국어 실력 = 나의 몸값'**
  String get secKoreanValue;

  /// No description provided for @descKoreanValue.
  ///
  /// In ko, this message translates to:
  /// **'한국어는 단순한 언어가 아닙니다. 한국에서의 \'기회\'와 \'수입\'을 결정하는 가장 강력한 무기입니다.'**
  String get descKoreanValue;

  /// No description provided for @tagWage.
  ///
  /// In ko, this message translates to:
  /// **'시급 상승'**
  String get tagWage;

  /// No description provided for @descWage.
  ///
  /// In ko, this message translates to:
  /// **'힘든 육체노동 NO, 카페/서비스직 가능'**
  String get descWage;

  /// No description provided for @tagNetwork.
  ///
  /// In ko, this message translates to:
  /// **'인맥'**
  String get tagNetwork;

  /// No description provided for @descNetwork.
  ///
  /// In ko, this message translates to:
  /// **'한국인 선배/친구와 교류 (꿀정보 획득)'**
  String get descNetwork;

  /// No description provided for @tagEmployment.
  ///
  /// In ko, this message translates to:
  /// **'취업'**
  String get tagEmployment;

  /// No description provided for @descEmployment.
  ///
  /// In ko, this message translates to:
  /// **'E-7 전문직 면접은 한국어 실력이 1순위'**
  String get descEmployment;

  /// No description provided for @stepPracticeJob.
  ///
  /// In ko, this message translates to:
  /// **'실전 취업 (E-7)'**
  String get stepPracticeJob;

  /// No description provided for @secJobCodes.
  ///
  /// In ko, this message translates to:
  /// **'E-7 비자 직종 코드'**
  String get secJobCodes;

  /// No description provided for @descJobCodes.
  ///
  /// In ko, this message translates to:
  /// **'내 전공에 맞는 코드를 찾아보세요.'**
  String get descJobCodes;

  /// No description provided for @codeProfessional.
  ///
  /// In ko, this message translates to:
  /// **'E-7-1 (전문직 - 관리/전문가)'**
  String get codeProfessional;

  /// No description provided for @codeSemiPro.
  ///
  /// In ko, this message translates to:
  /// **'E-7-2 (준전문 - 사무/서비스)'**
  String get codeSemiPro;

  /// No description provided for @codeSkilled.
  ///
  /// In ko, this message translates to:
  /// **'E-7-3 (일반기능 - 숙련직)'**
  String get codeSkilled;

  /// No description provided for @stepGlobalCareer.
  ///
  /// In ko, this message translates to:
  /// **'글로벌 커리어'**
  String get stepGlobalCareer;

  /// No description provided for @secApostille.
  ///
  /// In ko, this message translates to:
  /// **'졸업장 인증(Apostille) 필수!'**
  String get secApostille;

  /// No description provided for @descApostille.
  ///
  /// In ko, this message translates to:
  /// **'본국에서 한국 학위를 인정받으려면 귀국 전 아포스티유(Apostille)나 영사 확인이 반드시 필요합니다.'**
  String get descApostille;

  /// No description provided for @warnApostille.
  ///
  /// In ko, this message translates to:
  /// **'귀국 후에는 처리가 매우 복잡하니, 반드시 한국에서 완료하세요.'**
  String get warnApostille;

  /// No description provided for @secOverseasBranch.
  ///
  /// In ko, this message translates to:
  /// **'한국 기업 해외 법인 공략'**
  String get secOverseasBranch;

  /// No description provided for @descOverseasBranch.
  ///
  /// In ko, this message translates to:
  /// **'여러분의 가장 큰 무기는 \'한국어 능력\'과 \'현지 문화 이해도\'입니다.'**
  String get descOverseasBranch;

  /// No description provided for @tagSales.
  ///
  /// In ko, this message translates to:
  /// **'#해외영업'**
  String get tagSales;

  /// No description provided for @tagTrans.
  ///
  /// In ko, this message translates to:
  /// **'#통번역'**
  String get tagTrans;

  /// No description provided for @tagManager.
  ///
  /// In ko, this message translates to:
  /// **'#현지관리자'**
  String get tagManager;

  /// No description provided for @tagAssistant.
  ///
  /// In ko, this message translates to:
  /// **'#주재원보조'**
  String get tagAssistant;

  /// No description provided for @stepTechStartup.
  ///
  /// In ko, this message translates to:
  /// **'기술 창업'**
  String get stepTechStartup;

  /// No description provided for @secD84Req.
  ///
  /// In ko, this message translates to:
  /// **'D-8-4 발급 최소 요건'**
  String get secD84Req;

  /// No description provided for @reqDegree.
  ///
  /// In ko, this message translates to:
  /// **'학사 학위 이상 (국내/외)'**
  String get reqDegree;

  /// No description provided for @reqOasis.
  ///
  /// In ko, this message translates to:
  /// **'OASIS 점수 80점 이상 (필수)'**
  String get reqOasis;

  /// No description provided for @reqCorp.
  ///
  /// In ko, this message translates to:
  /// **'한국 법인 설립 완료'**
  String get reqCorp;

  /// No description provided for @secWhatIsOasis.
  ///
  /// In ko, this message translates to:
  /// **'OASIS가 무엇인가요?'**
  String get secWhatIsOasis;

  /// No description provided for @descOasis.
  ///
  /// In ko, this message translates to:
  /// **'창업이민 종합지원시스템. D-8-4 비자를 받기 위해 80점을 적립하는 필수 교육입니다.'**
  String get descOasis;

  /// No description provided for @secOasisCenters.
  ///
  /// In ko, this message translates to:
  /// **'전국 OASIS 교육 센터'**
  String get secOasisCenters;

  /// No description provided for @centerSeoul.
  ///
  /// In ko, this message translates to:
  /// **'서울'**
  String get centerSeoul;

  /// No description provided for @centerSeoulDesc.
  ///
  /// In ko, this message translates to:
  /// **'서울글로벌센터(종로), 서울창업허브'**
  String get centerSeoulDesc;

  /// No description provided for @centerBusan.
  ///
  /// In ko, this message translates to:
  /// **'부산'**
  String get centerBusan;

  /// No description provided for @centerBusanDesc.
  ///
  /// In ko, this message translates to:
  /// **'부산역 유라시아 플랫폼'**
  String get centerBusanDesc;

  /// No description provided for @msgProfileSaved.
  ///
  /// In ko, this message translates to:
  /// **'프로필이 저장되었습니다.'**
  String get msgProfileSaved;

  /// No description provided for @hintName.
  ///
  /// In ko, this message translates to:
  /// **'User Name'**
  String get hintName;

  /// No description provided for @hintSchool.
  ///
  /// In ko, this message translates to:
  /// **'University Name'**
  String get hintSchool;

  /// No description provided for @secStrategicPrep.
  ///
  /// In ko, this message translates to:
  /// **'전략적 준비 (TOPIK vs KIIP)'**
  String get secStrategicPrep;

  /// No description provided for @tagTest.
  ///
  /// In ko, this message translates to:
  /// **'📝 시험 (Test)'**
  String get tagTest;

  /// No description provided for @lblPurpose.
  ///
  /// In ko, this message translates to:
  /// **'목적'**
  String get lblPurpose;

  /// No description provided for @valScholarshipGrad.
  ///
  /// In ko, this message translates to:
  /// **'장학금 / 입학\n졸업 요건'**
  String get valScholarshipGrad;

  /// No description provided for @lblValidity.
  ///
  /// In ko, this message translates to:
  /// **'유효기간'**
  String get lblValidity;

  /// No description provided for @valValidityTwoYears.
  ///
  /// In ko, this message translates to:
  /// **'2년 (갱신 필수)'**
  String get valValidityTwoYears;

  /// No description provided for @tagEducationCurriculum.
  ///
  /// In ko, this message translates to:
  /// **'🏫 교육과정'**
  String get tagEducationCurriculum;

  /// No description provided for @valVisaPermanent.
  ///
  /// In ko, this message translates to:
  /// **'비자(F-2)\n영주권(F-5)'**
  String get valVisaPermanent;

  /// No description provided for @valValidityForever.
  ///
  /// In ko, this message translates to:
  /// **'무제한 (평생)'**
  String get valValidityForever;

  /// No description provided for @descTopikVsKiip.
  ///
  /// In ko, this message translates to:
  /// **'TOPIK은 점수만 보지만, KIIP는 교육 이수(출석)가 필수입니다.'**
  String get descTopikVsKiip;

  /// No description provided for @warnKiipLevel5.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 5단계 주의: 0~4단계는 종합평가 불합시 재수강으로 승급되지만, 마지막 5단계는 \'종합평가\' 합격을 해야 합니다.'**
  String get warnKiipLevel5;

  /// No description provided for @titleTipGraduation.
  ///
  /// In ko, this message translates to:
  /// **'졸업 요건 대체 가능?'**
  String get titleTipGraduation;

  /// No description provided for @descTipGraduation.
  ///
  /// In ko, this message translates to:
  /// **'최근 많은 대학이 KIIP 이수증으로 졸업 논문/TOPIK을 대체해 줍니다.\n학교 행정실에 확인해 보세요. [졸업 + 비자 + 영주권]을 한 번에 해결할 수 있습니다!'**
  String get descTipGraduation;

  /// No description provided for @titleFuturePath.
  ///
  /// In ko, this message translates to:
  /// **'졸업 후, 어떤 길로 갈까요?'**
  String get titleFuturePath;

  /// No description provided for @subtitleE7.
  ///
  /// In ko, this message translates to:
  /// **'전문직 취업 비자'**
  String get subtitleE7;

  /// No description provided for @descE7.
  ///
  /// In ko, this message translates to:
  /// **'법무부 장관이 지정한 87개 직종에서 근무할 수 있습니다.\n단순히 전공만 맞추는 것이 아니라, **나의 \'전문성\'과 회사가 유학생을 채용해야 하는 \'필요성\'을 입증**해야 합니다.\n(전공-직무 연관 시 유리)'**
  String get descE7;

  /// No description provided for @subtitleF2.
  ///
  /// In ko, this message translates to:
  /// **'점수제 거주 비자 (석사대상)'**
  String get subtitleF2;

  /// No description provided for @descF2.
  ///
  /// In ko, this message translates to:
  /// **'나이, 학력, 소득을 점수로 환산하는 비자입니다.\n**유학전형의 경우 석사학위 이상을 대상으로 하며, 이공계가 점수 확보에 유리합니다.** 취업처 변경이 자유로운 **\'준영주권\'**입니다.'**
  String get descF2;

  /// No description provided for @subtitleStartup.
  ///
  /// In ko, this message translates to:
  /// **'기술 창업 비자 (OASIS 필수)'**
  String get subtitleStartup;

  /// No description provided for @descStartup.
  ///
  /// In ko, this message translates to:
  /// **'특허나 독자적인 기술을 바탕으로 한국에서 벤처 기업을 설립하는 비자입니다. 단순히 자본금만 투자하는 것이 아니라 \'기술력\'을 입증해야 합니다.\n\n**일반적인 구직(D-10)이나 취업(E-7) 비자와는 준비 과정이 완전히 다릅니다.\n**단순 스펙보다는 **OASIS 프로그램 이수**와 **지식재산권(특허) 확보**가 비자 발급의 핵심 열쇠입니다.'**
  String get descStartup;

  /// No description provided for @subtitleGlobal.
  ///
  /// In ko, this message translates to:
  /// **'Global Career'**
  String get subtitleGlobal;

  /// No description provided for @descGlobal.
  ///
  /// In ko, this message translates to:
  /// **'한국에 남지 않고, 한국 학위와 언어 능력을 스펙으로 삼아 본국이나 제3국 기업의 핵심 인재로 진출하는 커리어 로드맵입니다.'**
  String get descGlobal;

  /// No description provided for @descD10Guide.
  ///
  /// In ko, this message translates to:
  /// **'취업 전 수습/인턴 기간을 위한 비자'**
  String get descD10Guide;

  /// No description provided for @lblFirstApp.
  ///
  /// In ko, this message translates to:
  /// **'학사 졸업 후 최초 신청인가요?'**
  String get lblFirstApp;

  /// No description provided for @lblPointExempt.
  ///
  /// In ko, this message translates to:
  /// **'점수제 면제 대상!'**
  String get lblPointExempt;

  /// No description provided for @descPointExempt.
  ///
  /// In ko, this message translates to:
  /// **'최초 1회, 점수 없이 발급 가능'**
  String get descPointExempt;

  /// No description provided for @lblPointRequired.
  ///
  /// In ko, this message translates to:
  /// **'점수제 진단 필요'**
  String get lblPointRequired;

  /// No description provided for @descPointRequired.
  ///
  /// In ko, this message translates to:
  /// **'60점 이상 획득해야 연장 가능'**
  String get descPointRequired;

  /// No description provided for @jobManager.
  ///
  /// In ko, this message translates to:
  /// **'1110 | 기획 및 경영지원 관리자'**
  String get jobManager;

  /// No description provided for @jobITManager.
  ///
  /// In ko, this message translates to:
  /// **'1212 | 정보통신 관리자'**
  String get jobITManager;

  /// No description provided for @jobConstructionMgr.
  ///
  /// In ko, this message translates to:
  /// **'1391 | 건설 및 광업 생산 관리자'**
  String get jobConstructionMgr;

  /// No description provided for @jobProductPlanner.
  ///
  /// In ko, this message translates to:
  /// **'1511 | 상품기획 전문가'**
  String get jobProductPlanner;

  /// No description provided for @jobPerfPlanner.
  ///
  /// In ko, this message translates to:
  /// **'1522 | 공연기획자'**
  String get jobPerfPlanner;

  /// No description provided for @jobTranslator.
  ///
  /// In ko, this message translates to:
  /// **'1630 | 통번역가'**
  String get jobTranslator;

  /// No description provided for @jobBioExpert.
  ///
  /// In ko, this message translates to:
  /// **'2111 | 생명과학 전문가'**
  String get jobBioExpert;

  /// No description provided for @jobScienceExpert.
  ///
  /// In ko, this message translates to:
  /// **'2112 | 자연과학 전문가'**
  String get jobScienceExpert;

  /// No description provided for @jobChemEng.
  ///
  /// In ko, this message translates to:
  /// **'2311 | 화학공학 기술자'**
  String get jobChemEng;

  /// No description provided for @jobMetalEng.
  ///
  /// In ko, this message translates to:
  /// **'2321 | 금속/재료 공학 기술자'**
  String get jobMetalEng;

  /// No description provided for @jobMechEng.
  ///
  /// In ko, this message translates to:
  /// **'2351 | 기계공학 기술자'**
  String get jobMechEng;

  /// No description provided for @jobPlantEng.
  ///
  /// In ko, this message translates to:
  /// **'2353 | 플랜트공학 기술자'**
  String get jobPlantEng;

  /// No description provided for @jobRobotExpert.
  ///
  /// In ko, this message translates to:
  /// **'2392 | 로봇공학 전문가'**
  String get jobRobotExpert;

  /// No description provided for @jobHwEng.
  ///
  /// In ko, this message translates to:
  /// **'2511 | 컴퓨터 하드웨어 기술자'**
  String get jobHwEng;

  /// No description provided for @jobTelecomEng.
  ///
  /// In ko, this message translates to:
  /// **'2521 | 통신공학 기술자'**
  String get jobTelecomEng;

  /// No description provided for @jobSystemAnalyst.
  ///
  /// In ko, this message translates to:
  /// **'2530 | 컴퓨터 시스템 설계 및 분석가'**
  String get jobSystemAnalyst;

  /// No description provided for @jobSwDev.
  ///
  /// In ko, this message translates to:
  /// **'2531 | 시스템 S/W 개발자'**
  String get jobSwDev;

  /// No description provided for @jobAppDev.
  ///
  /// In ko, this message translates to:
  /// **'2532 | 응용 S/W 개발자'**
  String get jobAppDev;

  /// No description provided for @jobWebDev.
  ///
  /// In ko, this message translates to:
  /// **'2533 | 웹 개발자'**
  String get jobWebDev;

  /// No description provided for @jobDataExpert.
  ///
  /// In ko, this message translates to:
  /// **'2592 | 데이터 전문가'**
  String get jobDataExpert;

  /// No description provided for @jobNetworkDev.
  ///
  /// In ko, this message translates to:
  /// **'2593 | 네트워크 시스템 개발자'**
  String get jobNetworkDev;

  /// No description provided for @jobSecExpert.
  ///
  /// In ko, this message translates to:
  /// **'2594 | 정보보안 전문가'**
  String get jobSecExpert;

  /// No description provided for @jobDesigner.
  ///
  /// In ko, this message translates to:
  /// **'2721 | 디자이너'**
  String get jobDesigner;

  /// No description provided for @jobVideoDesigner.
  ///
  /// In ko, this message translates to:
  /// **'2733 | 영상 관련 디자이너'**
  String get jobVideoDesigner;

  /// No description provided for @jobArtPlanner.
  ///
  /// In ko, this message translates to:
  /// **'2741 | 문화예술 기획자'**
  String get jobArtPlanner;

  /// No description provided for @jobDutyFree.
  ///
  /// In ko, this message translates to:
  /// **'3121 | 면세점/제주영어도시 판매'**
  String get jobDutyFree;

  /// No description provided for @jobCounselor.
  ///
  /// In ko, this message translates to:
  /// **'3126 | 고객상담 사무원'**
  String get jobCounselor;

  /// No description provided for @jobAirTransport.
  ///
  /// In ko, this message translates to:
  /// **'3910 | 항공 운송 사무원'**
  String get jobAirTransport;

  /// No description provided for @jobTourGuide.
  ///
  /// In ko, this message translates to:
  /// **'3922 | 관광 통역 안내원'**
  String get jobTourGuide;

  /// No description provided for @jobHotelReception.
  ///
  /// In ko, this message translates to:
  /// **'3991 | 호텔 접수 사무원'**
  String get jobHotelReception;

  /// No description provided for @jobMedicalCoord.
  ///
  /// In ko, this message translates to:
  /// **'4320 | 의료 코디네이터'**
  String get jobMedicalCoord;

  /// No description provided for @jobChef.
  ///
  /// In ko, this message translates to:
  /// **'4410 | 주방장 및 조리사'**
  String get jobChef;

  /// No description provided for @jobZookeeper.
  ///
  /// In ko, this message translates to:
  /// **'6139 | 동물 사육사'**
  String get jobZookeeper;

  /// No description provided for @jobAquaTech.
  ///
  /// In ko, this message translates to:
  /// **'6310 | 양식 기술자'**
  String get jobAquaTech;

  /// No description provided for @jobHalalButcher.
  ///
  /// In ko, this message translates to:
  /// **'7103 | 할랄 도축원'**
  String get jobHalalButcher;

  /// No description provided for @jobInstrumentMaker.
  ///
  /// In ko, this message translates to:
  /// **'7303 | 악기 제조 및 조율사'**
  String get jobInstrumentMaker;

  /// No description provided for @jobShipWelder.
  ///
  /// In ko, this message translates to:
  /// **'7430 | 조선 용접공'**
  String get jobShipWelder;

  /// No description provided for @jobAircraftMech.
  ///
  /// In ko, this message translates to:
  /// **'7521 | 항공기 정비원'**
  String get jobAircraftMech;

  /// No description provided for @jobShipElectrician.
  ///
  /// In ko, this message translates to:
  /// **'7621 | 선박 전기원'**
  String get jobShipElectrician;

  /// No description provided for @jobShipPainter.
  ///
  /// In ko, this message translates to:
  /// **'7836 | 선박 도장공'**
  String get jobShipPainter;

  /// No description provided for @checkArcReturn.
  ///
  /// In ko, this message translates to:
  /// **'외국인등록증 반납 (출국 시 공항)'**
  String get checkArcReturn;

  /// No description provided for @checkTaxSettlement.
  ///
  /// In ko, this message translates to:
  /// **'4대 보험 및 세금 정산 (과태료 방지)'**
  String get checkTaxSettlement;

  /// No description provided for @checkPhoneInternet.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 및 인터넷 해지'**
  String get checkPhoneInternet;

  /// No description provided for @checkDepositReturn.
  ///
  /// In ko, this message translates to:
  /// **'월세 보증금 반환 확인'**
  String get checkDepositReturn;

  /// No description provided for @oasis1.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-1: 지식재산권'**
  String get oasis1;

  /// No description provided for @oasis1Desc.
  ///
  /// In ko, this message translates to:
  /// **'초급 (15포인트)'**
  String get oasis1Desc;

  /// No description provided for @oasis2.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-2: 창업소양'**
  String get oasis2;

  /// No description provided for @oasis2Desc.
  ///
  /// In ko, this message translates to:
  /// **'초급 (15포인트)'**
  String get oasis2Desc;

  /// No description provided for @oasis4.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-4: 창업코칭'**
  String get oasis4;

  /// No description provided for @oasis4Desc.
  ///
  /// In ko, this message translates to:
  /// **'중급 (15포인트)'**
  String get oasis4Desc;

  /// No description provided for @oasis5.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-5: 창업실습'**
  String get oasis5;

  /// No description provided for @oasis5Desc.
  ///
  /// In ko, this message translates to:
  /// **'중급 (15포인트)'**
  String get oasis5Desc;

  /// No description provided for @oasis6.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-6: 시제품제작'**
  String get oasis6;

  /// No description provided for @oasis6Desc.
  ///
  /// In ko, this message translates to:
  /// **'고급 (25포인트) - 핵심'**
  String get oasis6Desc;

  /// No description provided for @oasis9.
  ///
  /// In ko, this message translates to:
  /// **'OASIS-9: 사업화지원'**
  String get oasis9;

  /// No description provided for @oasis9Desc.
  ///
  /// In ko, this message translates to:
  /// **'고급 (25포인트) - 핵심'**
  String get oasis9Desc;

  /// No description provided for @centerIncheon.
  ///
  /// In ko, this message translates to:
  /// **'인천 글로벌 센터'**
  String get centerIncheon;

  /// No description provided for @centerIncheonDesc.
  ///
  /// In ko, this message translates to:
  /// **'인천 글로벌 스타트업 캠퍼스'**
  String get centerIncheonDesc;

  /// No description provided for @centerDaejeon.
  ///
  /// In ko, this message translates to:
  /// **'대전 KAIST 센터'**
  String get centerDaejeon;

  /// No description provided for @centerDaejeonDesc.
  ///
  /// In ko, this message translates to:
  /// **'KAIST 창업보육센터, 대전창업허브'**
  String get centerDaejeonDesc;

  /// No description provided for @titleD102.
  ///
  /// In ko, this message translates to:
  /// **'창업준비 비자(D-10-2)가 뭔가요?'**
  String get titleD102;

  /// No description provided for @descD102.
  ///
  /// In ko, this message translates to:
  /// **'D-10-2는 최대 2년까지 체류 가능한 \'준비 비자\'이며, 법인 설립 후 D-8-4로 변경해야 합니다.'**
  String get descD102;

  /// No description provided for @permitLandingTitle.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 허가\n준비하기'**
  String get permitLandingTitle;

  /// No description provided for @permitLandingSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'어떤 방식으로 알바를 구하셨나요?\n쿠티가 서류 준비를 도와드릴게요!'**
  String get permitLandingSubtitle;

  /// No description provided for @btnGoToApply.
  ///
  /// In ko, this message translates to:
  /// **'신청하러 가기'**
  String get btnGoToApply;

  /// No description provided for @permitLinkTitle.
  ///
  /// In ko, this message translates to:
  /// **'안전한 서류 준비를 위해\n비자 정보를 연동해주세요.'**
  String get permitLinkTitle;

  /// No description provided for @labelAgreeLink.
  ///
  /// In ko, this message translates to:
  /// **'MY에 저장된 비자지갑 데이터를\n안전하게 불러오는 것에 동의합니다.'**
  String get labelAgreeLink;

  /// No description provided for @btnLinkSafe.
  ///
  /// In ko, this message translates to:
  /// **'비자지갑 안전하게 연동하기'**
  String get btnLinkSafe;

  /// No description provided for @btnLinking.
  ///
  /// In ko, this message translates to:
  /// **'연동 중...'**
  String get btnLinking;

  /// No description provided for @msgSecurityFooter.
  ///
  /// In ko, this message translates to:
  /// **'CUTY는 고객님의 개인정보를 안전하게 보호합니다.'**
  String get msgSecurityFooter;

  /// No description provided for @permitChecklistTitle.
  ///
  /// In ko, this message translates to:
  /// **'필수 서류 확인'**
  String get permitChecklistTitle;

  /// No description provided for @permitChecklistDesc.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 허가를 위해 필수 서류를 확인합니다.\n스펙 지갑 정보를 자동으로 불러왔어요.'**
  String get permitChecklistDesc;

  /// No description provided for @statusVerified.
  ///
  /// In ko, this message translates to:
  /// **'인증 완료'**
  String get statusVerified;

  /// No description provided for @statusNotRegistered.
  ///
  /// In ko, this message translates to:
  /// **'미등록'**
  String get statusNotRegistered;

  /// No description provided for @btnFillDocuments.
  ///
  /// In ko, this message translates to:
  /// **'부족한 서류 채우러 가기'**
  String get btnFillDocuments;

  /// No description provided for @btnPrepareLater.
  ///
  /// In ko, this message translates to:
  /// **'서류 준비가 필요해요'**
  String get btnPrepareLater;

  /// No description provided for @linkSkipToEmployer.
  ///
  /// In ko, this message translates to:
  /// **'나중에 서류 채울게요 (사업주 먼저)'**
  String get linkSkipToEmployer;

  /// No description provided for @permitEmployerGuideTitle.
  ///
  /// In ko, this message translates to:
  /// **'사업자 서류 촬영 안내'**
  String get permitEmployerGuideTitle;

  /// No description provided for @permitEmployerGuideSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'일하게 된 곳의\n사업자 서류를 준비해주세요.'**
  String get permitEmployerGuideSubtitle;

  /// No description provided for @permitEmployerGuideDesc.
  ///
  /// In ko, this message translates to:
  /// **'사장님께 아래 3가지 서류의 촬영 동의를 구해주세요.'**
  String get permitEmployerGuideDesc;

  /// No description provided for @docBusinessReg.
  ///
  /// In ko, this message translates to:
  /// **'사업자 등록증'**
  String get docBusinessReg;

  /// No description provided for @docLaborContract.
  ///
  /// In ko, this message translates to:
  /// **'근로계약서'**
  String get docLaborContract;

  /// No description provided for @docEmployerId.
  ///
  /// In ko, this message translates to:
  /// **'사업주 신분증 사본'**
  String get docEmployerId;

  /// No description provided for @checkConsentPhoto.
  ///
  /// In ko, this message translates to:
  /// **'(필수) 사장님께 위 서류들의 촬영 동의를 구했습니다.'**
  String get checkConsentPhoto;

  /// No description provided for @checkConsentUsage.
  ///
  /// In ko, this message translates to:
  /// **'(필수) 수집된 정보는 취업 허가 신청 목적으로만 사용됩니다.'**
  String get checkConsentUsage;

  /// No description provided for @btnConfirmAndShoot.
  ///
  /// In ko, this message translates to:
  /// **'확인했습니다. 촬영하기'**
  String get btnConfirmAndShoot;

  /// No description provided for @cameraHintBizReg.
  ///
  /// In ko, this message translates to:
  /// **'먼저, 사업자등록증을 찍어주세요.'**
  String get cameraHintBizReg;

  /// No description provided for @cameraHintContract.
  ///
  /// In ko, this message translates to:
  /// **'다음은 근로계약서입니다.'**
  String get cameraHintContract;

  /// No description provided for @cameraHintId.
  ///
  /// In ko, this message translates to:
  /// **'마지막으로 사업주 신분증을 찍어주세요.'**
  String get cameraHintId;

  /// No description provided for @cameraSubHintBiz.
  ///
  /// In ko, this message translates to:
  /// **'사업자 번호가 잘 보이게 찍어주세요.'**
  String get cameraSubHintBiz;

  /// No description provided for @cameraSubHintContract.
  ///
  /// In ko, this message translates to:
  /// **'글자가 잘 보이게 찍어주세요.'**
  String get cameraSubHintContract;

  /// No description provided for @cameraSubHintId.
  ///
  /// In ko, this message translates to:
  /// **'주민등록번호 뒷자리는 가려도 됩니다.'**
  String get cameraSubHintId;

  /// No description provided for @permitInfoCheckTitle.
  ///
  /// In ko, this message translates to:
  /// **'거의 다 됐어요!\n정보를 확인해주세요.'**
  String get permitInfoCheckTitle;

  /// No description provided for @permitInfoCheckDesc.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록증 내용을 바탕으로\n자동 입력된 정보입니다.'**
  String get permitInfoCheckDesc;

  /// No description provided for @labelTradeName.
  ///
  /// In ko, this message translates to:
  /// **'상호명'**
  String get labelTradeName;

  /// No description provided for @labelBizRegNo.
  ///
  /// In ko, this message translates to:
  /// **'사업자 등록번호'**
  String get labelBizRegNo;

  /// No description provided for @labelRepName.
  ///
  /// In ko, this message translates to:
  /// **'대표자명'**
  String get labelRepName;

  /// No description provided for @labelBizAddress.
  ///
  /// In ko, this message translates to:
  /// **'사업자 주소'**
  String get labelBizAddress;

  /// No description provided for @labelHourlyWage.
  ///
  /// In ko, this message translates to:
  /// **'시급'**
  String get labelHourlyWage;

  /// No description provided for @labelWorkTime.
  ///
  /// In ko, this message translates to:
  /// **'근무 시간'**
  String get labelWorkTime;

  /// No description provided for @checkInfoCorrect.
  ///
  /// In ko, this message translates to:
  /// **'(필수) 기입된 정보가 맞아요'**
  String get checkInfoCorrect;

  /// No description provided for @btnInfoCorrectNext.
  ///
  /// In ko, this message translates to:
  /// **'정보가 맞아요 (다음)'**
  String get btnInfoCorrectNext;

  /// No description provided for @permitSchoolApprovedTitle.
  ///
  /// In ko, this message translates to:
  /// **'와우!\n학교 승인이 완료되었어요! 🎉'**
  String get permitSchoolApprovedTitle;

  /// No description provided for @badgeSchoolApproved.
  ///
  /// In ko, this message translates to:
  /// **'학교 승인 완료'**
  String get badgeSchoolApproved;

  /// No description provided for @lblPartTimeConfirmDoc.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 확인서'**
  String get lblPartTimeConfirmDoc;

  /// No description provided for @btnCheckIntegratedDocs.
  ///
  /// In ko, this message translates to:
  /// **'통합 서류 확인하러 가기'**
  String get btnCheckIntegratedDocs;

  /// No description provided for @permitFinalDocTitle.
  ///
  /// In ko, this message translates to:
  /// **'최종 서류 통합'**
  String get permitFinalDocTitle;

  /// No description provided for @permitFinalDocSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'따로따로 준비할 필요 없이\n하나의 PDF로 묶었어요'**
  String get permitFinalDocSubtitle;

  /// No description provided for @badgeFinalDocCompleted.
  ///
  /// In ko, this message translates to:
  /// **'11종 서류 통합 완료'**
  String get badgeFinalDocCompleted;

  /// No description provided for @labelFinalPdf.
  ///
  /// In ko, this message translates to:
  /// **'CUTY 통합 신청 폴더'**
  String get labelFinalPdf;

  /// No description provided for @lblIncludedDocs.
  ///
  /// In ko, this message translates to:
  /// **'포함된 서류 목록'**
  String get lblIncludedDocs;

  /// No description provided for @docPartTimeConfirm.
  ///
  /// In ko, this message translates to:
  /// **'외국인 유학생 시간제 취업 확인서'**
  String get docPartTimeConfirm;

  /// No description provided for @docStdContract.
  ///
  /// In ko, this message translates to:
  /// **'표준근로계약서'**
  String get docStdContract;

  /// No description provided for @docBizRegCopy.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록증 사본'**
  String get docBizRegCopy;

  /// No description provided for @docArcCopy.
  ///
  /// In ko, this message translates to:
  /// **'외국인등록증 (앞/뒤)'**
  String get docArcCopy;

  /// No description provided for @docPassportCopy.
  ///
  /// In ko, this message translates to:
  /// **'여권 사본'**
  String get docPassportCopy;

  /// No description provided for @docEnrollmentCert.
  ///
  /// In ko, this message translates to:
  /// **'재학증명서'**
  String get docEnrollmentCert;

  /// No description provided for @docTopikCert.
  ///
  /// In ko, this message translates to:
  /// **'TOPIK 한국어능력시험 성적표'**
  String get docTopikCert;

  /// No description provided for @docApplicationForm.
  ///
  /// In ko, this message translates to:
  /// **'통합 신청서 (신고서)'**
  String get docApplicationForm;

  /// No description provided for @docPowerOfAttorney.
  ///
  /// In ko, this message translates to:
  /// **'위임장 (신고자용)'**
  String get docPowerOfAttorney;

  /// No description provided for @docEtc.
  ///
  /// In ko, this message translates to:
  /// **'기타 구비 서류'**
  String get docEtc;

  /// No description provided for @btnDownloadPdfGuide.
  ///
  /// In ko, this message translates to:
  /// **'통합 PDF 다운로드 및 접수 가이드'**
  String get btnDownloadPdfGuide;

  /// No description provided for @btnMovingToGuide.
  ///
  /// In ko, this message translates to:
  /// **'가이드로 이동'**
  String get btnMovingToGuide;

  /// No description provided for @permitGuideTitle.
  ///
  /// In ko, this message translates to:
  /// **'신청 가이드'**
  String get permitGuideTitle;

  /// No description provided for @permitGuideSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'이제 하이코리아에서\n서류만 올리면 끝나요!'**
  String get permitGuideSubtitle;

  /// No description provided for @guideStep1.
  ///
  /// In ko, this message translates to:
  /// **'하이코리아 접속 및 로그인'**
  String get guideStep1;

  /// No description provided for @guideStep2.
  ///
  /// In ko, this message translates to:
  /// **'민원선택 > 시간제취업 허가 클릭'**
  String get guideStep2;

  /// No description provided for @guideStep3.
  ///
  /// In ko, this message translates to:
  /// **'서류 업로드 (가장 중요!)'**
  String get guideStep3;

  /// No description provided for @guideStep3Desc.
  ///
  /// In ko, this message translates to:
  /// **'방금 다운로드한 \'CUTY 통합 신청 패키지.pdf\'\n하나만 올리면 끝!\n(재학/성적증명서, 신분증, 계약서 등 포함됨)'**
  String get guideStep3Desc;

  /// No description provided for @guideStep4.
  ///
  /// In ko, this message translates to:
  /// **'접수 완료 및 접수증 업로드'**
  String get guideStep4;

  /// No description provided for @btnUploadReceipt.
  ///
  /// In ko, this message translates to:
  /// **'접수증 캡쳐본 올리기'**
  String get btnUploadReceipt;

  /// No description provided for @tipSubmissionTime.
  ///
  /// In ko, this message translates to:
  /// **'접수 꿀팁\n평일 오전 9시 ~ 오후 6시 사이에 신청하면 처리가 빨라요.'**
  String get tipSubmissionTime;

  /// No description provided for @btnAppliedNext.
  ///
  /// In ko, this message translates to:
  /// **'신청 완료했어요 (다음)'**
  String get btnAppliedNext;

  /// No description provided for @permitSignTitle.
  ///
  /// In ko, this message translates to:
  /// **'전자 서명'**
  String get permitSignTitle;

  /// No description provided for @lblConfirmDocTitle.
  ///
  /// In ko, this message translates to:
  /// **'외국인유학생 시간제취업 확인서'**
  String get lblConfirmDocTitle;

  /// No description provided for @tableCompany.
  ///
  /// In ko, this message translates to:
  /// **'업체명'**
  String get tableCompany;

  /// No description provided for @tableBizNo.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록번호'**
  String get tableBizNo;

  /// No description provided for @tableAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get tableAddress;

  /// No description provided for @tableEmployer.
  ///
  /// In ko, this message translates to:
  /// **'고용주'**
  String get tableEmployer;

  /// No description provided for @tablePeriod.
  ///
  /// In ko, this message translates to:
  /// **'취업기간'**
  String get tablePeriod;

  /// No description provided for @tableWage.
  ///
  /// In ko, this message translates to:
  /// **'급여(시급)'**
  String get tableWage;

  /// No description provided for @holderSignOrSeal.
  ///
  /// In ko, this message translates to:
  /// **'(인 또는 서명)'**
  String get holderSignOrSeal;

  /// No description provided for @btnSignEmployer.
  ///
  /// In ko, this message translates to:
  /// **'사업주 서명하기'**
  String get btnSignEmployer;

  /// No description provided for @btnSignSubmit.
  ///
  /// In ko, this message translates to:
  /// **'서명 완료 및 제출하기'**
  String get btnSignSubmit;

  /// No description provided for @lblEmployerSignTitle.
  ///
  /// In ko, this message translates to:
  /// **'고용주 서명'**
  String get lblEmployerSignTitle;

  /// No description provided for @actionClear.
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get actionClear;

  /// No description provided for @actionSignComplete.
  ///
  /// In ko, this message translates to:
  /// **'서명 완료'**
  String get actionSignComplete;

  /// No description provided for @permitSubmitSuccessTitle.
  ///
  /// In ko, this message translates to:
  /// **'서류 제출 완료!\nCUTY가 확인하고 있어요.'**
  String get permitSubmitSuccessTitle;

  /// No description provided for @permitSubmitSuccessDesc.
  ///
  /// In ko, this message translates to:
  /// **'검토는 영업일 기준 1일 내에 완료됩니다.'**
  String get permitSubmitSuccessDesc;

  /// No description provided for @badgeFinalApproved.
  ///
  /// In ko, this message translates to:
  /// **'최종 허가 완료'**
  String get badgeFinalApproved;

  /// No description provided for @permitCongratsTitle.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!\n이제 바로 일할 수 있어요! 🎉'**
  String get permitCongratsTitle;

  /// No description provided for @permitCongratsDesc.
  ///
  /// In ko, this message translates to:
  /// **'성공적인 아르바이트 생활을\nCUTY가 응원합니다.'**
  String get permitCongratsDesc;

  /// No description provided for @tipWorkStartTitle.
  ///
  /// In ko, this message translates to:
  /// **'아르바이트 시작 전 꿀팁!'**
  String get tipWorkStartTitle;

  /// No description provided for @tipWorkStart1.
  ///
  /// In ko, this message translates to:
  /// **'학기 중 주당 25시간 이내로 근무해야 해요.'**
  String get tipWorkStart1;

  /// No description provided for @tipWorkStart2.
  ///
  /// In ko, this message translates to:
  /// **'주휴수당은 주 15시간 이상 근무 시 받을 수 있어요.'**
  String get tipWorkStart2;

  /// No description provided for @tipWorkStart3.
  ///
  /// In ko, this message translates to:
  /// **'근로계약서는 꼭 보관해두세요!'**
  String get tipWorkStart3;

  /// No description provided for @btnCheckMyVisa.
  ///
  /// In ko, this message translates to:
  /// **'내 비자 상태 확인하기 (완료)'**
  String get btnCheckMyVisa;

  /// No description provided for @permitFormTitle.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 신청서'**
  String get permitFormTitle;

  /// No description provided for @permitFormSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'마지막 단계입니다!\n사업주 정보를 확인해주세요.'**
  String get permitFormSubtitle;

  /// No description provided for @permitConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'약관 동의'**
  String get permitConsentTitle;

  /// No description provided for @permitConsentPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'약관 동의 화면입니다.'**
  String get permitConsentPlaceholder;

  /// No description provided for @lblApplicantInfo.
  ///
  /// In ko, this message translates to:
  /// **'신청자 정보'**
  String get lblApplicantInfo;

  /// No description provided for @lblName.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get lblName;

  /// No description provided for @lblAffiliation.
  ///
  /// In ko, this message translates to:
  /// **'소속'**
  String get lblAffiliation;

  /// No description provided for @lblVisa.
  ///
  /// In ko, this message translates to:
  /// **'비자'**
  String get lblVisa;

  /// No description provided for @lblWorkplaceInfo.
  ///
  /// In ko, this message translates to:
  /// **'근로지 정보'**
  String get lblWorkplaceInfo;

  /// No description provided for @labelTradeNameDetail.
  ///
  /// In ko, this message translates to:
  /// **'상호명 (사업자 등록증 상)'**
  String get labelTradeNameDetail;

  /// No description provided for @labelContact.
  ///
  /// In ko, this message translates to:
  /// **'담당자 연락처'**
  String get labelContact;

  /// No description provided for @btnFinalApply.
  ///
  /// In ko, this message translates to:
  /// **'최종 신청하기'**
  String get btnFinalApply;

  /// No description provided for @titleApplyComplete.
  ///
  /// In ko, this message translates to:
  /// **'신청 완료'**
  String get titleApplyComplete;

  /// No description provided for @msgApplyComplete.
  ///
  /// In ko, this message translates to:
  /// **'시간제 취업 허가 신청이 완료되었습니다.\n심사 결과는 약 3일 내에 통보됩니다.'**
  String get msgApplyComplete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
