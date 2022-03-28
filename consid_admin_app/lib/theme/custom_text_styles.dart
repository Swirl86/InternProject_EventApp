import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomTextStyle {
  // Base config for all CustomTextStyles
  static const String _fontFamily = 'Montserrat';
  static const TextStyle defaultStyle = TextStyle(
    fontFamily: _fontFamily,
    color: CustomColors.goldText,
    fontSize: 22,
  );

  static final defaultPaint = Paint()
    ..shader = const LinearGradient(
      colors: <Color>[
        CustomColors.goldDark,
        CustomColors.goldLight,
        CustomColors.goldDark
      ],
    ).createShader(const Rect.fromLTWH(100, 0, 200, 0));

  static TextStyle linearText = defaultStyle.copyWith(
      fontSize: 58, fontWeight: FontWeight.bold, foreground: defaultPaint);

  static TextStyle buttonTextStyle = defaultStyle.copyWith(
      color: CustomColors.bgColor, fontWeight: FontWeight.bold);

  static TextStyle hintStyle =
      defaultStyle.copyWith(fontSize: 18, color: CustomColors.goldText);

  static TextStyle codeInputStyle = defaultStyle.copyWith(
      fontSize: 24, color: CustomColors.goldText, letterSpacing: 3.0);
}
