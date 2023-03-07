// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:cible/models/modelGadget.dart';

class Gadget {
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

  Gadget(this._libelle, this._models);

  Map<String, dynamic> toMap() {
    return {
      'gadget': libelle,
      'models': models,
    };
  }

  factory Gadget.fromMap(Map map) {
    var madDecode = jsonDecode(jsonEncode(map));
    
    return Gadget(madDecode['gadget']['libelle'], 
        getGadgetFromMap(madDecode['models'] ?? []));
  }

}
  List<ModelGadget> getGadgetFromMap(eventsListFromAPI) {
  var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));
  
  final List<ModelGadget> tagObjs = [];
  for (var element in madDecode) {
    var event = ModelGadget.fromMap(element);
    tagObjs.add(event);
  }
  return tagObjs;
}
