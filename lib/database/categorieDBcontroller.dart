import 'dart:convert';

import 'package:cible/database/database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/categorie.dart';

class CategorieDBcontroller {
  Future<void> insert(Categorie categorie) async {
    final Database db = await CibleDataBase().database;

    int id = await db.insert('categorie', categorie.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // print('le id que je cherche ' + id.toString());
  }

  Future<void> delete(Categorie categorie) async {
    final Database db = await CibleDataBase().database;
    await db.delete('categorie',
        where: "id = ?", whereArgs: [categorie.id.toString()]);
  }

  Future liste() async {
    final Database db = await CibleDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('categorie');
    
    // for (var i in maps) {
    //   print('le mappppppppiiiiii ' + jsonDecode(i['events']).toString());
    // }

    // var test = maps[0]['categorie'];
    //  print('le map que je chercherrrrrrrrrrrr ' + test.toString());
    //var test = jsonDecode(json.decode(json.encode(maps[0]))['categorie']);
    //var test2 = jsonDecode(test);
    //var test = '{"name": "Eduardo", "numbers": "12", "country": "us"}';
    // Map<String, dynamic?> test2 = jsonDecode(
    //     {"name": "Eduardo", "numbers": "12", "country": "us"}.toString());
    //  print('zzzzzzzzzzzzzz' + test.runtimeType.toString());

    // List<Categorie> event1 = List.generate(maps.length, (i) {
    //   return Event1.fromLocalMap(maps[i]);
    // });
    return maps;
  }
}
