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
    WidgetsFlutterBinding.ensureInitialized();
    var databasesPath = await getDatabasesPath();
    return await openDatabase(join(databasesPath, 'cible_database.db'),
        version: 3, onOpen: (db) {
      // return db.execute(
      //     "CREATE TABLE IF NOT EXISTS action(id TEXT PRIMARY KEY,image TEXT,titre TEXT,description TEXT,type TEXT,etat TEXT)");
    }, onCreate: ((db, version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS  user(id TEXT PRIMARY KEY, birthday TEXT, codeTel1 TEXT, codeTel2 TEXT, email1 TEXT, email2 TEXT, image TEXT, logged TEXT, nom TEXT, password TEXT, pays TEXT, prenom TEXT, reseauCode TEXT, sexe TEXT, tel1 TEXT, tel2 TEXT, ville TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS  event(id TEXT PRIMARY KEY, titre TEXT, description TEXT, categorie TEXT, image TEXT, conditions TEXT, pays TEXT, ville TEXT, lieux TEXT, tickets TEXT, roles TEXT)");

      await db.execute(
          "CREATE TABLE IF NOT EXISTS action(id TEXT PRIMARY KEY,image TEXT,titre TEXT,description TEXT,type TEXT,etat TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS notification(id INTEGER PRIMARY KEY,image TEXT,titre TEXT,type TEXT,description TEXT,etat BOOLEAN )");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS favoris(id TEXT PRIMARY KEY,image TEXT,titre TEXT,description TEXT,type TEXT,etat TEXT)");
    }));
  }
}
