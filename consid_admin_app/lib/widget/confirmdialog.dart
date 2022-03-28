import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

showConfirmDialog(
    BuildContext context, String ticketType, String userId, String ticketId) {
  // Ref
  Firebase db = Firebase();
  final _screenSize = MediaQuery.of(context).size;

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(LocalVar.cancel,
        style: CustomTextStyle.defaultStyle
            .copyWith(fontSize: _screenSize.width * 0.05)),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text(LocalVar.useTicket,
        style: CustomTextStyle.defaultStyle
            .copyWith(fontSize: _screenSize.width * 0.05)),
    onPressed: () {
      db.dbHandleTicket(context, userId, ticketId);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      LocalVar.alertDialog,
      style: CustomTextStyle.linearText
          .copyWith(fontSize: _screenSize.width * 0.08),
    ),
    content: Text(
      ticketType + "\n\n" + LocalVar.confirmTicket,
      textAlign: TextAlign.center,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
    titleTextStyle:
        CustomTextStyle.defaultStyle.copyWith(fontWeight: FontWeight.bold),
    backgroundColor: CustomColors.tabUnchosenBg,
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
