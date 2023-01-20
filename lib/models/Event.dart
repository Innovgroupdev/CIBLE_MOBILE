import 'dart:convert';

import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/models/date.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/views/eventDetails/eventDetails.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Event {
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

  Map _auteur;

  Map get auteur => _auteur;

  set auteur(Map auteur) {
    _auteur = auteur;
  }

  bool _like;

  bool get like => _like;

  set like(bool like) {
    _like = like;
  }

  Event(this._titre, this._image, this._auteur, this._like);
}

class Role {
  String _libelle;

  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

  List<Acteur> _acteurs;

  List<Acteur> get acteurs => _acteurs;

  set acteurs(List<Acteur> acteurs) {
    _acteurs = acteurs;
  }

  addActeur() {
    this._acteurs.add(Acteur(""));
  }

  removeActeur(index) {
    this._acteurs.removeAt(index);
  }

  Role(this._libelle, this._acteurs);
  getActeurToMap() {
    List list = [];
    for (var element in _acteurs) {
      list.add(element.toMap());
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'acteurs': getActeurToMap(),
    };
  }

  factory Role.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    List l1 = madDecode['acteurs'] as List;
    List<Acteur> acteurs = l1.map((model) => Acteur.fromMap(model)).toList();

    var role = Role(
      map['libelle'] ?? '',
      acteurs ?? [],
    );
    return role;
  }
}

class Acteur {
  String _nom;

  String get nom => _nom;

  set nom(String nom) {
    _nom = nom;
  }

  Acteur(this._nom);
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
    };
  }

  factory Acteur.fromMap(Map map) {
    var acteur = Acteur(
      map['nom'],
    );
    return acteur;
  }
}

class Event1 {
  int _id;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  bool _isLike = false;

  bool get isLike => _isLike;

  set isLike(bool isLike) {
    _isLike = isLike;
  }

  bool _isDislike = false;

  bool get isDislike => _isDislike;

  set isDislike(bool isDislike) {
    _isDislike = isDislike;
  }

  bool _isFavoris = false;

  bool get isFavoris => _isFavoris;

  set isFavoris(bool isFavoris) {
    _isFavoris = isFavoris;
  }

  bool _isShare = false;

  bool get isShare => _isShare;

  set isShare(bool isShare) {
    _isShare = isShare;
  }

  int _like = 0;

  int get like => _like;

  set like(int like) {
    _like = like;
  }

  int _dislike = 0;

  int get dislike => _dislike;

  set dislike(int dislike) {
    _dislike = dislike;
  }

  int _favoris = 0;

  int get favoris => _favoris;

  set favoris(int favoris) {
    _favoris = favoris;
  }

  int _share = 0;

  int get share => _share;

  set share(int share) {
    _share = share;
  }

  Categorie _categorie = Categorie('', '', '', '', false, []);

  Categorie get categorie => _categorie;

  set categorie(Categorie categorie) {
    _categorie = categorie;
  }

  String _titre = '';

  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  String _description = '';

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  String _conditions = '';

  String get conditions => _conditions;

  set conditions(String conditions) {
    _conditions = conditions;
  }

  String _pays = '';

  String get pays => _pays;

  set pays(String pays) {
    _pays = pays;
  }

  String _ville = "";

  String get ville => _ville;

  set ville(String ville) {
    _ville = ville;
  }

  DefaultUser _auteur = DefaultUser(
      "", "", "", "", "", "", "", false, "", "", "", "", "", "", "", "", "");

  DefaultUser get auteur => _auteur;

  set auteur(DefaultUser auteur) {
    _auteur = auteur;
  }

  List<Lieu> _lieux = [];

  List<Lieu> get lieux => _lieux;

  set lieux(List<Lieu> lieux) {
    _lieux = lieux;
  }

  String _image = '';

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  int _isActive = 0;

  int get isActive => _isActive;

  set isActive(int isActive) {
    _isActive = isActive;
  }

  String _code = '';

  String get code => _code;

  set code(String code) {
    _code = code;
  }

  String _created_at = '';

  String get created_at => _created_at;

  set created_at(String created_at) {
    _created_at = created_at;
  }

  String _updated_at = '';

  String get updated_at => _updated_at;

  set updated_at(String updated_at) {
    _updated_at = updated_at;
  }

  List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  set tickets(List<Ticket> tickets) {
    _tickets = tickets;
  }

  List<Role> _roles = [];

  List<Role> get roles => _roles;

  set roles(List<Role> roles) {
    _roles = roles;
  }

  Event1(
      this._id,
      this._categorie,
      this._conditions,
      this._description,
      this._image,
      this._lieux,
      this._pays,
      this._roles,
      this._tickets,
      this._titre,
      this._ville);

  getLieuxToMap() {
    List list = [];
    for (var element in _lieux) {
      list.add(element.toMap());
    }
    return list;
  }

  geTicketToMap() {
    List list = [];
    for (var element in _tickets) {
      list.add(element.toMap());
    }
    return list;
  }

  geRoleToMap() {
    List list = [];
    for (var element in _roles) {
      list.add(element.toMap());
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'categorie': categorie.toMap(),
      'image': image,
      'conditions': conditions,
      'pays': pays,
      'ville': ville,
      'lieux': getLieuxToMap(),
      'tickets': geTicketToMap(),
      'roles': geRoleToMap(),
    };
  }

