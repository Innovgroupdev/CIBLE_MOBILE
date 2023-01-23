import 'package:cible/database/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Event.dart';

class FavorisDBcontroller {
  Future<void> insert(Event1 event1) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM favoris");
    int id = await db.insert('favoris', event1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('le id que je cherche ' + id.toString());
  }

  Future<void> delete(Event1 event1) async {
    final Database db = await CibleDataBase().database;
    await db.delete('favoris', where: "id = ?", whereArgs: [event1.id]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('favoris');
    print('le map que je cherche ' + maps.toString());

    List<Event1> event1 = List.generate(maps.length, (i) {
      return Event1.fromMap(maps[i], null);
    });
    return event1;
  }
}
