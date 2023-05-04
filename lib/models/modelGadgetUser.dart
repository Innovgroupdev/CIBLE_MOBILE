import 'dart:convert';
import 'dart:core';

import 'package:cible/models/Event.dart';
import 'package:cible/models/couleurModel.dart';
import 'package:cible/models/gadget.dart';
import 'package:cible/models/tailleModel.dart';
import 'package:cible/models/ticket.dart';

import 'modelGadget.dart';

class ModelGadgetUser {
  Gadget _gadget;
  ModelGadget _modelGadget;
  TailleModel _tailleModel;
  CouleurModel _couleurModel;
  int _eventId;
  int _quantite;
  double _montant;

  Gadget get gadget => _gadget;
  ModelGadget get modelGadget => _modelGadget;
  TailleModel get tailleModel => _tailleModel;
  CouleurModel get couleurModel => _couleurModel;
  double get montant => _montant;
  int get eventId => _eventId;
  int get quantite => _quantite;

  set gadget(Gadget gadget) {
    _gadget = gadget;
  }

   set modelGadget(ModelGadget modelGadget) {
    _modelGadget = modelGadget;
  }

   set tailleModel(TailleModel tailleModel) {
    _tailleModel = tailleModel;
  }

 set couleurModel(CouleurModel couleurModel) {
    _couleurModel = couleurModel;
  }


  set quantite(int quantite) {
    _quantite = quantite;
  }

  set eventId(int eventId) {
    _eventId = eventId;
  }
    set montant(double montant) {
    _montant = montant;
  }

  ModelGadgetUser(this._gadget, this._modelGadget,this._tailleModel,this._couleurModel, this._eventId, this._quantite, this._montant);

  factory ModelGadgetUser.fromMap(Map map) {
    var GadgetUser = json.decode(json.encode(map));

    var ticketCart = GadgetUser(
      
    );
    return ticketCart;
  }

  Map<String, dynamic> toMap() {
    return {
      "gadget": gadget.id,
      "modele" : modelGadget.id,
      "size":tailleModel.id,
      "couleur": couleurModel.id,
      "evenement": eventId,
      "quantite": quantite,
      'montant': montant,
    };
  }
}
