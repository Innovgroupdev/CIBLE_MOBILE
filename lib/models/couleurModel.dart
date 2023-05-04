import 'dart:convert';

class CouleurModel {
  int _id = 0;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String _libelle = "";

  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

  CouleurModel(
      this._id,
      this._libelle);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': libelle,
    };
  }

  factory CouleurModel.fromMap(Map map) {
    var madDecode = jsonDecode(jsonEncode(map));
    return CouleurModel(
        madDecode['id'],
        madDecode['libelle']
  );}
}
