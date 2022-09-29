import 'package:cible/database/database.dart';
import 'package:cible/models/action.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ActionDBcontroller {
  Future<void> insert(ActionUser action) async {
    final Database db = await CibleDataBase().database;
    await db.insert('action', action.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(ActionUser action) async {
    final Database db = await CibleDataBase().database;
    await db.update('action', action.toMap(),
        where: "titre = ?", whereArgs: [action.titre]);
  }

  Future<void> delete(ActionUser action) async {
    final Database db = await CibleDataBase().database;
    await db.delete('action', where: "titre = ?", whereArgs: [action.titre]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('action');

    List<ActionUser> actions = List.generate(maps.length, (i) {
      return ActionUser.fromMap(maps[i]);
    });
    return actions;
  }
}
