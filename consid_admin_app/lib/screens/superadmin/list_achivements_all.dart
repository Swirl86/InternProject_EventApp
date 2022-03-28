import 'package:admin_app/models/achieve_model.dart';
import 'package:admin_app/models/secret_achieve_model.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ListAchievementsAll extends StatefulWidget {
  const ListAchievementsAll({
    Key? key,
  }) : super(key: key);
  @override
  _ListAchievementsAllState createState() => _ListAchievementsAllState();
}

class _ListAchievementsAllState extends State<ListAchievementsAll> {
  Firebase db = Firebase();

  final List<bool> _regularView = [];

  List<String> regularAchievementTitle = [];
  List<String> regularAchievementType = [];
  List<String> regularAchievementDescription = [];

  List<bool> secretView = [];
  List<String> secretAchievementPercentage = [];
  List<String> secretAchievementTrigger = [];

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: _screenSize.width * 0.09,
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              margin: defaultPageMargins(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //backButton(context),
                  SizedBox(height: _screenSize.height * 0.01),
                  defaultTextTitle(_screenSize, LocalVar.allAchievements,
                      _screenSize.width * 0.09),
                  SizedBox(height: _screenSize.height * 0.01),
                  defaultDivider(),
                  Text(
                    LocalVar.currentAchievements,
                    style: CustomTextStyle.defaultStyle,
                    textAlign: TextAlign.center,
                  ),
                  defaultDivider(),
                  SizedBox(height: _screenSize.height * 0.01),
                  StreamBuilder<QuerySnapshot>(
                    stream: db.getNormalAchievements(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return showAlertDialog(
                            context, Constants.somethingWentWrong)();
                      } else if (snapshot.hasData) {
                        return showAllAchievements(context, snapshot);
                      } else {
                        return loadingSpinner();
                      }
                    },
                  ),
                  SizedBox(height: _screenSize.height * 0.01),
                  defaultDivider(),
                  Text(
                    LocalVar.currentSecret,
                    style: CustomTextStyle.defaultStyle,
                    textAlign: TextAlign.center,
                  ),
                  defaultDivider(),
                  SizedBox(height: _screenSize.height * 0.01),
                  StreamBuilder<QuerySnapshot>(
                    stream: db.getSecretAchievements(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return showAlertDialog(
                            context, Constants.somethingWentWrong)();
                      } else if (snapshot.hasData) {
                        return showCurrentSecretAchievements(context, snapshot);
                      } else {
                        return loadingSpinner();
                      }
                    },
                  ),
                  SizedBox(height: _screenSize.height * 0.01),
                  defaultDivider(),
                  SizedBox(height: _screenSize.height * 0.01),
                ],
              ),
            ),
          ),
        ));
  }

  Widget showAllAchievements(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: [
      MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];

                // Create and Set default values for array lists
                regularAchievementTitle.add(data['task_title']);
                regularAchievementType.add(data['task_type']);
                regularAchievementDescription.add(data['task_description']);

                _regularView.add(true);
                return ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: _screenSize.width * 0.05, vertical: 0.0),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: (_regularView[index])
                      ? showViewMode(data)
                      : showEditMode(context, data, index),
                  trailing: Wrap(
                    spacing: _screenSize.width * 0.005,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            _regularView[index] = !_regularView[index];
                            if (_regularView[index] == true) {
                              AchieveModel updatedAchievement = AchieveModel(
                                  qrCode: "",
                                  description:
                                      regularAchievementDescription[index],
                                  title: regularAchievementTitle[index],
                                  type: regularAchievementType[index],
                                  id: data.id);

                              db.updateAchievement(context, updatedAchievement);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          confirmDialog(context, data, false);
                        },
                      ),
                    ],
                  ),
                );
              })),
    ]);
  }

  showEditMode(
      BuildContext context, DocumentSnapshot<Object?> data, int inputIndex) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: [
      TextFormField(
        initialValue: regularAchievementTitle[inputIndex],
        keyboardType: TextInputType.multiline,
        //controller: _emailCtrl,
        style: CustomTextStyle.codeInputStyle
            .copyWith(fontSize: _screenSize.width * 0.055),
        decoration: InputDecoration(
            filled: true,
            fillColor: CustomColors.tabUnchosenBg,
            hintStyle: CustomTextStyle.hintStyle,
            errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _screenSize.width * 0.05)),
        textAlign: TextAlign.left,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocalVar.invalid;
          } else {
            return null;
          }
        },
        onChanged: (value) {
          setState(() {
            regularAchievementTitle[inputIndex] = value;
          });
        },
      ),
      Theme(
        data: Theme.of(context).copyWith(
            canvasColor: CustomColors.tabUnchosenBg,
            backgroundColor: CustomColors.tabUnchosenBg),
        child: DropdownButton<String>(
          value: regularAchievementType[inputIndex],
          icon: const Icon(Icons.arrow_downward),
          elevation: 0,
          onChanged: (String? newValue) {
            setState(() {
              regularAchievementType[inputIndex] = newValue!;
            });
          },
          items: <String>["scan_qr", "get_scanned", "double_scan"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      TextFormField(
        initialValue: regularAchievementDescription[inputIndex],
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: 30,
        style: CustomTextStyle.codeInputStyle
            .copyWith(fontSize: _screenSize.width * 0.045),
        decoration: InputDecoration(
            filled: true,
            fillColor: CustomColors.tabUnchosenBg,
            errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _screenSize.width * 0.05)),
        textAlign: TextAlign.left,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocalVar.invalid;
          } else {
            return null;
          }
        },
        onChanged: (value) {
          setState(() {
            regularAchievementDescription[inputIndex] = value.toLowerCase();
          });
        },
      ),
    ]);
  }

  showViewMode(DocumentSnapshot<Object?> data) {
    return Row(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Text(
            data['task_title'],
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ],
    );
  }

  Widget showCurrentSecretAchievements(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: [
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];

              // Create and Set default values for array lists
              secretAchievementTrigger
                  .add(data['type_trigger'].toString().toLowerCase());
              secretAchievementPercentage
                  .add(data['type_percent'].toString().toLowerCase());

              secretView.add(true);
              return ListTile(
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: _screenSize.width * 0.05, vertical: 0.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: (secretView[index])
                    ? showSecretViewMode(data)
                    : FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: CustomColors.tabUnchosenBg,
                              ),
                              child: DropdownButton<String>(
                                value: secretAchievementPercentage[index],
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 0,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    secretAchievementPercentage[index] =
                                        newValue!;
                                  });
                                },
                                items: <String>[
                                  "10",
                                  "20",
                                  "30",
                                  "40",
                                  "50",
                                  "60",
                                  "70",
                                  "80",
                                  "90",
                                  "100"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Text(LocalVar.percentSign),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: CustomColors.tabUnchosenBg,
                              ),
                              child: DropdownButton<String>(
                                value: secretAchievementTrigger[index],
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 0,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    secretAchievementTrigger[index] = newValue!;
                                  });
                                },
                                items: <String>[
                                  "achievements",
                                  "tickets"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )),
                trailing: Wrap(
                  spacing: _screenSize.width * 0.005, // space between two icons
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        SecretAchieveModel thisSecretAchievement =
                            SecretAchieveModel(
                                id: data.id,
                                trigger: secretAchievementTrigger[index],
                                percentage: secretAchievementPercentage[index]);

                        if (!secretView[index]) {
                          db.updateSecretAchievement(
                              context, thisSecretAchievement);
                        }

                        setState(() {
                          secretView[index] =
                              !secretView[index]; // switch view mode
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        confirmDialog(context, data, true);
                      },
                    ),
                  ],
                ),
              );
            }),
      )
    ]);
  }

  showSecretViewMode(DocumentSnapshot<Object?> data) {
    return Row(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Text(
            data['type_percent'],
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        Text(LocalVar.percentSign),
        FittedBox(
          fit: BoxFit.fill,
          child: Text(
            data['type_trigger'],
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ],
    );
  }
}
