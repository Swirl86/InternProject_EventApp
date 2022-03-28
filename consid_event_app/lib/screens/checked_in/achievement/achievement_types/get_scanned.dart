import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/achievement.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/failed/failed_screen_achievement.dart';
import 'package:consid_event_app/screens/success/success_screen_achievement.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../achievement_list.dart';

class GetScanned extends StatefulWidget {
  final String guestCode;
  final String achievementId;
  final Map<String, dynamic> achievement;
  const GetScanned(
      {Key? key,
      required this.guestCode,
      required this.achievementId,
      required this.achievement})
      : super(key: key);

  @override
  _GetScannedState createState() => _GetScannedState();
}

class _GetScannedState extends State<GetScanned> {
  late StreamSubscription<QuerySnapshot<Object?>> streamSubscription;
  FireDatabase db = FireDatabase();

  void _listenToAchievementChanges() {
    streamSubscription =
        db.getGuestAchievements(widget.guestCode).listen((data) {
      streamSubscription.onData((data) {
        var currentAch = Achievement(
          uID: widget.achievementId,
          title: widget.achievement[Constants.taskTitleRef],
          description: widget.achievement[Constants.taskDescriptionRef],
          solved: Timestamp.now(),
        );
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SuccessScreenAchievement(achievement: currentAch)));
      });
    }, onError: (error) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FailedScreenAchievement(
                    title: widget.achievement[Constants.taskTitleRef],
                  )));
    });
  }

  @override
  void initState() {
    if (mounted) {
      _listenToAchievementChanges();
    }
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
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
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AchievementList()));
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: FractionalOffset.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: _currentHeight * 0.2,
              ),
              Column(
                children: [
                  inactiveAchievementsLogo(),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: _currentWidth * 0.8,
                    child: Center(
                      child: Text(
                        Local.achievementStr +
                            " " +
                            widget.achievement[Constants.taskTitleRef],
                        style: CustomTextStyle
                            .achievementUnCompletedTitleTextStyle,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _currentHeight * 0.05,
              ),
              SizedBox(
                width: _currentWidth * 0.8,
                height: _currentWidth * 0.3,
                child: Center(
                  child: SingleChildScrollView(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    scrollDirection: Axis.vertical,
                    child: Text(
                      widget.achievement[Constants.taskDescriptionRef],
                      style: CustomTextStyle.defaultStyle
                          .copyWith(fontSize: _currentWidth * 0.062),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _currentHeight * 0.1,
              ),
              QrImage(
                data:
                    "${Constants.getScannedTypeRef}/${widget.guestCode}/${widget.achievementId}/${widget.achievement[Constants.taskTitleRef]}",
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: _currentWidth * 0.65,
              ),
              SizedBox(
                height: _currentHeight * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
