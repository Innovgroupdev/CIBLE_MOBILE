import 'package:cible/models/Event.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/models/notification.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/database.dart';

List<Notification> notifications = [
  // Notification(
  //     0,
  //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
  //     'titre0',
  //     'description0',
  //     'type0',
  //     false),
  // Notification(
  //     1,
  //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
  //     'titre1',
  //     'description1',
  //     'type1',
  //     false),
  // Notification(
  //     2,
  //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
  //     'titre2',
  //     'description2',
  //     'type2',
  //     false),
  // Notification(
  //     3,
  //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
  //     'titre3',
  //     'description3',
  //     'type3',
  //     false),
  // Notification(
  //     4,
  //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
  //     'titre4',
  //     'description4',
  //     'type4',
  //     false),
];

class NotificationDBcontroller {
  Future<void> insert(Notification notification) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM notification");
    final notification1 = Notification(
        5,
        'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
        'titre5',
        'description5',
        'type5',
        false);
    await db.insert('notification', notification1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(Notification notification) async {
    final Database db = await CibleDataBase().database;
    await db
        .delete('notification', where: "id = ?", whereArgs: [notification.id]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('notification');

    List<Notification> notification = List.generate(maps.length, (i) {
      return Notification.fromMap(maps[i]);
    });
    return notification;
  }
}