  Map<String, dynamic> toAPIMap() {
    return {
      'titre': titre,
      'desc': description,
      'categorie_id': 1,
      'image': image,
      'condition': conditions,
      'siteInfo': jsonEncode(getLieuxToMap()),
      'dateevent': jsonEncode(getLieuxToMap()),
      'tickets': jsonEncode(geTicketToMap()),
      'roleActeur': jsonEncode(geRoleToMap()),
      'is_active': isActive,
      'pays': pays,
      'ville': ville,
    };
  }

  DateTime getEventFirstDate() {
    if (categorie.code.isNotEmpty) {
      if (getCategorieIsMultiple(categorie.code)) {
        return getCreneauxDateFirst();
      } else {
        return getSimpleFirstDate();
      }
    }

    return getSimpleFirstDate();
  }

  getCreneauxDateFirst() {
    var first;
    var temp;
    for (var i = 0; i < lieux.length; i++) {
      for (var j = 0; j < lieux[i].creneauDates.length; j++) {
        var temp = DateConvertisseur()
            .convertirStringtoDateTime(lieux[i].creneauDates[j].dateDebut);
        if (first != null) {
          if (!DateConvertisseur().compareDates(temp, first)) {
            first = temp;
          }
        } else {
          first = temp;
        }
      }
    }
    return first;
  }

  getSimpleFirstDate() {
    var first;
    var temp;
    for (var i = 0; i < lieux.length; i++) {
      for (var j = 0; j < lieux[i].dates.length; j++) {
        var temp = DateConvertisseur()
            .convertirStringtoDateTime(lieux[i].dates[j].valeur);
        if (first != null) {
          if (!DateConvertisseur().compareDates(temp, first)) {
            first = temp;
          }
        } else {
          first = temp;
        }
      }
    }
    return first;
  }

  factory Event1.fromMap(dynamic map) {
    var madDecode = json.decode(json.encode(map));
    List l = [];
    List l1 = [];
    List l2 = [];

    // l = getListFrom(json.decode(madDecode['siteInfo']));
    // print(l);
    // l1 = getListFrom(json.decode(madDecode['roleActeur']));
    // print(l1);
    // l2 = getListFrom(
    //     madDecode['tickets'] == null ? [] : json.decode(madDecode['tickets']));
    // print(l2);
    // l = json
    //     .decode(madDecode['siteInfo'])
    //     .map((model) => Lieu.fromMap(model))
    //     .toList();
    // print(json.decode(madDecode['siteInfo']));
    // l = madDecode['siteInfo'];
    List<Lieu> lieux = getListLieuFrom(l);
    // print(lieux);
    // List<Lieu> lieux = l.map((model) => Lieu.fromMap(model)).toList();

    // List l1 = json.decode(madDecode['roleActeur']) as List;
    // List<Role> roles = l1.map((model) => Role.fromMap(model)).toList();

    // l1 = madDecode['roleActeur'];
    List<Role> roles = getListRoleFrom(l1);
    // print(roles);

    // List l2;
    // if (madDecode['tickets'] != null) {
    //   l2 = json.decode(madDecode['tickets']) as List;
    // } else {
    //   l2 = [];
    // }
    // List<Ticket> tickets = l2.map((model) => Ticket.fromMap(model)).toList();

    // l2 = map['tickets'] == null ? [] : madDecode['tickets'];
    print(l2);
    List<Ticket> tickets = getListTicketFrom(l2);
    // print(tickets);

    var event = Event1(
      madDecode['id'] ?? 0,
      Categorie.fromMap(madDecode['categorie']),
      madDecode['condition'] ?? '',
      madDecode['desc'] ?? '',
      madDecode['image'] ?? '',
      lieux ?? [],
      madDecode['pays'] ?? '',
      roles ?? [],
      tickets ?? [],
      madDecode['titre'] ?? '',
      madDecode['ville'] ?? '',
    );
    // print('id : ${madDecode['id']}, code : ${madDecode['code']}');
    event.id = madDecode['id'] ?? '';
    event.code = madDecode['code'] ?? '';
    event.created_at = madDecode['created_at'] ?? '';
    event.updated_at = madDecode['updated_at'] ?? '';
    event.isActive = int.parse('${madDecode['is_active']}');
    // event.like = int.parse('${madDecode['likeEvent']}') ?? 0;
    // event.dislike = int.parse('${madDecode['dislikeEvent']}') ?? 0;
    return event;
  }
}

List<Lieu> getListLieuFrom(List mapList) {
  List<Lieu> l = [];
  if (mapList != null) {
    for (var element in mapList) {
      l.add(Lieu.fromMap(element));
    }
  }
  return l;
}

List<Role> getListRoleFrom(List mapList) {
  List<Role> l = [];
  if (mapList != null) {
    for (var element in mapList) {
      l.add(Role.fromMap(element));
    }
  }
  return l;
}

List<Ticket> getListTicketFrom(List mapList) {
  List<Ticket> l = [];
  if (mapList != null) {
    for (var element in mapList) {
      l.add(Ticket.fromMap(element));
    }
  }
  return l;
}
