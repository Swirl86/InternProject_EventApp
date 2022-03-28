import 'package:flutter/material.dart';

import 'custom_colors.dart';

// --------- Base Config -----------
final defaultPaint = Paint()
  ..shader = const LinearGradient(
    colors: <Color>[
      CustomColors.goldDark,
      CustomColors.goldLight,
      CustomColors.goldDark
    ],
  ).createShader(const Rect.fromLTWH(100, 0, 200, 0));

// --------- Default Text Style -----------
class CustomTextStyle {
  static const TextStyle defaultStyle = TextStyle(
    color: CustomColors.goldText,
    fontSize: 22,
  );

  static const TextStyle defaultBoldStyle = TextStyle(
    color: CustomColors.goldText,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  static const TextStyle ticketDefaultStyle = TextStyle(
    color: CustomColors.bgColor,
  );

// --------- Gradient Text Style -----------
  static TextStyle titleText = TextStyle(
      fontSize: 58, fontWeight: FontWeight.bold, foreground: defaultPaint);

  static TextStyle mediumTitleText = TextStyle(
      fontSize: 38, fontWeight: FontWeight.bold, foreground: defaultPaint);

  static TextStyle countDownTextStyle =
      TextStyle(fontSize: 20, foreground: defaultPaint);

  static TextStyle boldGradientTextStyleCountDown = TextStyle(
      fontSize: 66,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: <Color>[
            CustomColors.goldDark,
            CustomColors.goldLight,
            CustomColors.goldDark,
          ],
        ).createShader(const Rect.fromLTWH(150, 0, 100, 0)));

  static TextStyle boldGradientTextStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 28, foreground: defaultPaint);

  static TextStyle darkBoldGradientTextStyle = TextStyle(
      fontSize: 66,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: <Color>[
            CustomColors.goldDark,
            CustomColors.goldLightDark,
            CustomColors.goldDark,
          ],
        ).createShader(const Rect.fromLTWH(150, 0, 100, 0)));

// --------- Text Styles -----------

  static const TextStyle codeInputStyle = TextStyle(
    color: CustomColors.goldText,
    fontSize: 24,
    letterSpacing: 3.0,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: CustomColors.bgColor,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle ticketUsedTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: CustomColors.fadedBgColor,
    letterSpacing: 3.0,
  );

  static const TextStyle ticketUnUsedTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: CustomColors.bgColor,
    letterSpacing: 3.0,
  );

  static const TextStyle ticketRightSideStyle = TextStyle(
    color: CustomColors.bgColor,
  );

  static const TextStyle achievementUnCompletedTitleTextStyle = TextStyle(
    letterSpacing: 1.0,
    color: CustomColors.darkGray,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}
