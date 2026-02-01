class AppAssets {
  static const String basePath = 'assets/images';

  // Character Images
  static const String capyFortuneHold = '$basePath/capy_fortune_hold.png';
  static const String capyMeditate = '$basePath/capy_meditate.png';
  static const String capyReadSleep = '$basePath/capy_read_sleep.png';
  static const String capySit = '$basePath/capy_sit.png';
  static const String capyBow = '$basePath/capy_bow.png';
  static const String capyBusiness = '$basePath/capy_business_cut.png';

  // Helper list for random selection (excluding fortune hold)
  static const List<String> randomPoses = [
    capyMeditate,
    capyReadSleep,
    capySit,
  ];
}
