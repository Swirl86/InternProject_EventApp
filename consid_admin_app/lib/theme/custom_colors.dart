import 'package:flutter/material.dart';

class CustomColors {
  static const bgColor = Color(0xFF022a40);
  static const fadedBgColor = Color(0xFF9cb3be);
  static const goldLight = Color(0xFFeee17e);
  static const goldDark = Color(0xFFc5913f);
  static const goldEdge = Color(0xFFe3ca70);
  static const goldText = Color(0xFFd1bc6a);
  static const defDivider = Color(0xFF7d8d85);
  static const tabUnchosenBg = Color(0xFF233942);
  static const tabBarDivider = Color(0xFF2a4e60);

  static const goldButton = LinearGradient(colors: [
    CustomColors.goldDark,
    CustomColors.goldLight,
    CustomColors.goldDark
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);
}
