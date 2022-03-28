import 'package:flutter/material.dart';

class Constants {
  // --------- Firebase Remote Config ---------
  // NOTE update value of "app_version" in Firebase Remote Config when new release
  static const String rcAppVersionRef = "app_version";
  // NOTE update value of _currentAppVersion for every release so it is the same as Firebase Remote Config
  static const String rcCurrentAppVersionRef = "1.0.3";

  // --------- Firebase auth guest default account ---------
  static const String emailAuth = 'SOME EMAIL AUTH';
  static const String password = 'login1234';

  // --------- SharedPreferences key ---------
  static const keySharPref = "guestCode";
  static const keyScannedSharPref = "scanned";

  // --------- Access variables for database collections/documents ---------
  static const guestsRef = "guests";
  static const eventRef = "event";

  static const informationRef = "information";

  static const startDateRef = "start_date";
  static const endDateRef = "end_date";
  static const checkedInRef = "checked_in";
  static const achievementsRef = "achievements";
  static const typesRef = "types";

  static const usedRef = "used";
  static const claimedRef = "claimed";

  static const secretsRef = "secrets";
  static const typeRef = "type";
  static const ticketsRef = "tickets";

  static const taskTitleRef = "task_title";
  static const taskDescriptionRef = "task_description";
  static const taskTypeRef = "task_type";
  static const solvedRef = "solved";

  static const typePercentRef = "type_percent";
  static const typeTriggerRef = "type_trigger";

  // --------- QR code type ---------
  static const guestCodeTypeRef = "guest_code";
  static const tickedTypeRef = "ticket";

  // --------- Achievement QR code types ---------
  static const scanQrTypeRef = "scan_qr";
  static const getScannedTypeRef = "get_scanned";
  static const doubleScanTypeRef = "double_scan";

  // --------- Fire storage - image names ---------
  static const logoImgRef = "logo";
  static const achievementsImgRef = "achievements";
  static const achievementInactiveImgRef = "achievement_inactive";
  static const ribbonImgRef = "ribbon";
  static const ticketsImgRef = "tickets";
  static const ticketUsedImgRef = "ticket_used";
  static const ticketUnusedImgRef = "ticket_unused";
  static const prize1ImgRef = "prize1";
  static const prize2ImgRef = "prize2";
  static const prize3ImgRef = "prize3";
  static const secretAchievImgRef = "secretAchiev";
  static const secretAchievImgRef2 = "secretAchiev2";

  // --------- Secret achievement ref ---------
  static const scannedRef = "scanned";
  static const int scanTriggerValue =
      2; // Scan X number of guest to activate achievement

  // --------- Local assets ---------
  static const lottieSecretAchievementRef1 = 'assets/secret1.json';
  static const lottieSecretAchievementRef2 = 'assets/secret2.json';
  static const lottieSecretAchievementRef3 = 'assets/secret3.json';

  static const lottieSuccess = 'assets/success.json';
  static const lottieFailed = 'assets/failed.json';
  static const lottiePermission = 'assets/permission.json';

  // --------- Dimensions ---------
  static const sideMargins = EdgeInsets.only(left: 30, right: 30);

  // --------- Button Related ---------
  static BorderRadius defaultRadius = BorderRadius.circular(30.0);

  // --------- Regex ---------
  static const emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const phoneNumberRegex = r'[0-9]';

  // --------- Month list -- for printouts ---------
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // --------- Hard coded values ---------
  static const int maxNumberInTopList = 10;
  static const newLine = "\n";
  static const empty = "";
  static const somethingWentWrong = "Something Went Wrong!";
}
