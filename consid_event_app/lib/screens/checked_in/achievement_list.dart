import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:consid_event_app/widget/achievements_widget.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class AchievementList extends StatefulWidget {
  const AchievementList({Key? key}) : super(key: key);

  @override
  _AchievementListState createState() => _AchievementListState();
}

class _AchievementListState extends State<AchievementList> {
  FireDatabase db = FireDatabase();
  String _guestCode = Constants.somethingWentWrong;
  bool _gotSecretAchievements = false;

  void _getGuestState() {
    db.getCurrentState().then(
        (localStateCode) => setState(() {
              _guestCode = localStateCode!;
              db.guestGotSecretAchievement(_guestCode).then((data) {
                setState(() {
                  _gotSecretAchievements = data;
                });
                db.checkIfSecretAchievementTrigger(
                    context, _guestCode, Constants.achievementsRef);
              }, onError: ((_) {
                showAlertDialog(
                    context, Constants.somethingWentWrong, Colors.red);
              }));
            }), onError: ((_) {
      showAlertDialog(context, Constants.somethingWentWrong, Colors.red);
    }));
  }

  @override
  void initState() {
    _getGuestState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: backArrowIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: _currentHeight * 0.15,
          ),
          Center(
            child: Text(
              Local.achievementsTitle,
              style: CustomTextStyle.titleText
                  .copyWith(fontSize: _currentWidth * 0.09),
            ),
          ),
          _gotSecretAchievements ? _getSecretGuestAchievements() : Container(),
          _getGuestAchievements(),
          SizedBox(
            height: _currentHeight * 0.01,
          ),
        ]),
      ),
    );
  }

  _getSecretGuestAchievements() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.getGuestSecretAchievements(_guestCode),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          return AchievementsWidget(
              snapshot: snapshot, guestCode: _guestCode, type: "secret");
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width);
        }
      },
    );
  }

  _getGuestAchievements() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.getEventAchievements(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          if (snapshot.data!.size != 0) {
            return AchievementsWidget(
                snapshot: snapshot, guestCode: _guestCode, type: "normal");
          } else {
            return const Offstage(
              offstage: true,
            );
          }
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width);
        }
      },
    );
  }
}
