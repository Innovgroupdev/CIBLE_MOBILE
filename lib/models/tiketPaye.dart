import 'dart:convert';
import 'dart:ffi';

import 'package:cible/models/Event.dart';
import 'package:cible/models/date.dart';

class TicketPaye {
  int _id;
  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String _libelle;
  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

  String _titre;
  String get titre => _titre;

  set titre(String libetitrelle) {
    _titre = titre;
  }

  double _prix;

  double get prix => _prix;

  set prix(double prix) {
    _prix = prix;
  }

  int _nombrePlaces;

  int get nombrePlaces => _nombrePlaces;

  set nombrePlaces(int nombrePlaces) {
    _nombrePlaces = nombrePlaces;
  }

  String _description;

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  Event1 _events;

  Event1 get events => _events;

  set events(Event1 events) {
    _events = events;
  }

  TicketPaye(this._id, this._titre, this._libelle, this._prix,
      this._nombrePlaces, this._description, this._events);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'prix': prix,
      'nombrePlaces': nombrePlaces,
      'description': description,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "libelle": "$libelle",
      "prix": "$prix",
      "nombrePlaces": "$nombrePlaces",
      "description": "$description",
    };
  }

  factory TicketPaye.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));

    var event = TicketPaye(
        madDecode['ticket']['id'] ?? 0,
        madDecode['evenement']['titre'],
        madDecode['ticket']['libelle'],
        double.parse('${madDecode['ticket']['prix']}'),
        madDecode['ticket']['nb_place'],
        madDecode['evenement']['desc'],
        Event1.fromMap(madDecode['evenement'], null));
    return event;
  }
}
