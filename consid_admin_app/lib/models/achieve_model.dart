class AchieveModel {
  final String? id;
  final String qrCode;
  final String description;
  final String title;
  final String type;

  AchieveModel(
      {required this.qrCode,
      required this.description,
      required this.title,
      required this.type,
      this.id});
}
