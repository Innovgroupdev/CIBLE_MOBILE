import 'dart:convert';

import 'package:cible/models/Event.dart';

class LieuEvent {
  int _id = 0;
  String _titre;
  String _image;
  String _code;
  bool _checked;
  String _description;
  List<Event1> _events;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  String get code => _code;

  set code(String code) {
    _code = code;
  }

  bool get checked => _checked;

  set checked(bool checked) {
    _checked = checked;
  }

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  List<Event1> get events => _events;

  set events(List<Event1> events) {
    _events = events;
  }

  LieuEvent(this._titre, this._description, this._code, this._image,
      this._checked, this._events);

  changeEtat() {
    // ignore: unnecessary_this
    this.checked = !this.checked;
  }

  factory LieuEvent.fromMap(dynamic map) {
    var madDecode = jsonDecode(jsonEncode(map));
    if (madDecode == null) {
      return LieuEvent("", "", "", "", false, []);
    }
    var lieu = LieuEvent(
      madDecode['titre'] ?? '',
      madDecode['description'] ?? '',
      madDecode['code'] ?? '',
      madDecode['image'] ?? '',
      madDecode['checked'] ?? false,
      getEventFromMap(madDecode['events']),
    );

    lieu._id = madDecode['id'];
    return lieu;
  }
}

List<Event1> getEventFromMap(eventsListFromAPI) {
  var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));
  final List<Event1> tagObjs = [];
  for (var element in madDecode) {
    var event = Event1.fromMap(element['event'], null);
    tagObjs.add(event);
  }
  return tagObjs;
}
