import 'package:cible/database/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notification.dart';

class NotificationDBcontroller {
  Future<void> insert(/*Notification notification*/) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM notification");
    final notification1 = Notification(
        4,
        'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
        'titre4',
        'description4',
        'type4',
        false);
    int id = await db.insert('notification', notification1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('le id que je cherche ' + id.toString());
  }

  Future<void> delete(Notification notification) async {
    final Database db = await CibleDataBase().database;
    await db
        .delete('notification', where: "id = ?", whereArgs: [notification.id]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('notification');
    print('le map que je cherche ' + maps.toString());

    List<Notification> notification = List.generate(maps.length, (i) {
      return Notification.fromMap(maps[i]);
    });
    return notification;
  }
}
