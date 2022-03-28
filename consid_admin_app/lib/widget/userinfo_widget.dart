import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget userInfo(DocumentSnapshot data, GlobalKey<FormState> _formKey,
    BuildContext context, String inviteCodeEntered) {
  // Ref
  final _screenSize = MediaQuery.of(context).size;
  Firebase db = Firebase();
  const myMarginTop = 8.0;

  return Column(children: [
    data['checked_in']
        ? const SizedBox()
        : defaultTextButton(context, LocalVar.confirmCheckin, () {
            if (_formKey.currentState!.validate()) {
              db.dbHandleCheckin(context, data);
            }
          }),
    SizedBox(height: _screenSize.height * 0.02),
    Table(
      columnWidths: {
        0: FixedColumnWidth(_screenSize.width * 0.3),
      },
      border: const TableBorder(
          top: BorderSide(color: CustomColors.goldText, width: 1),
          bottom: BorderSide(color: CustomColors.goldText, width: 1)),
      children: [
        TableRow(children: [
          Column(children: [
            Container(
                margin: const EdgeInsets.only(top: myMarginTop),
                child: Text(LocalVar.name))
          ]),
          Column(children: [
            Container(
                margin: const EdgeInsets.only(top: myMarginTop),
                child: Text(data['name']))
          ]),
        ]),
        TableRow(children: [
          Column(children: [
            Container(
                margin: const EdgeInsets.only(top: myMarginTop),
                child: Text(LocalVar.email))
          ]),
          Column(children: [
            Container(
                margin: const EdgeInsets.only(top: myMarginTop),
                child: FittedBox(fit: BoxFit.fill, child: Text(data['email']))),
          ]),
        ]),
        TableRow(children: [
          Column(children: [
            Container(
                margin: const EdgeInsets.only(top: myMarginTop),
                child:
                    FittedBox(fit: BoxFit.fill, child: Text(LocalVar.phoneNr))),
          ]),
          Column(children: [
            Container(
                margin: const EdgeInsets.only(
                    top: myMarginTop, bottom: myMarginTop),
                child:
                    FittedBox(fit: BoxFit.fill, child: Text(data['phone_nr']))),
          ]),
        ]),
      ],
    ),
  ]);
}
