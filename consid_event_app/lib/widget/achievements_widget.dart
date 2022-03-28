import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/widget/reusables/achievements.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:flutter/material.dart';

class AchievementsWidget extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final String guestCode;
  final String type;

  const AchievementsWidget(
      {Key? key,
      required this.snapshot,
      required this.guestCode,
      required this.type})
      : super(key: key);
  @override
  _AchievementsWidgetState createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  late StreamSubscription<QuerySnapshot<Object?>> streamSubscription;
  FireDatabase db = FireDatabase();
  List<QueryDocumentSnapshot<Object?>> _guestAchievements =
      <QueryDocumentSnapshot<Object?>>[];
  List<QueryDocumentSnapshot<Object?>> _guestSecretAchievements =
      <QueryDocumentSnapshot<Object?>>[];
  bool shouldKeepAlive = true;

  void _listenOnGuestAchievements() {
    streamSubscription =
        db.getGuestAchievements(widget.guestCode).listen((data) {
      setState(() {
        _guestAchievements = data.docs;
      });
    });
  }

  void _getSecretAchievements() {
    db.getGuestSecretAchievementsList(widget.guestCode).then((data) {
      setState(() {
        _guestSecretAchievements = data.docs;
      });
    });
  }

  @override
  void initState() {
    _listenOnGuestAchievements();
    _getSecretAchievements();
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "secret"
        ? _getSecretAchievementWidget()
        : _getAchievementWidget();
  }

  String solvedAchievementDate(String id) {
    for (var element in _guestAchievements) {
      if (element.id == id) {
        return getTimeStampAsString(element[Constants.solvedRef]);
      }
    }
    return Constants.empty;
  }

  String solvedSecretAchievementDate(String id) {
    for (var element in _guestSecretAchievements) {
      if (element.id == id) {
        return getTimeStampAsString(element[Constants.solvedRef]);
      }
    }
    return Constants.empty;
  }

  _getSecretAchievementWidget() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: (1 / .7),
      children: [
        ...widget.snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
              title: getSecretAchievements(
                  context, data, solvedSecretAchievementDate(document.id)));
        }).toList()
      ],
    );
  }

  _getAchievementWidget() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: (1 / .8),
      children: [
        ...widget.snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: getAchievements(context, document.id, data, widget.guestCode,
                solvedAchievementDate(document.id)),
          );
        }).toList(),
      ],
    );
  }
}
