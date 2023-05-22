import 'package:cible/database/database.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDBcontroller {
  Future<void> insert(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    print('dddddd2' + user.paysId.toString());
    await db.execute("DELETE FROM user");
    await db.insert('user', user.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    await db.update('user', user.toLocalMap(),
        where: "email1 = ? OR tel1 = ?", whereArgs: [user.email1, user.tel1]);
  }

  Future<void> delete(DefaultUser user) async {
    final Database db = await CibleDataBase().database;
    await db.delete('user', where: "email = ?", whereArgs: [user.email1]);
  }

  Future<List<DefaultUser>> liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    List<DefaultUser> users = List.generate(maps.length, (i) {
      print("object");
      return DefaultUser.fromMap(maps[i]);
    });
    // return maps;
    return users;
  }
}
