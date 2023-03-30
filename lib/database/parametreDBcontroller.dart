import 'package:cible/database/database.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ParametreDBcontroller {
  Future<void> insert(int idCategorie,String ville) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM parametre");
    await db.insert('parametre',{
      'id_categorie': idCategorie,
      'ville': ville,
    },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> parametre = await db.query('parametre');
    // return maps;
    return parametre;
  }
}
