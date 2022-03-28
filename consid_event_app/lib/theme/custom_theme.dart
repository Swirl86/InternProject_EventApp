import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'custom_colors.dart';

const String fontType = 'Montserrat';

@immutable
class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.goldText,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: CustomColors.bgColor,
      fontFamily: fontType,
      //hintColor: CustomColors.goldText,
      textTheme: const TextTheme(bodyText2: CustomTextStyle.defaultStyle),
      // APPBAR
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      // TEXT UNDERLINE STYLE
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
      // BUTTON STYLE
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          highlightElevation: 0),

      // SCROLLBAR
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        isAlwaysShown: false,
        radius: const Radius.circular(10.0),
        thumbColor: MaterialStateProperty.all(CustomColors.goldDark),
        thickness: MaterialStateProperty.all(5.0),
        minThumbLength: 100,
      ),
    );
  }
}
