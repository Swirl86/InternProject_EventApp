import 'package:admin_app/models/achieve_model.dart';
import 'package:admin_app/models/event_info.dart';
import 'package:admin_app/models/guest_model.dart';
import 'package:admin_app/models/guest_model/guest_ticket_model.dart';
import 'package:admin_app/models/guest_model/solved_achieve_model.dart';
import 'package:admin_app/models/guest_model/solved_secret_achieve_model.dart';
import 'package:admin_app/models/secret_achieve_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// References
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

dynamic _referenceToOrigin = _fireStore;
//.collection('old_events_temp1')
//.doc('20220311_17:30'); //default is _fireStore (firebase root)
String backupCollectionName =
    'old_events'; // name of backup root. Default is old_events

// Base Reference
var _removalRoot = _fireStore;

class NewEvent {
  Future<void> setEventInfo(EventInfo newEvent) async {
    // --- Event information -----

    await _referenceToOrigin.collection('event').doc('information').set({
      'description': newEvent.description,
      'start_date': newEvent.startDate,
      'end_date': newEvent.endDate,
      'title': newEvent.title,
    });
  }

  Future<void> eraseFormerData() async {
    // -------- Event info removal --------
    final WriteBatch eventBatch = FirebaseFirestore.instance.batch();

    await _removalRoot.collection('event').get().then((snap) async {
      for (var doc in snap.docs) {
        eventBatch.delete(doc.reference);
      }
    });

    await _removalRoot
        .collection('event')
        .doc('achievements')
        .collection('types')
        .get()
        .then((snap) async {
      for (var doc in snap.docs) {
        eventBatch.delete(doc.reference);
      }
    });

    await _removalRoot
        .collection('event')
        .doc('achievements')
        .collection('secrets')
        .get()
        .then((snap) async {
      for (var doc in snap.docs) {
        eventBatch.delete(doc.reference);
      }
    });

    // execute the batch
    await eventBatch.commit();

    // -- End of Event info removal ---------

    _removalRoot.collection('guests').get().then((value) {
      value.docs.forEach((aGuest) {
        // Removal of tickets
        var ticketRef = _removalRoot
            .collection('guests')
            .doc(aGuest.id)
            .collection('tickets');

        ticketRef.get().then((tickets) {
          tickets.docs.forEach((aTicket) {
            ticketRef.doc(aTicket.id).delete();
          });
        });

        // Removal of achievements
        var achieveRef = _removalRoot
            .collection('guests')
            .doc(aGuest.id)
            .collection('achievements');

        achieveRef.get().then((achievements) {
          achievements.docs.forEach((anAchieve) {
            achieveRef.doc(anAchieve.id).delete();
          });
        });

        // Removal of secrets
        var secretRef = _removalRoot
            .collection('guests')
            .doc(aGuest.id)
            .collection('secrets');

        secretRef.get().then((secrets) {
          secrets.docs.forEach((aSecret) {
            secretRef.doc(aSecret.id).delete();
          });
        });

        // Removal of userInfo
        var usersRef = _removalRoot.collection('guests');

        usersRef.get().then((secrets) {
          secrets.docs.forEach((singleGuest) {
            usersRef.doc(singleGuest.id).delete();
          });
        });
      });
    });
  }

