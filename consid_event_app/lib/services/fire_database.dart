import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/achievement.dart';
import 'package:consid_event_app/models/guest.dart';
import 'package:consid_event_app/models/registration.dart';
import 'package:consid_event_app/models/secret.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement/achievement_types/secret_type.dart';
import 'package:consid_event_app/screens/failed/failed_screen_scanned.dart';
import 'package:consid_event_app/screens/not_checked_in/count_down.dart';
import 'package:consid_event_app/screens/not_checked_in/its_time_screen.dart';
import 'package:consid_event_app/screens/not_checked_in/rsvp_register.dart';
import 'package:consid_event_app/screens/success/success_screen_scanned.dart';
import 'package:consid_event_app/screens/success/success_screen_ticket.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/checked_in/welcome_splach_screen.dart';

FirebaseFirestore _fireStore = FirebaseFirestore.instance;
CollectionReference _guestRef = _fireStore.collection(Constants.guestsRef);
CollectionReference _eventRef = _fireStore.collection(Constants.eventRef);

class FireDatabase {
  /* 
    ----------  Event ------------ 
  */

  Future<String> getCurrentEventDateStr(BuildContext context) async {
    var snap = await _eventRef.doc(Constants.informationRef).get();

    if (snap.exists) {
      try {
        Timestamp timestamp = snap.get(Constants.startDateRef);
        return timestamp.seconds.toString();
      } on StateError catch (_) {
        // State error - no data in field
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
        return Local.tba;
      }
    } else {
      return Local.tba;
    }
  }

  Future<DocumentSnapshot<Object?>?> getEventSnapshoot() async {
    return await _eventRef.doc(Constants.informationRef).get();
  }

  Future<int> numberOfAchievementsInEvent() async {
    var snap = await _fireStore
        .collection(Constants.eventRef)
        .doc(Constants.achievementsRef)
        .collection(Constants.typesRef)
        .get();

    return snap.docs.length;
  }

