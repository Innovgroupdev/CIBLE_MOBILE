import 'package:cible/models/Event.dart';

class Categorie {
  String _titre;

  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  String _description;

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  List<Event> _events;

  List<Event> get events => _events;

  set events(List<Event> events) {
    _events = events;
  }

  Categorie(this._titre, this._description, this._events);
}
