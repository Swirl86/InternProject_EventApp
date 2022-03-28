import 'dart:io';

import 'package:admin_app/models/ticketType_model.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateInvites extends StatefulWidget {
  const CreateInvites({
    Key? key,
  }) : super(key: key);
  @override
  _CreateInvitesState createState() => _CreateInvitesState();
}

class _CreateInvitesState extends State<CreateInvites> {
  // Ref
  Firebase db = Firebase();

  // Keys
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _invitesNr = TextEditingController();

  // Strings
  int invitesNr = 0;

  String ticket1input = "";
  String ticket2input = "";
  String ticketNr1input = "";
  String ticketNr2input = "";
  int _count = 1;

  List<TicketTypeModel> modelList = <TicketTypeModel>[];

  @override
  void initState() {
    super.initState();

    modelList.add(TicketTypeModel(type: "", amount: 0));
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenSize.height * 0.03),
            defaultTextTitle(
                _screenSize, LocalVar.createInvites, _screenSize.width * 0.09),
            SizedBox(height: _screenSize.height * 0.01),
            Text(
              LocalVar.enterInfo,
              style: CustomTextStyle.defaultStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _screenSize.height * 0.01),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  defaultDivider(),
                  SizedBox(height: _screenSize.height * 0.01),
                  SizedBox(
                    width: _screenSize.width * 0.5,
                    child: TextFormField(
                      controller: _invitesNr,
                      keyboardType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: false)
                          : TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      decoration: InputDecoration(
                          hintText: LocalVar.nrInvites,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.04)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocalVar.invalidNr;
                        }
                        return null;
                      },
                      style: CustomTextStyle.codeInputStyle,
                      onChanged: (nrOfInvites) {
                        setState(() {
                          if (nrOfInvites.isNotEmpty) {
                            invitesNr = int.parse(nrOfInvites);
                          }
                        });
                      },
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      return _ticketTypeUI(context, index);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            _minusAndPlus(_count),
            SizedBox(height: _screenSize.height * 0.01),
            defaultTextButton(context, LocalVar.send.toUpperCase(), () {
              if (_formKey.currentState!.validate()) {
                db.createInvites(modelList, invitesNr);
                Navigator.pop(context);
              }
            },
                textSize: _screenSize.width * 0.053,
                useConstraint: true,
                constraintMaxHeight: _screenSize.height * 0.053,
                constraintMaxWidth: _screenSize.width * 0.36),
            SizedBox(height: _screenSize.height * 0.03),
          ],
        ),
      ),
    );
  }

  _ticketTypeUI(BuildContext context, int inputIndex) {
    final _screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: _screenSize.width * 0.05),
            child: Text('${LocalVar.justTicket} - ${inputIndex + 1}')),
        SizedBox(width: _screenSize.width * 0.03),
        SizedBox(
          width: _screenSize.width * 0.15,
          child: TextFormField(
            keyboardType: Platform.isIOS
                ? const TextInputType.numberWithOptions(
                    signed: true, decimal: false)
                : TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            decoration: InputDecoration(
                hintText: LocalVar.nrSpace,
                hintStyle: CustomTextStyle.hintStyle,
                errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _screenSize.width * 0.04)),
            textAlign: TextAlign.right,
            validator: (value) {
              if (value!.isEmpty) {
                return LocalVar.invalidNr;
              }
              return null;
            },
            style: CustomTextStyle.codeInputStyle,
            onChanged: (thisAmount) {
              setState(() {
                if (thisAmount.isNotEmpty) {
                  modelList[inputIndex].amount = num.parse(thisAmount);
                }
              });
            },
          ),
        ),
        SizedBox(width: _screenSize.width * 0.05),
        SizedBox(
          width: 120,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: LocalVar.nameT,
                hintStyle: CustomTextStyle.hintStyle,
                errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _screenSize.width * 0.04)),
            textAlign: TextAlign.left,
            validator: (value) {
              if (value!.isEmpty) {
                return LocalVar.invalidTitle;
              }
              return null;
            },
            style: CustomTextStyle.codeInputStyle,
            onChanged: (type) {
              setState(() {
                modelList[inputIndex].type = type;
              });
            },
          ),
        ),
      ],
    );
  }

  _minusAndPlus(inputCounter) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
          child: TextButton(
            onPressed: () async {
              setState(() {
                if (_count > 1) {
                  modelList.removeLast();
                  _count--;
                }
              });
            },
            child: Ink(
              decoration: BoxDecoration(
                  gradient: CustomColors.goldButton,
                  borderRadius: Constants.defaultRadius),
              child: Container(
                constraints:
                    const BoxConstraints(minHeight: 50.0, maxWidth: 50.0),
                alignment: Alignment.center,
                child: Text("-".toUpperCase(),
                    style: CustomTextStyle.buttonTextStyle),
              ),
            ),
          ),
          visible: inputCounter > 1),
      TextButton(
        onPressed: () async {
          setState(() {
            _count++;
            modelList.add(TicketTypeModel(type: "", amount: 0));
          });
        },
        child: Ink(
          decoration: BoxDecoration(
              gradient: CustomColors.goldButton,
              borderRadius: Constants.defaultRadius),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50.0, maxWidth: 50.0),
            alignment: Alignment.center,
            child:
                Text("+".toUpperCase(), style: CustomTextStyle.buttonTextStyle),
          ),
        ),
      ),
    ]);
  }
}