  /* 
    ----------  Invitation ------------ 
  */
  Future<void> handleInvitationCode(
      BuildContext context, String guestCode) async {
    var snapshot = await _guestRef.doc(guestCode).get();
    if (snapshot.exists) {
      try {
        bool claimed = snapshot.get(Constants.claimedRef);
        bool checkedIn = snapshot.get(Constants.checkedInRef);
        if (claimed) {
          _setCurrentState(context, guestCode);
          String _startDateStr = await getCurrentEventDateStr(context);
          bool _eventStarted = getTimeDifference(_startDateStr) <= 0;

          if (_eventStarted && checkedIn) {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const WelcomeSplashScreen()));
          } else if (_eventStarted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ItsTimeScreen(
                          guestCode: guestCode,
                        )));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const CountDown()));
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RsvpRegister(guestCode: guestCode)));
        }
      } on StateError catch (_) {
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
      }
    } else {
      showAlertDialog(context, Local.alertDialogInvalidCode, Colors.orange);
    }
  }

  /* 
    ----------  Guest ------------ 
  */

  Stream<DocumentSnapshot<Map<String, dynamic>>> getGuestQuerySnapshot(
      String guestCode) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .snapshots();
  }

  Future<void> updateGuest(BuildContext context, Registration regUser) async {
    var _startDateStr = await getCurrentEventDateStr(context);
    _guestRef
        .doc(regUser.uID)
        .update({
          'name': regUser.name,
          'phone_nr': regUser.phone,
          'email': regUser.email,
          'claimed': true,
        })
        .then((_) => {
              _setCurrentState(context, regUser.uID),
            })
        .then((_) => {
              Navigator.pop(context),
              if (getTimeDifference(_startDateStr) <= 0)
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItsTimeScreen(
                                guestCode: regUser.uID,
                              )))
                }
              else
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CountDown()))
                }
            })
        .catchError((error) =>
            showAlertDialog(context, Local.registartionError, Colors.red));
  }

  Future<bool> checkCurrentGuestCode(
      BuildContext context, String? guestCode) async {
    var snap = await _guestRef.doc(guestCode).get();
    if (snap.exists) {
      try {
        bool claimed = snap.get(Constants.claimedRef);
        if (claimed) {
          return Future<bool>.value(true);
        }
      } on StateError catch (_) {
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
        return Future<bool>.value(false);
      }
    }
    return Future<bool>.value(false);
  }

  Future<bool> checkIfCurrentGuestIsCheckedIn(
      BuildContext context, String? guestCode) async {
    var snap = await _guestRef.doc(guestCode).get();
    if (snap.exists) {
      try {
        bool checkedIn = snap.get(Constants.checkedInRef);
        if (checkedIn) {
          return Future<bool>.value(true);
        }
      } on StateError catch (_) {
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
        return Future<bool>.value(false);
      }
    }
    return Future<bool>.value(false);
  }

  Future<String> getGuestName(BuildContext context, String? guestCode) async {
    DocumentSnapshot<Object?> snap = await _guestRef.doc(guestCode).get();
    if (snap.exists) {
      try {
        return snap.get('name');
      } on StateError catch (_) {
        showAlertDialog(context, Constants.somethingWentWrong, Colors.red);
        return Constants.somethingWentWrong;
      }
    } else {
      return Constants.somethingWentWrong;
    }
  }

  /* 
    ----------  Tickets ------------ 
  */

  Stream<QuerySnapshot<Object?>> getGuestTickets(String guestCode) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.ticketsRef)
        .orderBy(Constants.usedRef, descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getNumberOfAvailableTickets(String guestCode) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.ticketsRef)
        .where(Constants.usedRef, isEqualTo: false)
        .snapshots();
  }

  Future<int> getNumberOfUsedTicketsForGuest(String? guestCode) async {
    var snap = await _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.ticketsRef)
        .where(Constants.usedRef, isEqualTo: true)
        .get();

    return snap.docs.length;
  }

  Future<int> getNumberOfTicketsForGuest(String? guestCode) async {
    var snap = await _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.ticketsRef)
        .get();

    return snap.docs.length;
  }

  Stream<QuerySnapshot> getGuestSpecificTicket(
      String guestCode, String ticketId) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.ticketsRef)
        .where(FieldPath.documentId, isEqualTo: ticketId)
        .snapshots();
  }

  void giveAwayTicket(BuildContext context, String currentGuestCode,
      String scannedGuestCode, String ticketCode, String type) {
    // Give ticket to scanned guest
    _guestRef
        .doc(scannedGuestCode)
        .collection(Constants.ticketsRef)
        .add({
          'type': type,
          'used': false,
        })
        .then((_) => {
              // Delete the ticket from the guest who gave away
              _guestRef
                  .doc(currentGuestCode)
                  .collection(Constants.ticketsRef)
                  .doc(ticketCode)
                  .delete()
                  .catchError((error) => showAlertDialog(
                      context, Constants.somethingWentWrong, Colors.red))
            })
        .then((_) => _secretTicketTypeTrigger(context, currentGuestCode))
        .catchError((error) =>
            showAlertDialog(context, Constants.somethingWentWrong, Colors.red));
  }

  /* 
    ----------  Secret Achievements ------------ 
  */

  Future<QuerySnapshot<Map<String, dynamic>>> getEventSecretAchievements() {
    return _fireStore
        .collection(Constants.eventRef)
        .doc(Constants.achievementsRef)
        .collection(Constants.secretsRef)
        .get();
  }

  Stream<QuerySnapshot<Object?>> getGuestSecretAchievements(String? guestCode) {
    return _guestRef
        .doc(guestCode)
        .collection(Constants.secretsRef)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getGuestSecretAchievementsList(
      String? guestCode) {
    return _guestRef.doc(guestCode).collection(Constants.secretsRef).get();
  }

  Future<bool> guestGotSecretAchievement(String? guestCode) async {
    var snap =
        await _guestRef.doc(guestCode).collection(Constants.secretsRef).get();
    return snap.docs.isNotEmpty;
  }

  void checkIfSecretAchievementTrigger(
      BuildContext context, String guestCode, String type) {
    if (type == Constants.achievementsRef) {
      _secretAchievemenTypeTrigger(context, guestCode);
    } else if (type == Constants.ticketsRef) {
      _secretTicketTypeTrigger(context, guestCode);
    }
  }

  void _secretAchievemenTypeTrigger(
      BuildContext context, String guestCode) async {
    int _numberOfEventAchievements = await numberOfAchievementsInEvent();
    var _secretEventAchievResult = await getEventSecretAchievements();
    var _guestSecretAchievResult =
        await getGuestSecretAchievementsList(guestCode);
    int _numberOfGuestSolvedAchievements =
        await getNumberOfAchievementsForGuest(guestCode);

    if (_numberOfEventAchievements > 0 && _secretEventAchievResult.size > 0) {
      try {
        // Remove not wanted type
        var _secretEventAchievements = _secretEventAchievResult.docs;
        _secretEventAchievements.removeWhere((element) =>
            element[Constants.typeTriggerRef] != Constants.achievementsRef);

        // Remove already given achievement avoid double checks
        var _guestSecretAchievements = _guestSecretAchievResult.docs;
        for (var guestAchieve in _guestSecretAchievements) {
          _secretEventAchievements
              .removeWhere((element) => element.id == guestAchieve.id);
        }

        for (var secret in _secretEventAchievements) {
          int percentage = int.parse(secret[Constants.typePercentRef]);
          int currentCeilPercent = (_numberOfGuestSolvedAchievements /
                  _numberOfEventAchievements *
                  100)
              .ceil();
          int currentFloorPercent = (_numberOfGuestSolvedAchievements /
                  _numberOfEventAchievements *
                  100)
              .floor();

          // Round up to 10s
          currentCeilPercent = ((currentCeilPercent / 10.0).ceil() * 10);
          // Round down to 10s
          currentFloorPercent = ((currentFloorPercent / 10.0).floor() * 10);

          switch (percentage) {
            case 100:
              if (_numberOfEventAchievements ==
                  _numberOfGuestSolvedAchievements) {
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.achievementsRef);
              }
              break;
            case 50:
              if ((percentage == currentCeilPercent &&
                  percentage == currentFloorPercent)) {
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.achievementsRef);
              }
              break;
            default:
              if ((percentage <= currentCeilPercent &&
                      percentage >= currentFloorPercent) ||
                  // If percentage is between calculated or both are bigger
                  // If Bigger it missed the trigger percentage
                  (percentage < currentCeilPercent &&
                      percentage < currentFloorPercent)) {
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.achievementsRef);
              }
          }
        }
      } on StateError catch (_) {
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
      }
    }
  }

  void _secretTicketTypeTrigger(BuildContext context, String guestCode) async {
    int _numberOfGuestTickets = await getNumberOfTicketsForGuest(guestCode);
    var _secretEventAchievResult = await getEventSecretAchievements();
    var _guestSecretAchievResult =
        await getGuestSecretAchievementsList(guestCode);
    int _numberOfGuestUsedTickets =
        await getNumberOfUsedTicketsForGuest(guestCode);
    bool newAchievement = false;

    if (_numberOfGuestTickets > 0 && _secretEventAchievResult.size > 0) {
      try {
        // Remove not wanted type
        var _secretEventAchievements = _secretEventAchievResult.docs;
        _secretEventAchievements.removeWhere((element) =>
            element[Constants.typeTriggerRef] != Constants.ticketsRef);
        // Remove already given achievement avoid double checks
        var _guestSecretAchievements = _guestSecretAchievResult.docs;
        for (var guestAchieve in _guestSecretAchievements) {
          _secretEventAchievements
              .removeWhere((element) => element.id == guestAchieve.id);
        }
        _secretEventAchievements.sort(((a, b) => a[Constants.typePercentRef]
            .compareTo(b[Constants.typePercentRef])));

        for (var secret in _secretEventAchievements) {
          int percentage = int.parse(secret[Constants.typePercentRef]);
          int currentCeilPercent =
              (_numberOfGuestUsedTickets / _numberOfGuestTickets * 100).ceil();
          int currentFloorPercent =
              (_numberOfGuestUsedTickets / _numberOfGuestTickets * 100).floor();

          // Round up to 10s
          currentCeilPercent = ((currentCeilPercent / 10.0).ceil() * 10);
          // Round down to 10s
          currentFloorPercent = ((currentFloorPercent / 10.0).floor() * 10);

          switch (percentage) {
            case 100:
              if (_numberOfGuestTickets == _numberOfGuestUsedTickets) {
                newAchievement = true;
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.ticketsRef);
              }
              break;
            case 50:
              if ((percentage == currentCeilPercent &&
                  percentage == currentFloorPercent)) {
                newAchievement = true;
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.ticketsRef);
              }
              break;
            default:
              if ((percentage <= currentCeilPercent &&
                      percentage >= currentFloorPercent) ||
                  // If percentage is between calculated or both are bigger
                  // If Bigger = Gave away a ticket and missed the trigger percentage
                  (percentage <= currentCeilPercent &&
                      percentage < currentFloorPercent)) {
                newAchievement = true;
                _addSecretAchievement(context, guestCode, percentage.toString(),
                    secret.id, Constants.ticketsRef);
              }
          }
        }
      } on StateError catch (_) {
        showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
      }
    }
    if (!newAchievement) {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SuccessScreenTicket()));
    }
  }

  Future<void> _addSecretAchievement(BuildContext context, String guestCode,
      String currentPercent, String achievementId, String trigger) {
    Timestamp currenTime = Timestamp.now();

    return _guestRef
        .doc(guestCode)
        .collection(Constants.secretsRef)
        .doc(achievementId)
        .set({
          'solved': currenTime,
          'type_percent': currentPercent,
          'type_trigger': trigger,
        })
        .then((_) => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecretType(
                          achievement: Secret(
                              trigger: trigger,
                              percent: currentPercent,
                              solved: getTimeStampAsString(currenTime)))))
            })
        .catchError((error) =>
            showAlertDialog(context, Local.registartionError, Colors.red));
  }

  Future<void> _addTriggerdScannedAchievement(BuildContext context) {
    Timestamp currenTime = Timestamp.now();
    return getCurrentState().then((guestCode) {
      _guestRef
          .doc(guestCode)
          .collection(Constants.secretsRef)
          .add({
            'solved': currenTime,
            'type_percent': Constants.scanTriggerValue.toString(),
            'type_trigger': Constants.scannedRef,
          })
          .then((_) => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecretType(
                            achievement: Secret(
                                trigger: Constants.scannedRef,
                                percent: Constants.scanTriggerValue.toString(),
                                solved: getTimeStampAsString(currenTime)))))
              })
          .catchError((error) =>
              showAlertDialog(context, Local.registartionError, Colors.red));
    });
  }

  /* 
    ----------  Achievements ------------ 
  */

  Stream<QuerySnapshot<Object?>> getEventAchievements() {
    return _fireStore
        .collection(Constants.eventRef)
        .doc(Constants.achievementsRef)
        .collection(Constants.typesRef)
        .orderBy(Constants.taskTitleRef, descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getAchievementByIdAsStream(
      BuildContext context, String achievementId) {
    return _fireStore
        .collection(Constants.eventRef)
        .doc(Constants.achievementsRef)
        .collection(Constants.typesRef)
        .where(FieldPath.documentId, isEqualTo: achievementId)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getGuestAchievements(String? guestCode) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.achievementsRef)
        .snapshots();
  }

  Future<int> getNumberOfAchievementsForGuest(String? guestCode) async {
    var snap = await _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.achievementsRef)
        .get();

    return snap.docs.length;
  }

  Stream<QuerySnapshot<Object?>> getGuestAchievementById(
      String? guestCode, String achievementId) {
    return _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.achievementsRef)
        .where(FieldPath.documentId, isEqualTo: achievementId)
        .snapshots();
  }

  void checkIfGuestHaveScannedAchievement(
      BuildContext context, String? guestCode) {
    _fireStore
        .collection(Constants.guestsRef)
        .doc(guestCode)
        .collection(Constants.secretsRef)
        .where(Constants.typeTriggerRef, isEqualTo: Constants.scannedRef)
        .get()
        .then((value) {
      // If guest deleted the app the counter reset to 0 but already have achievement, avoid double achievement
      if (value.docs.isNotEmpty) {
        _setCurrentNumberOfScannedState(
            context, Constants.scanTriggerValue + 1);
      }
    });
  }

