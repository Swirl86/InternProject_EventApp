class Guest {
  final String? uID;
  final String name;
  final int completedAchievments;
  final DateTime lastAchievement;

  Guest(
      {required this.uID,
      required this.name,
      required this.completedAchievments,
      required this.lastAchievement});
}
