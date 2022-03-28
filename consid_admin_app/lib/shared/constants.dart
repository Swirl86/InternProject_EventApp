import 'package:flutter/material.dart';

class Constants {
  // NOTE update value of "app_version" in Firebase Remote Config when new release
  static const String rcAppVersionRef = "admin_version";
  // NOTE update value of _currentAppVersion for every release so it is the same as Firebase Remote Config
  static const String rcCurrentAppVersionRef = "1.0.2";

  // Design related
  static BorderRadius defaultRadius = BorderRadius.circular(30.0);

  // Fire storage - image names
  static const logo = "logo.svg";

  // Hard coded values
  static const somethingWentWrong = "Something Went Wrong!";

  static String urlToCloudCreateInvites =
      'SOME URL';

  static String empty = "";

  // Regex
  static const emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static const phoneNumberRegex = r'[0-9]';

  static String superAdmin =
      "SOME EMAIL FOR AUTH"; //address of superadmin account in firebase
}
