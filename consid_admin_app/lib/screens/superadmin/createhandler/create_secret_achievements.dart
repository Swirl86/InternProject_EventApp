import 'package:admin_app/models/secret_achieve_model.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CreateSecretAchievement extends StatefulWidget {
  const CreateSecretAchievement({
    Key? key,
  }) : super(key: key);
  @override
  _CreateSecretAchievementState createState() =>
      _CreateSecretAchievementState();
}

class _CreateSecretAchievementState extends State<CreateSecretAchievement> {
  // References
  Firebase db = Firebase();
  final _formKey = GlobalKey<FormState>();

  // Default dropdown settings
  String localSecretAchievementPercentage = "50";
  String localSecretAchievementTrigger = "achievements";

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
                _screenSize, LocalVar.createSecret, _screenSize.width * 0.075),
            SizedBox(height: _screenSize.height * 0.03),
            Text(
              LocalVar.infoHere,
              style: CustomTextStyle.defaultStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _screenSize.height * 0.01),
            defaultDivider(),
            SizedBox(height: _screenSize.height * 0.01),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: CustomColors.tabUnchosenBg,
                    ),
                    child: DropdownButton<String>(
                      value: localSecretAchievementTrigger,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 0,
                      onChanged: (String? newValue) {
                        setState(() {
                          localSecretAchievementTrigger = newValue!;
                        });
                      },
                      items: <String>["achievements", "tickets"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: CustomColors.tabUnchosenBg,
                      ),
                      child: DropdownButton<String>(
                        value: localSecretAchievementPercentage,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 0,
                        onChanged: (String? newValue) {
                          setState(() {
                            localSecretAchievementPercentage = newValue!;
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
                    Text(
                      LocalVar.percentSign,
                      style: CustomTextStyle.defaultStyle,
                    ),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: _screenSize.height * 0.03,
            ),
            defaultTextButton(context, LocalVar.send.toUpperCase(), () {
              if (_formKey.currentState!.validate()) {
                SecretAchieveModel newSecretAchievement = SecretAchieveModel(
                    trigger: localSecretAchievementTrigger,
                    percentage: localSecretAchievementPercentage);

                db.addSecretAchievement(context, newSecretAchievement);
              }
            },
                textSize: _screenSize.width * 0.053,
                useConstraint: true,
                constraintMaxHeight: _screenSize.height * 0.053,
                constraintMaxWidth: _screenSize.width * 0.36),
            SizedBox(
              height: _screenSize.height * 0.03,
            ),
            // -----------------------------------------------
          ],
        ),
      ),
    );
  }
}
