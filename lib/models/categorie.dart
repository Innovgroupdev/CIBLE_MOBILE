import 'dart:convert';

import 'package:cible/models/Event.dart';

class Categorie {
  String _titre;

  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  String _image;

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  String _code;

  String get code => _code;

  set code(String code) {
    _code = code;
  }

  bool _checked;

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  String _description;

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  List<Event1> _events;

  List<Event1> get events => _events;

  set events(List<Event1> events) {
    _events = events;
  }

  changeEtat() {
    // ignore: unnecessary_this
    this.checked = !this.checked;
  }

  Categorie(this._titre, this._description, this._code, this._image,
      this._checked, this._events);
  factory Categorie.fromMap(dynamic map) {
    var madDecode = jsonDecode(jsonEncode(map));
    if (madDecode == null) {
      return Categorie("", "", "", "", false, []);
    }
    return Categorie(
      madDecode['titre'] ?? '',
      madDecode['description']?? '',
      madDecode['code']?? '',
      madDecode['image']?? '',
      madDecode['checked'] ?? 0,
      madDecode['events'] ?? [],
    );
  }
}
