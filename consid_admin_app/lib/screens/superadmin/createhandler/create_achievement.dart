import 'package:admin_app/models/achieve_model.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';

import 'package:flutter/material.dart';

class CreateAchievement extends StatefulWidget {
  const CreateAchievement({
    Key? key,
  }) : super(key: key);
  @override
  _CreateAchievementState createState() => _CreateAchievementState();
}

class _CreateAchievementState extends State<CreateAchievement> {
  // References
  Firebase db = Firebase();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String titleInput = "";
  String descInput = "";
  String dropdownAchievementType = LocalVar.scanQr;

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
                _screenSize, LocalVar.createAchiev, _screenSize.width * 0.075),
            SizedBox(height: _screenSize.height * 0.03),
            Text(
              LocalVar.infoHere,
              style: CustomTextStyle.defaultStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _screenSize.height * 0.03),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: CustomColors.tabUnchosenBg,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownAchievementType,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 0,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownAchievementType = newValue!;
                        });
                      },
                      items: <String>[
                        LocalVar.opt1,
                        LocalVar.opt2,
                        LocalVar.opt3
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                          hintText: LocalVar.hintTitle,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.05)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return LocalVar.invalidTitle;
                        }
                        return null;
                      },
                      style: CustomTextStyle.codeInputStyle,
                      onChanged: (value) {
                        setState(() {
                          titleInput = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: _screenSize.height * 0.02),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      maxLines: 30,
                      controller: _descCtrl,
                      decoration: InputDecoration(
                          hintText: LocalVar.desc,
                          hintStyle: CustomTextStyle.hintStyle,
                          errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _screenSize.width * 0.05)),
                      textAlign: TextAlign.left,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 15) {
                          return LocalVar.invalidDesc;
                        }
                        return null;
                      },
                      style: CustomTextStyle.codeInputStyle,
                      onChanged: (value) {
                        setState(() {
                          descInput = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _screenSize.height * 0.05,
            ),
            defaultTextButton(context, LocalVar.send.toUpperCase(), () {
              if (_formKey.currentState!.validate()) {
                String chosenType = "scan_qr"; // default value

                // Convert dropdownlist into db-type
                switch (dropdownAchievementType) {
                  case LocalVar.opt3:
                    chosenType = "get_scanned";
                    break;
                  case LocalVar.opt2:
                    chosenType = "double_scan";
                    break;
                  default:
                    chosenType = "scan_qr";
                    break;
                }

                AchieveModel newAchievement = AchieveModel(
                    qrCode: chosenType + "/",
                    description: descInput,
                    title: titleInput,
                    type: chosenType);

                db.addAchievement(context, newAchievement);
              }
            },
                textSize: _screenSize.width * 0.053,
                useConstraint: true,
                constraintMaxHeight: _screenSize.height * 0.053,
                constraintMaxWidth: _screenSize.width * 0.36),
          ],
        ),
      ),
    );
  }
}
