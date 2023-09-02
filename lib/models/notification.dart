// ignore_for_file: unnecessary_this

import 'package:cible/helpers/dateHelper.dart';

class NotificationModel {
  String id;
  String titre = "";
  String description = "";

  bool isRead = false;
  String date = "";
  String readDate = "";

  NotificationModel(this.id, this.titre, this.description, this.isRead,
      this.date, this.readDate);

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(
      map['id'],
      map['data']['title'] ?? "",
      map['data']['body'] ?? "",
      map['read_at'] != null,
      DateConvertisseur().formatDateForNotifications(map['created_at'] ?? ""),
      DateConvertisseur().formatDateForNotifications(map['read_at'] ?? ""),
    );
  }
}
