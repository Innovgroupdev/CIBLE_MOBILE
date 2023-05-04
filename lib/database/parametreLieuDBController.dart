import 'package:cible/database/database.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ParametreLieuDBcontroller {
  Future<void> insert(dynamic ville/*,dynamic ville*/) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM parametreVille");
    await db.insert('parametreVille',{
      'ville': ville,
    },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> parametre = await db.query('parametreVille');
    // return maps;
    return parametre;
  }
}
