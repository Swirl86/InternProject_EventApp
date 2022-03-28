import 'dart:io';

import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/registration.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RsvpRegister extends StatefulWidget {
  final String guestCode;
  const RsvpRegister({
    Key? key,
    required this.guestCode,
  }) : super(key: key);
  @override
  _RsvpRegisterState createState() => _RsvpRegisterState();
}

class _RsvpRegisterState extends State<RsvpRegister> {
  final FireDatabase db = FireDatabase();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneNumberCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _nameInput = Constants.empty;
  String _emailInput = Constants.empty;
  String _phoneNumberInput = Constants.empty;

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            margin: Constants.sideMargins,
            child: SingleChildScrollView(
                child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    sizedBoxSpacing(_currentHeight),
                    Center(
                      child: Text(
                        Local.rsvpTitle,
                        style: CustomTextStyle.titleText
                            .copyWith(fontSize: _currentWidth * 0.15),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _currentHeight * 0.08),
                      child: Text(
                        Local.prompRegisterInput,
                        style: CustomTextStyle.defaultStyle
                            .copyWith(fontSize: _currentWidth * 0.05),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _getSpacing(_currentHeight, 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                  hintText: Local.nameInputHint,
                                  hintStyle: CustomTextStyle.defaultStyle
                                      .copyWith(
                                          fontSize: _currentWidth * 0.045),
                                  errorStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _currentWidth * 0.045)),
                              textAlign: TextAlign.left,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 2) {
                                  return Local.nameFormatInvalid;
                                }
                                return null;
                              },
                              style: CustomTextStyle.codeInputStyle,
                              onChanged: (value) {
                                setState(() {
                                  _nameInput = value;
                                });
                              },
                            ),
                          ),
                          _getSpacing(_currentHeight, 0.035),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _emailCtrl,
                              decoration: InputDecoration(
                                  hintText: Local.emailInputHint,
                                  hintStyle: CustomTextStyle.defaultStyle
                                      .copyWith(
                                          fontSize: _currentWidth * 0.045),
                                  errorStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _currentWidth * 0.045)),
                              textAlign: TextAlign.left,
                              validator: (value) {
                                String pattern = Constants.emailRegex;
                                RegExp regex = RegExp(pattern);
                                if (value == null ||
                                    value.isEmpty ||
                                    !regex.hasMatch(value)) {
                                  return Local.emailFormatInvalid;
                                } else {
                                  return null;
                                }
                              },
                              style: CustomTextStyle.codeInputStyle,
                              onChanged: (value) {
                                setState(() {
                                  _emailInput = value;
                                });
                              },
                            ),
                          ),
                          _getSpacing(_currentHeight, 0.035),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: TextFormField(
                              keyboardType: Platform.isIOS
                                  ? const TextInputType.numberWithOptions(
                                      signed: true, decimal: false)
                                  : TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(Constants.phoneNumberRegex)),
                              ],
                              controller: _phoneNumberCtrl,
                              decoration: InputDecoration(
                                  hintText: Local.phoneNumberInputHint,
                                  hintStyle: CustomTextStyle.defaultStyle
                                      .copyWith(
                                          fontSize: _currentWidth * 0.045),
                                  errorStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _currentWidth * 0.045)),
                              textAlign: TextAlign.left,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 8) {
                                  return Local.phoneNumberFormatInvalid;
                                }
                                return null;
                              },
                              style: CustomTextStyle.codeInputStyle,
                              onChanged: (value) {
                                setState(() {
                                  _phoneNumberInput = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _getSpacing(_currentHeight, 0.06),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Registration newGuest = Registration(
                            uID: widget.guestCode,
                            name: _nameInput,
                            phone: _phoneNumberInput,
                            email: _emailInput,
                          );
                          db.updateGuest(context, newGuest);
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: CustomColors.goldButton,
                            borderRadius: Constants.defaultRadius),
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: _currentHeight * 0.08,
                              maxWidth: _currentWidth * 0.5),
                          alignment: Alignment.center,
                          child: getGoldButtonInk(context, Local.buttonSend),
                        ),
                      ),
                    ),
                    _getSpacing(_currentHeight, 0.02),
                    bottomLogo(),
                    _getSpacing(_currentHeight, 0.02),
                  ],
                ),
              ),
            ))));
  }

  _getSpacing(double currentHeight, double d) {
    return SizedBox(
      height: currentHeight * d,
    );
  }
}
