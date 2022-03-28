import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/event.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:consid_event_app/widget/star_confetti_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

loadingSpinner(double currentWidth, [double d = 0.1]) {
  return Container(
      width: currentWidth * d,
      height: currentWidth * d,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        backgroundColor: CustomColors.goldDark,
        color: CustomColors.goldLight,
        strokeWidth: 5,
      ));
}

showAlertDialog(BuildContext context, String textInput, Color color) {
  showDialog(
    context: context,
    builder: (context) {
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        title: Text(
          textInput,
          textAlign: TextAlign.center,
        ),
        titleTextStyle: CustomTextStyle.defaultBoldStyle,
        backgroundColor: CustomColors.bgColor,
        shape: RoundedRectangleBorder(side: BorderSide(color: color)),
      );
    },
  );
}

getGoldButtonInk(BuildContext context, String btnStr) {
  return Ink(
    decoration: BoxDecoration(
        gradient: CustomColors.goldButton,
        borderRadius: Constants.defaultRadius),
    child: Container(
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.08,
          maxWidth: MediaQuery.of(context).size.width * 0.5),
      alignment: Alignment.center,
      child: Text(btnStr.toUpperCase(),
          style: CustomTextStyle.buttonTextStyle
              .copyWith(fontSize: MediaQuery.of(context).size.width * 0.06)),
    ),
  );
}

getTimeDifference(dateString) {
  var result =
      DateTime.fromMillisecondsSinceEpoch(int.parse(dateString) * 1000);

  return result.difference(DateTime.now()).inSeconds;
}

getTimeStampAsString(Timestamp timestamp) {
  DateTime dt = timestamp.toDate();
  String monthStr = Constants.months[dt.month - 1];
  String hour = dt.hour.toString().length < 2
      ? "0" + dt.hour.toString()
      : dt.hour.toString();

  String minute = dt.minute.toString().length < 2
      ? "0" + dt.minute.toString()
      : dt.minute.toString();

  return "${dt.day} $monthStr ${dt.year} $hour:$minute";
}

getCapitalizeFirstChar(String s) =>
    s[0].toUpperCase() + s.substring(1).toLowerCase();

getQrScannerOverlayShape(double currentWidth) => QrScannerOverlayShape(
      borderColor: CustomColors.goldEdge,
      borderWidth: 20,
      cutOutSize: currentWidth * 0.85,
      borderLength: 30,
    );

backArrowIcon() => const Icon(
      Icons.arrow_back_outlined,
      color: Colors.white,
      size: 34,
    );

closeIcon() => const Icon(
      Icons.close,
      color: Colors.white,
      size: 34,
    );

infoIcon() => const Icon(
      Icons.info_outline,
      color: CustomColors.goldDark,
      size: 34,
    );

clickIcon() => const Icon(
      Icons.touch_app_outlined,
      color: Colors.white,
      size: 40,
    );

sizedBoxTop(double currentHeight) => SizedBox(
      height: currentHeight * 0.065,
    );

sizedBoxSpacing(double currentHeight, [d = 0.13]) => SizedBox(
      height: currentHeight * d,
    );

closeIconTopMargin(double currentHeight) =>
    EdgeInsets.only(top: currentHeight * 0.065);

gotUpdateAlertTitle(BuildContext context) => Text(Local.updateAlertTitle,
    style: CustomTextStyle.boldGradientTextStyle
        .copyWith(fontSize: MediaQuery.of(context).size.width * 0.07));

gotUpdateAlertContent(
        BuildContext context, String currentVersion, String remoteVersion) =>
    Text(
      Local.updateAlertContent(currentVersion, remoteVersion),
      textAlign: TextAlign.center,
      style: CustomTextStyle.defaultStyle.copyWith(height: 1.5),
    );

gotUpdateAlertBtn() => Text(Local.updateAlertBtnText,
    style: CustomTextStyle.defaultBoldStyle
        .copyWith(color: CustomColors.goldDark));

Future showInformationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final _currentWidth = MediaQuery.of(context).size.width;
      final _currentHeight = MediaQuery.of(context).size.height;
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: CustomColors.goldDark)),
          backgroundColor: CustomColors.unChosenBg,
          elevation: 16,
          child: SizedBox(
              height: _currentHeight * 0.6,
              width: _currentWidth * 0.4,
              child: StarConfettiWidget(
                  child: Scrollbar(
                radius: const Radius.circular(40),
                isAlwaysShown: true,
                child: Container(
                  margin: EdgeInsets.only(
                      left: _currentWidth * 0.05, right: _currentWidth * 0.05),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: _currentHeight * 0.05),
                      Center(
                          child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5, // Space between underline and text
                        ),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: CustomColors.goldLightDark,
                          width: 1.0, // Underline thickness
                        ))),
                        child: Text(getCapitalizeFirstChar(Constants.eventRef),
                            style: CustomTextStyle.boldGradientTextStyle),
                      )),
                      SizedBox(height: _currentHeight * 0.05),
                      Text(
                        Event.instance!.title,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _currentHeight * 0.03),
                      (Event.instance!.title == Event.instance!.description
                          ? Container()
                          : Text(
                              Event.instance!.description,
                              textAlign: TextAlign.center,
                            )),
                      SizedBox(height: _currentHeight * 0.03),
                      Text(
                        getTimeStampAsString(Event.instance!.startDate),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _currentHeight * 0.03),
                      const Text(
                        "-",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _currentHeight * 0.03),
                      Text(
                        getTimeStampAsString(Event.instance!.endDate),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _currentHeight * 0.05),
                    ],
                  ),
                ),
              ))));
    },
  );
}

Future<bool> setEventInstanceInformation() async {
  FireDatabase db = FireDatabase();
  var result = await db.getEventSnapshoot();
  Event(
      title: result?.get('title') ?? "Unknown",
      description: result?.get('description') ?? "Unknown",
      startDate: result?.get('start_date'),
      endDate: result?.get('end_date'));
  return getTimeDifference(Event.instance!.endDate.seconds.toString()) >= 0 &&
      getTimeDifference(Event.instance!.startDate.seconds.toString()) <= 0;
}
