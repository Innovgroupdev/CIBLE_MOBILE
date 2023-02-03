import 'dart:convert';

import 'package:cible/models/Event.dart';

class Categorie {
  int _id = 0;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

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
    var categorie = Categorie(
      madDecode['libelle'] ?? '',
      madDecode['description'] ?? '',
      madDecode['code'] ?? '',
      madDecode['image'] ?? '',
      madDecode['checked'] ?? false,
      getEventFromMap(madDecode['events'] ?? [], {
        'titre': madDecode['titre'] ?? '',
        'description': madDecode['description'] ?? '',
        'code': madDecode['code'] ?? '',
        'image': madDecode['image'] ?? '',
      }),
    );

    categorie._id = madDecode['id'];
    return categorie;
  }

  factory Categorie.fromLocalMap(dynamic map) {
    var madDecode = jsonDecode(jsonEncode(map));
    if (madDecode == null) {
      return Categorie("", "", "", "", false, []);
    }
    var categorie = Categorie(
      madDecode['titre'] ?? '',
      madDecode['description'] ?? '',
      madDecode['code'] ?? '',
      madDecode['image'] ?? '',
      madDecode['checked'] ?? false,
      getEventFromLocalMap(map['events']),
    );
    //categorie._id = int.parse(madDecode['id']);
    return categorie;
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'code': code,
      'image': image,
      'events': events
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "id": "$id",
      "titre": "$titre",
      "description": "$description",
      "code": "$code",
      "image": "$image",
      "events": jsonEncode(events)
    };
  }

  @override
  String toString() {
    return 'Categorie{ id: $id, titre: $titre, description: $description, code: $code, image: $image,events:$events}';
  }
}

List<Event1> getEventFromMap(eventsListFromAPI, map) {
  var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));
  final List<Event1> tagObjs = [];
  for (var element in madDecode) {
    var event = Event1.fromMap(element['event'] /*, map*/);
    tagObjs.add(event);
  }
  return tagObjs;
}

List<Event1> getEventFromLocalMap(eventsListFromAPI) {
  var madDecode = jsonDecode(eventsListFromAPI);
  final List<Event1> tagObjs = [];
  for (var element in madDecode) {
    var event = Event1.fromJson(element);
    tagObjs.add(event);
  }
  return tagObjs;
}
