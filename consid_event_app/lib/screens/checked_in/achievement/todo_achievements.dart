import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/screens/failed/failed_screen_achievement.dart';
import 'package:flutter/material.dart';

import 'achievement_types/double_scan.dart';
import 'achievement_types/get_scanned.dart';
import 'achievement_types/scan_qr.dart';

class TodoAchievements extends StatelessWidget {
  final String guestCode;
  final String achievementId;
  final Map<String, dynamic> achievement;
  const TodoAchievements(
      {Key? key,
      required this.guestCode,
      required this.achievementId,
      required this.achievement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (achievement[Constants.taskTypeRef]) {
      case Constants.scanQrTypeRef:
        return ScanQr(
            guestCode: guestCode,
            achievementId: achievementId,
            achievement: achievement);
      case Constants.getScannedTypeRef:
        return GetScanned(
            guestCode: guestCode,
            achievementId: achievementId,
            achievement: achievement);
      case Constants.doubleScanTypeRef:
        return DoubleScan(
            guestCode: guestCode,
            achievementId: achievementId,
            achievement: achievement);
      default:
        return const FailedScreenAchievement(
            title: Constants.somethingWentWrong);
    }
  }
}
