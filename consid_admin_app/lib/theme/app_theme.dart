import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'custom_text_styles.dart';

@immutable
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: CustomColors.goldText,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: CustomColors.bgColor,
        fontFamily: 'Montserrat',
        backgroundColor: CustomColors.bgColor,

        // Text Themes
        textTheme: const TextTheme(
          subtitle1: CustomTextStyle.defaultStyle,
          bodyText1: CustomTextStyle.defaultStyle,
          bodyText2: CustomTextStyle.defaultStyle,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.goldLight)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.goldLight),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.goldLight),
          ),
        ),
        // BUTTON THEME
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(CustomColors.goldText),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          highlightElevation: 0,
        ),
        scrollbarTheme: ScrollbarThemeData(
          interactive: true,
          isAlwaysShown: true,
          radius: const Radius.circular(10.0),
          thumbColor: MaterialStateProperty.all(CustomColors.goldText),
          thickness: MaterialStateProperty.all(5.0),
          minThumbLength: 100,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: CustomTextStyle.defaultStyle,
          ),
        ));
  }
}
