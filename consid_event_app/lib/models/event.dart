import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final Timestamp startDate;
  final Timestamp endDate;

  static Event? _instance;

  Event._internal(
      {required this.title,
      required this.description,
      required this.startDate,
      required this.endDate});

  static Event? get instance => _instance;

  factory Event(
      {required String title,
      required String description,
      required Timestamp startDate,
      required Timestamp endDate}) {
    if (title != _instance?.title) {
      _instance = Event._internal(
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate);
    }

    return _instance!;
  }
}
