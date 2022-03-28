import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

class RsvpCode extends StatefulWidget {
  const RsvpCode({Key? key}) : super(key: key);

  @override
  _RsvpCodeState createState() => _RsvpCodeState();
}

class _RsvpCodeState extends State<RsvpCode> {
  final FireDatabase db = FireDatabase();
  final _submitCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _codeInput = Constants.empty;

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
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Column(
                      children: [
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
                          margin: EdgeInsets.only(top: _currentHeight * 0.1),
                          child: const Text(
                            Local.prompCodeInput,
                            style: CustomTextStyle.defaultStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _getSpacing(_currentHeight, 0.05),
                        Form(
                            key: _formKey,
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: TextFormField(
                                controller: _submitCtrl,
                                maxLength: 4,
                                decoration: InputDecoration(
                                    hintText: Local.rsvpHint,
                                    hintStyle: CustomTextStyle.defaultStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.05),
                                    errorStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _currentWidth * 0.04)),
                                textAlign: TextAlign.left,
                                validator: (value) {
                                  if (value!.length != 4) {
                                    return Local.inputFormatInvalid;
                                  }
                                  return null;
                                },
                                style: CustomTextStyle.codeInputStyle,
                                onChanged: (value) {
                                  setState(() {
                                    _codeInput = value;
                                  });
                                },
                              ),
                            )),
                        _getSpacing(_currentHeight, 0.05),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              db.handleInvitationCode(context, _codeInput);
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
                              child:
                                  getGoldButtonInk(context, Local.buttonSend),
                            ),
                          ),
                        ),
                        _getSpacing(_currentHeight, 0.02),
                        bottomLogo(),
                        _getSpacing(_currentHeight, 0.02),
                      ],
                    ),
                  )),
            )));
  }

  _getSpacing(double currentHeight, double d) {
    return SizedBox(
      height: currentHeight * d,
    );
  }
}
