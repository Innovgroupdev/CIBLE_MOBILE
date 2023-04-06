// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:cible/models/couleurModel.dart';
import 'package:cible/models/tailleModel.dart';

class ModelGadget {
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

  String _libelle = "";

  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }
 String _image = "";

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  String _description = "";

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  double _prixCible = 0.0;

  double get prixCible => _prixCible;

  set prixCible(double prixCible) {
    _prixCible = prixCible;
  }

  String _deviseCible = "";

  String get deviseCible => _deviseCible;

  set deviseCible(String deviseCible) {
    _deviseCible = deviseCible;
  }

  double _prixPartenaire = 0.0;

  double get prixPartenaire => _prixPartenaire;

  set prixPartenaire(double prixPartenaire) {
    _prixPartenaire = prixPartenaire;
  }

  String _devisePartenaire = "";

  String get devisePartenaire => _devisePartenaire;

  set devisePartenaire(String devisePartenaire) {
    _devisePartenaire = devisePartenaire;
  }

  int _dureeCommande = 0;

  int get dureeCommande => _dureeCommande;

  set dureeCommande(int dureeCommande) {
    _dureeCommande = dureeCommande;
  }

  List<CouleurModel> _couleursModels = [];
  List<CouleurModel> get couleursModels => _couleursModels;
  set couleursModels(List<CouleurModel> couleursModels) {
    _couleursModels = couleursModels;
  }

  List<TailleModel> _tailleModels = [];
  List<TailleModel> get tailleModels => _tailleModels;
  set tailleModels(List<TailleModel> tailleModels) {
    _tailleModels = tailleModels;
  }

  ModelGadget(
      this._id,
      this._libelle,
      this._image,
      this._description,
      this._prixCible,
      this._deviseCible,
      this._prixPartenaire,
      this._devisePartenaire,
      this._dureeCommande,
      this._couleursModels,
      this._tailleModels);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': libelle,
      'image': image,
      'description': description,
      'prix_cible': prixCible,
      'devise_cible': deviseCible,
      'prix_partenaire': prixPartenaire,
      'devise_partenaire': devisePartenaire,
      'duree_commande': dureeCommande,
      'colors': couleursModels,
      'sizes': tailleModels,
    };
  }

  factory ModelGadget.fromMap(Map map) {
    var madDecode = jsonDecode(jsonEncode(map));
    return ModelGadget(
        int.parse(madDecode['id'].toString()),
        madDecode['nom'],
        madDecode['final_mockup_url'] ?? madDecode['chemin_final_mockup'],
        madDecode['description'],
        double.parse(madDecode['prix_cible']),
        madDecode['devise_cible'],
        double.parse(madDecode['prix_partenaire'],),
        madDecode['devise_partenaire'],
        int.parse(madDecode['duree_commande']),
        getCouleurModelFromMap(madDecode['colors'] ?? []),
        getTailleModelFromMap(madDecode['sizes'] ?? []),
  );}
}

List<TailleModel> getTailleModelFromMap(eventsListFromAPI) {
  var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));
  
  final List<TailleModel> tagObjs = [];
  for (var element in madDecode) {
    var event = TailleModel.fromMap(element);
    tagObjs.add(event);
  }
  return tagObjs;
}

List<CouleurModel> getCouleurModelFromMap(eventsListFromAPI) {
  var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));
  
  final List<CouleurModel> tagObjs = [];
  for (var element in madDecode) {
    var color = CouleurModel.fromMap(element);
    tagObjs.add(color);
  }
  return tagObjs;
}