/* When achievement is depending on another guest to scan the QR code */
  Future<Set> handleScanGuestAchievement(BuildContext context,
      String achievementId, String guestCode, String title) {
    checkIfGuestHaveScannedAchievement(context, guestCode);
    return _guestRef
        .doc(guestCode)
        .collection(Constants.achievementsRef)
        .doc(achievementId)
        .set({Constants.solvedRef: DateTime.now()})
        .then((_) => getCurrentNumberOfScannedState().then((value) {
              if (value == null) {
                _setCurrentNumberOfScannedState(context, 1);
              } else if (value <= Constants.scanTriggerValue) {
                _setCurrentNumberOfScannedState(context, value + 1);
              }
            }).catchError((error) => showAlertDialog(
                context, Constants.somethingWentWrong, Colors.red)))
        .then((_) => {
              getCurrentNumberOfScannedState().then((value) {
                if (value == Constants.scanTriggerValue) {
                  _addTriggerdScannedAchievement(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuccessScreenScanned()));
                }
              }).catchError((error) => showAlertDialog(
                  context, Constants.somethingWentWrong, Colors.red))
            })
        .catchError((error) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FailedScreenScanned()));
        });
  }

/* When a guest scans a QR code that is not another guest */
  Future<Set> handleScanQrAchievement(
      BuildContext context,
      String achievementId,
      String guestCode,
      Map<String, dynamic> achievement) {
    return _guestRef
        .doc(guestCode)
        .collection(Constants.achievementsRef)
        .doc(achievementId)
        .set({Constants.solvedRef: DateTime.now()})
        .then((_) => {
              Achievement(
                uID: achievementId,
                title: achievement[Constants.taskTitleRef],
                description: achievement[Constants.taskDescriptionRef],
                solved: Timestamp.now(),
              )
            })
        .catchError((error) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FailedScreenScanned()));
        });
  }

  /* 
    ----------  LeaderBoard ------------ 
  */

  Future<List<Object?>> getEventLeaderBoard() {
    return _guestRef.get().then((guests) => Future.wait(
        [for (var guest in guests.docs) getGuestInformation(guest)]));
  }

  /* Stream<List<Object?>> getEventLeaderBoard() {
    return _guestRef.snapshots().asyncMap((guests) => Future.wait(
        [for (var guest in guests.docs) getGuestInformation(guest)]));
  }*/

  getGuestInformation(QueryDocumentSnapshot<Object?> guest) async {
    final querySnapshot = await _guestRef
        .doc(guest.id)
        .collection(Constants.achievementsRef)
        .get();

    var lastAchievement = DateTime.now().subtract(const Duration(days: 365));

    for (var object in querySnapshot.docs) {
      var dateTime = object.data()[Constants.solvedRef].toDate();

      if (dateTime.isAfter(lastAchievement)) {
        lastAchievement = dateTime;
      }
    }
    return Guest(
        uID: guest.id,
        name: guest['name'],
        completedAchievments: querySnapshot.size,
        lastAchievement: lastAchievement);
  }

  /* 
    ----------  SharedPreferences ------------ 
  */

  Future<void> _setCurrentState(BuildContext context, String guestCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.keySharPref, guestCode);
  }

  Future<String?> getCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.keySharPref);
  }

  Future<void> _setCurrentNumberOfScannedState(
      BuildContext context, int counter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.keyScannedSharPref, counter);
  }

  Future<int?> getCurrentNumberOfScannedState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.keyScannedSharPref);
  }
}
