// import 'package:cible/database/database.dart';
// import 'package:sqflite/sqflite.dart';

// import '../models/notification.dart';

// class NotificationDBcontroller {
//   Future<void> insert(NotificationModel notification1) async {
//     final Database db = await CibleDataBase().database;
//     // final notification1 =
//     // NotificationModel(
//     //     4,
//     //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
//     //     'titre4',
//     //     'description4',
//     //     'type4',
//     //     false);

//     int id = await db.insert('notification', notification1.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//     print('le id que je cherche ' + notification1.etat.toString());
//   }

//   Future<void> update(NotificationModel notification) async {
//     final Database db = await CibleDataBase().database;
//     await db.update('notification', notification.toMap(),
//         where: "id = ?", whereArgs: [notification.id]);
//   }

//   Future<void> delete(NotificationModel notification) async {
//     final Database db = await CibleDataBase().database;
//     await db
//         .delete('notification', where: "id = ?", whereArgs: [notification.id]);
//   }

//   Future liste() async {
//     final Database db = await CibleDataBase().database;
//     final List<Map<String, dynamic>> maps = await db.query('notification');
//     //print('le map que je cherche ' + maps.toString());

//     List<NotificationModel> notification = List.generate(maps.length, (i) {
//       return NotificationModel.fromMap(maps[i]);
//     });
//     return notification;
//   }
// }