  Future<void> backupFormerEvent() async {
    String eventName;
    dynamic _referenceToBackup; //Reference to the new db-path to backup to

    // --- Event information -----

    var description = '';
    DateTime endDate = DateTime.fromMicrosecondsSinceEpoch(0);
    DateTime startDate = DateTime.fromMicrosecondsSinceEpoch(0);
    var title = '';

    await _referenceToOrigin
        .collection('event')
        .doc('information')
        .get()
        .then((data) {
      description = data.get('description');
      endDate = data.get('end_date').toDate();
      startDate = data.get('start_date').toDate();
      title = data.get('title');
    });

    eventName = DateFormat('yyyyMMdd_HH:mm').format(startDate);
    _referenceToBackup =
        _fireStore.collection(backupCollectionName).doc(eventName);

    await _referenceToBackup.collection('event').doc('information').set({
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'title': title,
    });

    // --- Event achievements -----
    // Secret
    List<SecretAchieveModel> secretAchievements = [];

    await _referenceToOrigin
        .collection('event')
        .doc('achievements')
        .collection('secrets')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        SecretAchieveModel thisSecretAchievement = SecretAchieveModel(
            id: element.id,
            trigger: element.get('type_trigger'),
            percentage: element.get('type_percent'));

        secretAchievements.add(thisSecretAchievement);
      });
    });

    secretAchievements.forEach((element) async {
      await _referenceToBackup
          .collection('event')
          .doc('achievements')
          .collection('secrets')
          .doc(element.id)
          .set({
        'type_trigger': element.trigger,
        'type_percent': element.percentage,
      });
    });

    // Regular achievements
    List<AchieveModel> regularAchievements = [];

    await _referenceToOrigin
        .collection('event')
        .doc('achievements')
        .collection('types')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        AchieveModel thisAchievement = AchieveModel(
          id: element.id,
          qrCode: element.get('qr_code'),
          description: element.get('task_description'),
          title: element.get('task_title'),
          type: element.get('task_type'),
        );

        regularAchievements.add(thisAchievement);
      });
    });

    regularAchievements.forEach((element) async {
      await _referenceToBackup
          .collection('event')
          .doc('achievements')
          .collection('types')
          .doc(element.id)
          .set({
        'qr_code': element.qrCode,
        'task_description': element.description,
        'task_title': element.title,
        'task_type': element.type,
      });
    });

    // --- Guests ---------------------------------------------<<<<<

    List<GuestModel> guests = [];

    await _referenceToOrigin.collection('guests').get().then((allGuests) async {
      allGuests.docs.forEach((singleGuest) {
        List<SolvedAchieveModel> solvedAchievements = [];
        List<SolvedSecretAchieveModel> solvedSecretAchievements = [];
        List<GuestTicketModel> tickets = [];

        /* Loop all singleGuest solved achievements */
        _referenceToOrigin
            .collection('guests')
            .doc(singleGuest.id)
            .collection('achievements')
            .get()
            .then((singleGuestAchievements) {
          singleGuestAchievements.docs.forEach((singleAchieve) {
            SolvedAchieveModel thisSolvedAchievement = SolvedAchieveModel(
                id: singleAchieve.id,
                solved: singleAchieve.get('solved').toDate());

            solvedAchievements.add(thisSolvedAchievement);
          });
        });

        /* Loop all singleGuest solved secret achievements */
        _referenceToOrigin
            .collection('guests')
            .doc(singleGuest.id)
            .collection("secrets")
            .get()
            .then((singleGuestSecretAchievements) {
          for (var solvedAchievement in singleGuestSecretAchievements.docs) {
            SolvedSecretAchieveModel thisSolvedSecretAchievement =
                SolvedSecretAchieveModel(
                    id: solvedAchievement.id,
                    typePercent: solvedAchievement.get('type_percent'),
                    typeTrigger: solvedAchievement.get('type_trigger'),
                    solved: solvedAchievement.get('solved').toDate());

            solvedSecretAchievements.add(thisSolvedSecretAchievement);
          }
        });
        /* Loop all singleGuest tickets */
        _referenceToOrigin
            .collection('guests')
            .doc(singleGuest.id)
            .collection("tickets")
            .get()
            .then((singleGuestTickets) {
          for (var singleGuestTicket in singleGuestTickets.docs) {
            GuestTicketModel thisGuestTicketModel = GuestTicketModel(
              id: singleGuestTicket.id,
              type: singleGuestTicket.get('type'),
              used: singleGuestTicket.get('used'),
            );

            tickets.add(thisGuestTicketModel);
          }
        });

        GuestModel thisGuest = GuestModel(
          id: singleGuest.id,
          checkedIn: singleGuest.get('checked_in'),
          claimed: singleGuest.get('claimed'),
          email: singleGuest.get('email'),
          invited: singleGuest.get('invited').toDate(),
          name: singleGuest.get('name'),
          phoneNr: singleGuest.get('phone_nr'),
          solvedAchievements: solvedAchievements,
          solvedSecretAchievements: solvedSecretAchievements,
          tickets: tickets,
        );

        guests.add(thisGuest);
      });
    }); // All getting data for guests done <------

    /* Set backup data */
    guests.forEach((singleGuest) async {
      await _referenceToBackup.collection('guests').doc(singleGuest.id).set({
        "checked_in": singleGuest.checkedIn,
        "claimed": singleGuest.claimed,
        "email": singleGuest.email,
        "invited": singleGuest.invited,
        "name": singleGuest.name,
        "phone_nr": singleGuest.phoneNr,
      });
      singleGuest.tickets.forEach((singleTicket) async {
        await _referenceToBackup
            .collection('guests')
            .doc(singleGuest.id)
            .collection('tickets')
            .doc(singleTicket.id)
            .set({
          "type": singleTicket.type,
          "used": singleTicket.used,
        });
      });
      singleGuest.solvedAchievements.forEach((singleAchieve) async {
        await _referenceToBackup
            .collection('guests')
            .doc(singleGuest.id)
            .collection('achievements')
            .doc(singleAchieve.id)
            .set({
          "solved": singleAchieve.solved,
        });
      });
      singleGuest.solvedSecretAchievements.forEach((singleSecret) async {
        await _referenceToBackup
            .collection('guests')
            .doc(singleGuest.id)
            .collection('secrets')
            .doc(singleSecret.id)
            .set({
          "type_percent": singleSecret.typePercent,
          "type_trigger": singleSecret.typeTrigger,
          "solved": singleSecret.solved
        });
      });
    });
  }
}
