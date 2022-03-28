import 'dart:math';
import 'package:admin_app/models/achieve_model.dart';
import 'package:admin_app/models/registration_model.dart';
import 'package:admin_app/models/secret_achieve_model.dart';
import 'package:admin_app/models/ticketType_model.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/event_info.dart';

// References
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

DocumentReference<Map<String, dynamic>> achievementReference =
    _fireStore.collection('event').doc('achievements');

CollectionReference<Map<String, dynamic>> _guestRef =
    _fireStore.collection('guests');

class Firebase {
  // ------------  Storage  ------------
  Future<String> getImageUrl(String fileName) async {
    return await _storage
        .ref()
        .child("images")
        .child(fileName)
        .getDownloadURL();
  }

  Future<dynamic> getImageObject(String fileName) async {
    return await _storage.ref().child("images").child(fileName).getData();
  }

  // ------------  FireStore  ------------
  Stream<QuerySnapshot<Object?>> getAllClaimedInvites() {
    return _guestRef
        .where('claimed', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getCheckedIn() {
    return _guestRef
        .where('claimed', isEqualTo: true)
        .where('checked_in', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getNotCheckedIn() {
    return _guestRef
        .where('claimed', isEqualTo: true)
        .where('checked_in', isEqualTo: false)
        .orderBy('name')
        .snapshots();
  }

  void addAchievement(BuildContext context, AchieveModel newAchievement) async {
    bool runOnlyIfTitleDoesntExist = true;

    await achievementReference
        .collection('types')
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) => {
                    // Never accept a new achievement with the same title as an existing one
                    if (doc.get('task_title').toString().toLowerCase().trim() ==
                        newAchievement.title.toString().toLowerCase().trim())
                      {runOnlyIfTitleDoesntExist = false}
                  }),
            });

    if (runOnlyIfTitleDoesntExist) {
      var document = achievementReference.collection("types").doc();

      await document
          .set(({
            "qr_code": newAchievement.qrCode + document.id,
            "task_description": newAchievement.description,
            "task_title": newAchievement.title,
            "task_type": newAchievement.type,
          }))
          .then((_) => {
                Navigator.pop(context),
                showAlertDialog(context, LocalVar.achieveCreated)
              })
          .catchError((error) =>
              showAlertDialog(context, LocalVar.errorAchieve, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.uniqueTitle, Colors.orange);
    }
  }

  Future<DocumentSnapshot> getSpecificGuest(String inviteId) async {
    return await _fireStore.collection("guests").doc(inviteId).get();
  }

  Future<DocumentSnapshot> getEventData() async {
    return await _fireStore.collection('event').doc('information').get();
  }

  Stream<QuerySnapshot<Object?>> getUnusedUserTickets(String userId) {
    return _fireStore
        .collection("guests")
        .doc(userId)
        .collection("tickets")
        .where('used', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getAchievementsScanQr() {
    return achievementReference
        .collection("types")
        .where('task_type', isEqualTo: "scan_qr")
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getUnusedInvites() {
    return _guestRef.where('claimed', isEqualTo: false).snapshots();
  }

  Future<void> updateGuest(BuildContext context, RegistrationModel regUser) {
    return _guestRef
        .doc(regUser.uID)
        .update({
          'name': regUser.name,
          'phone_nr': regUser.phone,
          'email': regUser.email,
          'claimed': true,
        })
        .then((_) => {
              Navigator.pop(context),
              showAlertDialog(
                  context,
                  "UserId ${regUser.uID} registered correctly",
                  Colors.lightGreen),
            })
        .catchError((error) =>
            showAlertDialog(context, LocalVar.registartionError, Colors.red));
  }

  // --------------- Functions -------------------

  dbHandleCheckin(BuildContext context, DocumentSnapshot<Object?> userData) {
    if (!userData['checked_in'] && userData['claimed']) {
      _guestRef
          .doc(userData.id)
          .update({
            'checked_in': true,
          })
          .then((_) => {
                Navigator.pop(context),
                showAlertDialog(
                    context,
                    LocalVar.user +
                        " ${userData['name']} " +
                        "\n" +
                        LocalVar.dbManually,
                    Colors.lightGreen),
              })
          .catchError((error) => {
                showAlertDialog(context, LocalVar.errorUserCheckin, Colors.red)
              });
    } else {
      showAlertDialog(context, LocalVar.needsRegister, Colors.red);
    }
  }

  dbHandleTicket(BuildContext context, String? userID, String? ticketId) {
    _guestRef
        .doc(userID)
        .collection('tickets')
        .doc(ticketId)
        .update({
          'used': true,
        })
        .then((_) => {
              Navigator.pop(context),
              showAlertDialog(
                  context,
                  LocalVar.promptMultiInput(userID, ticketId),
                  Colors.lightGreen),
            })
        .catchError((error) =>
            {showAlertDialog(context, LocalVar.errorUsingTicket, Colors.red)});
  }

  // ----------------------------------

  Stream<QuerySnapshot<Object?>> getSecretAchievements() {
    return achievementReference.collection("secrets").snapshots();
  }

  Stream<QuerySnapshot<Object?>> getNormalAchievements() {
    return achievementReference.collection("types").snapshots();
  }

  void addSecretAchievement(
      BuildContext context, SecretAchieveModel newAchievement) async {
    bool runOnlyIfDoesntExist = true;

    await achievementReference
        .collection('secrets')
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) => {
                    // Never accept a new achievement with the same title as an existing one
                    if (doc
                                .get('type_percent')
                                .toString()
                                .toLowerCase()
                                .trim() ==
                            newAchievement.percentage
                                .toString()
                                .toLowerCase()
                                .trim() &&
                        doc
                                .get('type_trigger')
                                .toString()
                                .toLowerCase()
                                .trim() ==
                            newAchievement.trigger
                                .toString()
                                .toLowerCase()
                                .trim())
                      {runOnlyIfDoesntExist = false}
                  }),
            });

    if (runOnlyIfDoesntExist) {
      achievementReference
          .collection("secrets")
          .add(({
            "type_trigger": newAchievement.trigger,
            "type_percent": newAchievement.percentage,
          }))
          .then((_) => {
                Navigator.pop(context),
                showAlertDialog(context, LocalVar.secretCreated)
              })
          .catchError((error) =>
              showAlertDialog(context, LocalVar.errorAchieve, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.alreadyExists, Colors.orange);
    }
  }

  void updateSecretAchievement(
      BuildContext context, SecretAchieveModel updatedAchievement) async {
    var chosenAchievement =
        achievementReference.collection('secrets').doc(updatedAchievement.id);

    if (chosenAchievement.toString().isNotEmpty) {
      await chosenAchievement
          .update(({
            "type_percent": updatedAchievement.percentage,
            "type_trigger": updatedAchievement.trigger,
          }))
          .then((_) => {showAlertDialog(context, LocalVar.achieveUpdated)})
          .catchError((error) =>
              showAlertDialog(context, LocalVar.errorAchieve, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.errorAchieve, Colors.red);
    }
  }

  void deleteAchievement(BuildContext context, String secretId, bool ifSecret) {
    var chosenAchievement = ifSecret
        ? achievementReference.collection('secrets').doc(secretId)
        : achievementReference.collection('types').doc(secretId);

    if (chosenAchievement.toString().isNotEmpty) {
      chosenAchievement
          .delete()
          .then((_) => {
                showAlertDialog(
                    context, LocalVar.achievementDeleted, Colors.lightGreen)
              })
          .catchError((error) =>
              showAlertDialog(context, LocalVar.errorAchieve, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.errorAchieve, Colors.red);
    }
  }

  void updateAchievement(
      BuildContext context, AchieveModel updatedAchievement) async {
    var chosenAchievement =
        achievementReference.collection('types').doc(updatedAchievement.id);

    if (chosenAchievement.toString().isNotEmpty) {
      var currentType = "";

      await chosenAchievement.get().then((querySnapshot) => {
            currentType =
                querySnapshot.get('task_type').toString().toLowerCase().trim()
          });

      //If scanType isnt empty and not the same as current
      (updatedAchievement.type != "" && updatedAchievement.type != currentType)
          ? await chosenAchievement
              .update(({
                "qr_code": updatedAchievement.type + "/" + chosenAchievement.id,
                "task_description": updatedAchievement.description,
                "task_title": updatedAchievement.title,
                "task_type": updatedAchievement.type,
              }))
              .then((_) => {showAlertDialog(context, LocalVar.achieveUpdated)})
              .catchError((error) =>
                  showAlertDialog(context, LocalVar.errorAchieve, Colors.red))
          : // Else - just update info, not scanType and QR
          await chosenAchievement
              .update(({
                "task_description": updatedAchievement.description,
                "task_title": updatedAchievement.title,
              }))
              .then((_) => {showAlertDialog(context, LocalVar.achieveUpdated)})
              .catchError((error) =>
                  showAlertDialog(context, LocalVar.errorAchieve, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.errorAchieve, Colors.red);
    }
  }

  void addTickets(BuildContext context, List<TicketTypeModel> modelList) async {
    final allGuests = await _guestRef.get();

    if (allGuests.size > 0) {
      allGuests.docs.forEach(
        (aGuest) => {
          modelList.forEach((aTicket) async {
            _guestRef
                .doc(aGuest.id)
                .collection('tickets')
                .add(({
                  "type": aTicket.type,
                  "used": false,
                }))
                .catchError((error) => showAlertDialog(
                    context, LocalVar.ticketCouldntAdd, Colors.red));
          }),
        },
      );
      showAlertDialog(context, LocalVar.promptInputAdded(LocalVar.tickets));
    } else {
      showAlertDialog(context, LocalVar.noUsersYetInvitesFirst, Colors.red);
    }
  }

  void addTicketToSpecificGuest(
      BuildContext context, String userID, TicketTypeModel ticketType) async {
    if (userID.isNotEmpty & ticketType.type.isNotEmpty) {
      final specificGuestTickets = _guestRef.doc(userID).collection('tickets');

      specificGuestTickets
          .add(({
            "type": ticketType.type,
            "used": false,
          }))
          .then((value) => showAlertDialog(context,
              LocalVar.promptInputAdded(LocalVar.ticket), Colors.lightGreen))
          .catchError((error) =>
              showAlertDialog(context, LocalVar.ticketCouldntAdd, Colors.red));
    } else {
      showAlertDialog(context, LocalVar.noUsersYetInvitesFirst, Colors.red);
    }
  }

  generateString(int length) {
    const characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    String result = "";
    const charactersLength = characters.length;
    for (int i = 0; i < length; i++) {
      result += characters[Random().nextInt(charactersLength)];
    }
    return result;
  }

  createInvites(List<TicketTypeModel> ticketList, int invitesNr) async {
    Set<String> uniqueRandoms = Set();

    /* Ensure that all are unique */
    while (uniqueRandoms.length < invitesNr) {
      var inviteCode = generateString(4);
      uniqueRandoms.add(inviteCode);
    }

    /* Push them onto the DB */
    uniqueRandoms.forEach((userID) => {
          _guestRef.doc(userID).set({
            "checked_in": false,
            "invited": DateTime.now(),
            "name": "",
            "email": "",
            "phone_nr": "",
            "claimed": false,
          }).then((value) => ticketList.forEach((singleTicket) => {
                for (int i = 0; i < singleTicket.amount; i++)
                  {
                    _fireStore
                        .collection('guests')
                        .doc(userID)
                        .collection('tickets')
                        .add({
                      "type": singleTicket.type,
                      "used": false,
                    })
                  }
              }))
        });
  }
} // End of class
