import 'package:flutter/material.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/community_model.dart';

class LocalizationUtils {
  static String getBoardLabel(BuildContext context, BoardType type) {
    switch (type) {
      case BoardType.free:
        return AppLocalizations.of(context)!.boardFree;
      case BoardType.info:
        return AppLocalizations.of(context)!.boardInfo;
      case BoardType.question:
        return AppLocalizations.of(context)!.boardQuestion;
      case BoardType.market:
        return AppLocalizations.of(context)!.boardMarket;
      case BoardType.secret:
        return AppLocalizations.of(context)!.boardSecret;
    }
  }

  static String getTimeAgo(BuildContext context, DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) {
      return AppLocalizations.of(context)!.timeJustNow;
    } else if (difference.inHours < 1) {
      return AppLocalizations.of(context)!.timeMinutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return AppLocalizations.of(context)!.timeHoursAgo(difference.inHours);
    } else {
      return AppLocalizations.of(context)!.timeDaysAgo(difference.inDays);
    }
  }
}
