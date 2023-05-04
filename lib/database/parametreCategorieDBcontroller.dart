import 'package:cible/database/database.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ParametreCategorieDBcontroller {
  Future<void> insert(dynamic idCategorie/*,dynamic ville*/) async {
    final Database db = await CibleDataBase().database;
    await db.execute("DELETE FROM parametreCategorie");
    await db.insert('parametreCategorie',{
      'id_categorie': idCategorie,
    },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> parametre = await db.query('parametreCategorie');
    // return maps;
    return parametre;
  }
}
