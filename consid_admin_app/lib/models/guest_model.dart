import 'package:admin_app/models/guest_model/solved_achieve_model.dart';

import 'guest_model/guest_ticket_model.dart';
import 'guest_model/solved_secret_achieve_model.dart';

class GuestModel {
  final String id;
  final bool checkedIn;
  final bool claimed;
  final String email;
  final DateTime invited;
  final String name;
  final String phoneNr;

  final List<SolvedAchieveModel> solvedAchievements;
  final List<SolvedSecretAchieveModel> solvedSecretAchievements;
  final List<GuestTicketModel> tickets;

  GuestModel({
    required this.id,
    required this.checkedIn,
    required this.claimed,
    required this.email,
    required this.invited,
    required this.name,
    required this.phoneNr,
    required this.solvedAchievements,
    required this.solvedSecretAchievements,
    required this.tickets,
  });
}
