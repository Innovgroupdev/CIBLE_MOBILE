import 'package:cible/database/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Event.dart';

class Event1DBcontroller {
  Future<void> insert(Event1 event1) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM event");
    int id = await db.insert('event', event1.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('le id que je cherche ' + id.toString());
  }

  Future<void> delete(Event1 event1) async {
    final Database db = await CibleDataBase().database;
    await db.delete('event', where: "id = ?", whereArgs: [event1.id]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('event');
    print('le map que je cherche ' + maps.toString());

    List<Event1> event1 = List.generate(maps.length, (i) {
      return Event1.fromMap(maps[i]);
    });
    return event1;
  }
}
