import 'dart:developer';

import 'package:admin_app/models/registration_model.dart';
import 'package:admin_app/models/ticketType_model.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/userinfo_widget.dart';
import '../widget/confirmdialog.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ManualHandler extends StatefulWidget {
  const ManualHandler({Key? key}) : super(key: key);

  @override
  _ManualHandlerState createState() => _ManualHandlerState();
}

class _ManualHandlerState extends State<ManualHandler> {
  // References
  final AuthService _authService = AuthService();
  final User? user = _firebaseAuth.currentUser;

  Firebase db = Firebase();
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeCtrl = TextEditingController();
  String inviteCodeEntered = "";

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneNumberCtrl = TextEditingController();
  String _nameInput = Constants.empty;
  String _emailInput = Constants.empty;
  String _phoneNumberInput = Constants.empty;

  bool addTicketMode = false;
  bool showAddTicket = false;
  TicketTypeModel newTicket = TicketTypeModel(type: "", amount: 0);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    if (inviteCodeEntered.length != 4) addTicketMode = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: user?.email == Constants.superAdmin,
        child: Wrap(children: [
          Visibility(
            visible: showAddTicket &&
                !addTicketMode &&
                inviteCodeEntered.length == 4,
            child: defaultTextButton(context, LocalVar.addTicket.toUpperCase(),
                () {
              setState(() {
                addTicketMode = true;
              });
            }, textSize: _screenSize.width * 0.04, useConstraint: true),
          ),
          Visibility(
            visible: addTicketMode && inviteCodeEntered.length == 4,
            child:
                defaultTextButton(context, LocalVar.cancel.toUpperCase(), () {
              setState(() {
                addTicketMode = false;
              });
            }, textSize: _screenSize.width * 0.04, useConstraint: true),
          ),
          Visibility(
            visible: addTicketMode && inviteCodeEntered.length == 4,
            child: defaultTextButton(context, LocalVar.save.toUpperCase(), () {
              setState(() {
                addTicketMode = false;
                db.addTicketToSpecificGuest(
                    context, inviteCodeEntered, newTicket);
              });
            }, textSize: _screenSize.width * 0.04, useConstraint: true),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: defaultPageMargins(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              backButton(context),
              defaultTextTitle(_screenSize, LocalVar.manualHandler),
              SizedBox(height: _screenSize.height * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FractionallySizedBox(
                      widthFactor: 0.4,
                      child: TextFormField(
                        controller: _inviteCodeCtrl,
                        maxLength: 4,
                        decoration: InputDecoration(
                            hintText: LocalVar.hintInputCode,
                            hintStyle: CustomTextStyle.hintStyle,
                            errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _screenSize.width * 0.05)),
                        textAlign: TextAlign.left,
                        validator: (value) {
                          if (value!.length != 4) {
                            return LocalVar.invalidTitle;
                          }
                          return null;
                        },
                        style: CustomTextStyle.codeInputStyle,
                        onChanged: (value) {
                          setState(() {
                            inviteCodeEntered = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              (inviteCodeEntered.length == 4)
                  ? Column(children: <Widget>[
                      FutureBuilder<DocumentSnapshot>(
                        future: db.getSpecificGuest(inviteCodeEntered),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return showAlertDialog(context,
                                Constants.somethingWentWrong, Colors.red);
                          } else if (snapshot.hasData) {
                            if (snapshot.data!['checked_in']) {
                              showAddTicket = true;
                            }
                            if (snapshot.data!.exists &&
                                snapshot.data!['claimed']) {
                              return Column(
                                children: [
                                  userInfo(snapshot.data!, _formKey, context,
                                      inviteCodeEntered),
                                  Column(children: [
                                    SizedBox(height: _screenSize.height * 0.02),
                                    Text(
                                      LocalVar.ticketsLeft,
                                      style: CustomTextStyle.defaultStyle
                                          .copyWith(
                                              fontSize:
                                                  _screenSize.width * 0.07),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: _screenSize.height * 0.01),
                                    (snapshot.data!['checked_in'])
                                        ? Column(children: [
                                            userTickets(context),
                                            Visibility(
                                              visible: addTicketMode,
                                              child: _ticketTypeUI(context),
                                            ),
                                          ])
                                        : Text(
                                            LocalVar.ticketsCantUse,
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.defaultStyle
                                                .copyWith(
                                                    fontSize:
                                                        _screenSize.width *
                                                            0.05),
                                            maxLines: 2,
                                          ),
                                  ])
                                ],
                              );
                            } else if (snapshot.data!.exists &&
                                !snapshot.data!['claimed']) {
                              return showRegistrationForm(context);
                            } else {
                              return Text(LocalVar.userNoExist);
                            }
                          } else {
                            return loadingSpinner();
                          }
                        },
                      )
                    ])
                  : const SizedBox(),
              SizedBox(height: _screenSize.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  userTickets(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: [
      StreamBuilder<QuerySnapshot>(
        stream: db.getUnusedUserTickets(inviteCodeEntered),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return showAlertDialog(context, Constants.somethingWentWrong)();
          } else if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: _screenSize.height * 0.08,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];

                return Column(children: [
                  defaultTextButton(
                    context,
                    data['type'],
                    () {
                      showConfirmDialog(
                          context, data['type'], inviteCodeEntered, data.id);
                    },
                    textSize: _screenSize.width * 0.045,
                    useConstraint: true,
                  ),
                ]);
              },
            );
          } else {
            return loadingSpinner();
          }
        },
      ),
    ]);
  }

  showRegistrationForm(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      FutureBuilder<DocumentSnapshot>(
        future: db.getSpecificGuest(inviteCodeEntered),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return showAlertDialog(
                context, Constants.somethingWentWrong, Colors.red);
          } else if (snapshot.hasData) {
            if (snapshot.data!.exists && snapshot.data!['claimed'] == false) {
              return Column(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                          hintText: LocalVar.nameInputHint,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.05)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return LocalVar.nameFormatInvalid;
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
                  SizedBox(height: _screenSize.height * 0.02),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                          hintText: LocalVar.emailInputHint,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.05)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        String pattern = Constants.emailRegex;
                        RegExp regex = RegExp(pattern);
                        if (value == null ||
                            value.isEmpty ||
                            !regex.hasMatch(value)) {
                          return LocalVar.emailFormatInvalid;
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
                  SizedBox(height: _screenSize.height * 0.02),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(Constants.phoneNumberRegex)),
                      ],
                      controller: _phoneNumberCtrl,
                      decoration: InputDecoration(
                          hintText: LocalVar.phoneNumberInputHint,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.05)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return LocalVar.phoneNumberFormatInvalid;
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
                  SizedBox(height: _screenSize.height * 0.02),
                  defaultTextButton(
                    context,
                    LocalVar.submit.toUpperCase(),
                    () {
                      if (_formKey.currentState!.validate()) {
                        RegistrationModel newGuest = RegistrationModel(
                          uID: inviteCodeEntered,
                          name: _nameInput,
                          phone: _phoneNumberInput,
                          email: _emailInput,
                        );
                        db.updateGuest(context, newGuest);
                      }
                    },
                  )
                ],
              );
            }
            if (snapshot.data!.exists && snapshot.data!['claimed'] == true) {
              return Text(LocalVar.userAlreadyReg);
            } else {
              return Text(LocalVar.invalidCode);
            }
          } else {
            return loadingSpinner();
          }
        },
      )
    ]);
  }

  _ticketTypeUI(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: _screenSize.width * 0.05),
            child: Text(LocalVar.nameT + ": ")),
        SizedBox(width: _screenSize.width * 0.03),
        SizedBox(
          width: _screenSize.width * 0.5,
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
                newTicket = TicketTypeModel(type: type, amount: 1);
              });
            },
          ),
        ),
      ],
    );
  }
}
