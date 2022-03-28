import 'package:flutter/material.dart';

class CustomColors {
  static const bgColor = Color(0xFF022a40);
  static const fadedBgColor = Color(0xFF9cb3be);
  static const goldLight = Color(0xFFeee17e);
  static const goldDark = Color(0xFFc5913f);
  static const goldLightDark = Color(0xFFe5c33a);
  static const goldEdge = Color(0xFFe3ca70);
  static const goldText = Color(0xFFd1bc6a);

  static const darkGray = Color(0xFF4C6A7A); //52707F
  static const unChosenBg = Color(0xFF233942);

  static const goldButton = LinearGradient(colors: [
    CustomColors.goldDark,
    CustomColors.goldLight,
    CustomColors.goldDark
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);

  static const List<Color>? confettiColorList = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.lightBlue,
    Colors.lightGreen,
    CustomColors.goldLight
  ];
}
