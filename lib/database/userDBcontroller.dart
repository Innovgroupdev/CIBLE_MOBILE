import 'package:cible/database/database.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDBcontroller {
  Future<void> insert(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM user");
    await db.insert('user', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    await db.update('user', user.toMap(),
        where: "email1 = ? OR tel1 = ?", whereArgs: [user.email1, user.tel1]);
  }

  Future<void> delete(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    await db.delete('user', where: "email = ?", whereArgs: [user.email1]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('user');

    List<DefaultUser> users = List.generate(maps.length, (i) {
      return DefaultUser.fromMap(maps[i]);
    });
    // return maps;
    return users;
  }
}
