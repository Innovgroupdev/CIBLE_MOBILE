// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:cible/models/couleurModel.dart';
import 'package:cible/models/modelGadget.dart';
import 'package:cible/models/tailleModel.dart';

class Gadget {
  int _id = 0;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  int _nombrePaye = 0;

  int get nombrePaye => _nombrePaye;

  set nombrePaye(int nombrePaye) {
    _nombrePaye = nombrePaye;
  }

  int _eventId = 0;

  int get eventId => _eventId;

  set eventId(int eventId) {
    _eventId = eventId;
  }

  String _libelle = "";

  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

  List<ModelGadget> _models = [];

  List<ModelGadget> get models => _models;

  set models(List<ModelGadget> models) {
    _models = models;
  }

  Gadget(this._id, this._eventId, this._libelle, this._models);

  Map<String, dynamic> toMap() {
    return {'gadget': libelle, 'models': models, 'id': id, 'eventId': eventId};
  }

  factory Gadget.fromMap(Map map) {
    var madDecode = jsonDecode(jsonEncode(map));

    return Gadget(
        madDecode['gadget']['id'],
        madDecode['evenement']['id'],
        madDecode['gadget']['libelle'],
        getGadgetFromMap(madDecode['models'] ?? []));
  }
}

List<ModelGadget> getGadgetFromMap(List eventsListFromAPI) {
  final List<ModelGadget> tagObjs = [];
  for (var element in eventsListFromAPI) {
    var model = ModelGadget.fromMap(element['modele'] ?? element);
    if (element['quantity'] != null) {
      model.nombrePaye = int.parse(element['quantity']);
      model.couleursModels = [CouleurModel.fromMap(element['color'])];
      model.tailleModels = [TailleModel.fromMap(element['size'])];
    }
    tagObjs.add(model);
  }
  return tagObjs;
}
