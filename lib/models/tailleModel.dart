import 'dart:convert';

class TailleModel {
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

  TailleModel(
      this._id,
      this._libelle);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': libelle,
    };
  }

  factory TailleModel.fromMap(Map map) {
    var madDecode = jsonDecode(jsonEncode(map));
    return TailleModel(
        madDecode['id'],
        madDecode['libelle']
  );}
}
