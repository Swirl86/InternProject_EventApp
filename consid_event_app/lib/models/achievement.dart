import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  final String uID;
  final String title;
  final String description;
  final Timestamp solved;

  Achievement(
      {required this.uID,
      required this.title,
      required this.description,
      required this.solved});
}
