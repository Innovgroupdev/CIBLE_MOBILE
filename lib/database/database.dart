import 'package:cible/models/defaultUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CibleDataBase {
  // CibleDataBase._();
  static final CibleDataBase instance = CibleDataBase();
  static dynamic _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(join(databasesPath, 'cible_database.db'),
        version: 1, onCreate: ((db, version) {
      return db.execute(
          "CREATE TABLE user(id TEXT PRIMARY KEY, birthday TEXT, codeTel1 TEXT, codeTel2 TEXT, email1 TEXT, email2 TEXT, image TEXT, logged TEXT, nom TEXT, password TEXT, pays TEXT, prenom TEXT, reseauCode TEXT, sexe TEXT, tel1 TEXT, tel2 TEXT, ville TEXT)");
    }));
  }
}
