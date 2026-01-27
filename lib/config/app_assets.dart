class AppAssets {
  static const String basePath = 'assets/images';

  // Character Images
  static const String capyFortuneHold = '$basePath/capy_fortune_hold.png.png';
  static const String capyMeditate = '$basePath/capy_meditate.png.png';
  static const String capyReadSleep = '$basePath/capy_read_sleep.png.png';
  static const String capySit = '$basePath/capy_sit.png.png';
  static const String capyBow = '$basePath/capy_bow.png.png';

  // Helper list for random selection (excluding fortune hold)
  static const List<String> randomPoses = [
    capyMeditate,
    capyReadSleep,
    capySit,
  ];
}
