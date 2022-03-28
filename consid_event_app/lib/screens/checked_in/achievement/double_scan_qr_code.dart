import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/achievement.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/failed/failed_screen_achievement.dart';
import 'package:consid_event_app/screens/success/success_screen_achievement.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoubleScanQr extends StatefulWidget {
  final String guestCode;
  final String achievementId;
  final Map<String, dynamic> achievement;
  const DoubleScanQr(
      {Key? key,
      required this.guestCode,
      required this.achievementId,
      required this.achievement})
      : super(key: key);

  @override
  _DoubleScanQrState createState() => _DoubleScanQrState();
}

class _DoubleScanQrState extends State<DoubleScanQr> {
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
        Navigator.pushReplacement(
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
              Navigator.pop(context, 'Returned');
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: _currentHeight * 0.05,
          ),
          Center(
            child: Text(
              Local.getScannedPromp,
              style: CustomTextStyle.mediumTitleText
                  .copyWith(fontSize: _currentWidth * 0.12),
            ),
          ),
          SizedBox(
            height: _currentHeight * 0.1,
          ),
          SizedBox(
            width: _currentWidth * 0.8,
            height: _currentWidth * 0.8,
            child: FittedBox(
              fit: BoxFit.fill,
              child: QrImage(
                //Data order = type/guestCode/achievementId/taskTitle
                data:
                    "${Constants.doubleScanTypeRef}/${widget.guestCode}/${widget.achievementId}/${widget.achievement[Constants.taskTitleRef]}",
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: _currentWidth * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
