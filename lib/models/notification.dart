// ignore_for_file: unnecessary_this

class NotificationModel {
  int id;
  String image = "";
  String titre = "";
  String type = "0";
  String description = "";
  bool etat = false;

  bool isRead = false;
  String date = "";
  String readDate = "";

  NotificationModel(this.id, this.titre, this.description, this.isRead,
      this.date, this.readDate);

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(
      map['id'] ?? "",
      map['data']['title'] ?? "",
      map['data']['body'] ?? "",
      map['read_at'] == null,
      map['created_at'] ?? "",
      map['read_at'] ?? "",
    );
  }
}
