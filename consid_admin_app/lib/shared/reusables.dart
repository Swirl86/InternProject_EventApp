import 'dart:developer';

import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';

// References
Firebase db = Firebase();

/* Info, Alert, fails ... */
showAlertDialog(BuildContext context, String textInput,
    [Color color = Colors.lightGreen]) {
  return showDialog(
    context: context,
    builder: (context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        title: Text(
          textInput,
          textAlign: TextAlign.center,
        ),
        titleTextStyle:
            CustomTextStyle.defaultStyle.copyWith(fontWeight: FontWeight.bold),
        backgroundColor: CustomColors.bgColor,
        shape: RoundedRectangleBorder(side: BorderSide(color: color)),
      );
    },
  );
}

confirmDialog(BuildContext context, dynamic data, bool ifSecret) {
  final _screenSize = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!

    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        shape:
            const RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
        title:
            Text(LocalVar.confirmDeletion, style: CustomTextStyle.defaultStyle),
        content: ifSecret
            ? Row(
                children: [
                  Text(data['type_percent']),
                  Text(LocalVar.percentSign),
                  Text(data['type_trigger']),
                ],
              )
            : Text(data['task_title']),
        actions: [
          TextButton(
            child: Text(LocalVar.cancel),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(LocalVar.submit),
            onPressed: () {
              db.deleteAchievement(context, data.id, ifSecret);
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    },
  );
}

loadingSpinner() {
  return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20),
      child: const CircularProgressIndicator(
        backgroundColor: CustomColors.goldDark,
        color: CustomColors.goldLight,
        strokeWidth: 5,
      ));
}

/* Navigation */

backButton(BuildContext context) {
  final _screenSize = MediaQuery.of(context).size;
  return Container(
    alignment: Alignment.topLeft,
    child: Align(
      alignment: Alignment.topLeft,
      child: FloatingActionButton(
        heroTag: "defBack",
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
          size: _screenSize.width * 0.09,
        ),
      ),
    ),
  );
}

/* Miscellaneous */

bottomLogo(dynamic _screenSize) {
  Firebase db = Firebase();

  return Expanded(
      child: Container(
    padding: EdgeInsets.only(
        bottom: _screenSize.height * 0.015, right: _screenSize.width * 0.04),
    alignment: Alignment.bottomRight,
    child: FutureBuilder<String>(
      future: db.getImageUrl(Constants.logo),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(context, Constants.somethingWentWrong);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPicture.network(
            url,
            width: _screenSize.width * 0.19,
            semanticsLabel: 'Logo',
            placeholderBuilder: (context) => const CircularProgressIndicator(
              backgroundColor: CustomColors.goldDark,
              color: CustomColors.goldLight,
              strokeWidth: 10,
            ),
          );
        } else {
          return loadingSpinner();
        }
      },
    ),
  ));
}

chosenTab(BuildContext context, String inputText, bool ifTabOnRight) {
  if (ifTabOnRight) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        child: Text(inputText),
      ),
    );
  } else {
    return Container(
      height: 20 + MediaQuery.of(context).padding.bottom,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: CustomColors.tabBarDivider,
                  width: 1,
                  style: BorderStyle.solid))),
      child: Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text(inputText),
        ),
      ),
    );
  }
}

defaultTextTitle(dynamic _screenSize, String inputText, [double? inputSize]) {
  return Center(
    child: Text(
      inputText,
      style: CustomTextStyle.linearText.copyWith(
          fontSize: inputSize ??
              _screenSize.width *
                  0.1), // if input, use it. Otherwise use screensize width fractionally
      textAlign: TextAlign.center,
      maxLines: 2,
    ),
  );
}

defaultDivider([double? widthFactor]) {
  return FractionallySizedBox(
    widthFactor: widthFactor ?? 0.8,
    child: const Divider(
      color: CustomColors.defDivider,
      thickness: 2,
    ),
  );
}

defaultPageMargins(BuildContext context) {
  final _screenSize = MediaQuery.of(context).size;
  return EdgeInsets.only(top: _screenSize.height * 0.06);
  //margin: const EdgeInsets.only(left: 30, top: 80, right: 30, bottom: 30),
}

// ----- Start of Default Buttons ----------------------------------------------------------------

defaultTextButtonWithIcon(BuildContext context, IconData iconDataInput,
    String inputText, Function inputCmd,
    [double? iconSize, double? textSize]) {
  final _screenSize = MediaQuery.of(context).size;
  return TextButton.icon(
      icon: Icon(iconDataInput,
          color: Theme.of(context).primaryColor,
          size: iconSize ?? _screenSize.width * 0.1),
      label: Text(
        inputText,
        style: CustomTextStyle.defaultStyle.copyWith(
            fontSize: textSize ?? _screenSize.width * 0.05,
            fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        inputCmd();
      });
}

defaultTextButton(BuildContext context, String inputText, Function inputCmd,
    {double? textSize,
    bool useConstraint = false,
    double? constraintMaxWidth,
    double? constraintMaxHeight}) {
  final _screenSize = MediaQuery.of(context).size;

/* 
Function switches between these two 
*/
  defaultContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: _screenSize.width * 0.04,
          horizontal: _screenSize.width * 0.12),
      child: Text(inputText.toUpperCase(),
          style: CustomTextStyle.buttonTextStyle
              .copyWith(fontSize: textSize ?? _screenSize.width * 0.05)),
    );
  }

  constraintContainer() {
    return Container(
      constraints: BoxConstraints(
          maxWidth: constraintMaxWidth ?? _screenSize.width * 0.25,
          maxHeight: constraintMaxHeight ?? _screenSize.height * 0.05),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Text(inputText.toUpperCase(),
            style: CustomTextStyle.buttonTextStyle
                .copyWith(fontSize: textSize ?? _screenSize.width * 0.045)),
      ),
    );
  }
  // --------------- End ------------------------

  return TextButton(
    onPressed: () {
      inputCmd();
    },
    child: Ink(
      decoration: BoxDecoration(
          gradient: CustomColors.goldButton,
          borderRadius: Constants.defaultRadius),
      child: SizedBox(
        child: useConstraint ? constraintContainer() : defaultContainer(),
      ),
    ),
  );
}

// ----- End of Default Buttons ----------------------------------------------------------------

gotUpdateAlertTitle(BuildContext context) => Center(
    child: Text(LocalVar.availableUpdate,
        style: CustomTextStyle.defaultStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.07)));

gotUpdateAlertContent(
        BuildContext context, String currentVersion, String remoteVersion) =>
    Text(
      LocalVar.current +
          ": " +
          currentVersion +
          "\n" +
          LocalVar.newest +
          ": " +
          remoteVersion,
      textAlign: TextAlign.center,
      style: CustomTextStyle.defaultStyle.copyWith(height: 1.5),
    );

gotUpdateAlertBtn() => Text(LocalVar.ok,
    style: CustomTextStyle.defaultStyle.copyWith(color: CustomColors.goldDark));
