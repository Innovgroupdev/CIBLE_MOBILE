import 'dart:convert';
import 'dart:ffi';

import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/models/date.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/gadget.dart';
import 'package:cible/models/marque.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/time_slot.dart';
import 'package:cible/views/eventDetails/eventDetails.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

List<DateTime> dateEvents = [];

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
    _acteurs.add(Acteur(""));
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

  getActeurToLocalMap() {
    List list = [];
    for (var element in _acteurs) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'acteurs': getActeurToMap(),
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "libelle": "$libelle",
      "acteurs": "${getActeurToLocalMap()}",
    };
  }

  factory Role.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    List l1 = madDecode['acteurs'] ?? [];
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

  String presentation = "";
  String parcours = "";

  Acteur(this._nom);
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "nom": nom,
    };
  }

  factory Acteur.fromMap(Map map) {
    var acteur = Acteur(
      map['nom'] ?? '',
    );
    acteur.presentation = map['presentation'] ?? '';
    acteur.parcours = map['parcours'] ?? '';
    return acteur;
  }
}

class Event1 {
  int _id = 0;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  int _categorieId = 0;

  int get categorieId => _categorieId;

  set categorieId(int categorieId) {
    _categorieId = categorieId;
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

  setFavoris(int favoris) {
    _favoris = favoris;
  }

  int _share = 0;

  int get share => _share;

  set share(int share) {
    _share = share;
  }

  setShare(int share) {
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

  String _theme = '';

  String get theme => _theme;

  set theme(String theme) {
    _theme = theme;
  }

  String _program = '';

  String get program => _program;

  set program(String program) {
    _program = program;
  }

  String _dateOneDay = '';

  String get dateOneDay => _dateOneDay;

  set dateOneDay(String dateOneDay) {
    _dateOneDay = dateOneDay;
  }

  String _heureDebut = '';

  String get heureDebut => _heureDebut;

  set heureDebut(String heureDebut) {
    _heureDebut = heureDebut;
  }

  String _heureFin = '';

  String get heureFin => _heureFin;

  set heureFin(String heureFin) {
    _heureFin = heureFin;
  }

  bool _isSurveyAccepted = false;

  bool get isSurveyAccepted => _isSurveyAccepted;

  set isSurveyAccepted(bool isSurveyAccepted) {
    _isSurveyAccepted = isSurveyAccepted;
  }

  String _newLieu = '';

  String get newLieu => _newLieu;

  set newLieu(String newLieu) {
    _newLieu = newLieu;
  }

  String dateFin = '';
  String notions = '';
  String savoirFaire = '';
  String methodologie = '';
  String prerequis = '';
  String publicCible = '';
  String type = '';
  bool isLoading = false;
  String gastronomieEntree = '';
  String gastronomieResistance = '';
  String gastronomieDessert = '';
  String gastronomieBoisson = '';
  String gastronomieType = '';
  String weekDaysInfo = '';
  String informationNote = '';

  List<Marque> marques = [];

  List<TimeSlotWithoutDate> _timeSlotWithoutDate = [];

  List<TimeSlotWithoutDate> get timeSlotWithoutDate => _timeSlotWithoutDate;

  set timeSlotWithoutDate(List<TimeSlotWithoutDate> timeSlotWithoutDate) {
    _timeSlotWithoutDate = timeSlotWithoutDate;
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
      "", 0, "", "", "", "", "", false, "", "", 0, "", "", "", "", "", "", 0);

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

  bool _isReported = false;

  bool get isReported => _isReported;

  set isReported(bool isReported) {
    _isReported = isReported;
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

  List<Ticket> _ticketsPayes = [];

  List<Ticket> get ticketsPayes => _ticketsPayes;

  set ticketsPayes(List<Ticket> ticketsPayes) {
    _ticketsPayes = ticketsPayes;
  }

  List<Gadget> _gadgetsPayes = [];

  List<Gadget> get gadgetsPayes => _gadgetsPayes;

  set gadgetsPayes(List<Gadget> gadgetsPayes) {
    _gadgetsPayes = gadgetsPayes;
  }

  List<Role> _roles = [];

  List<Role> get roles => _roles;

  set roles(List<Role> roles) {
    _roles = roles;
  }

  Event1(
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

  getLieuxToLocalMap() {
    List list = [];
    for (var element in _lieux) {
      list.add(element.toLocalMap());
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

  geTicketToLocalMap() {
    List list = [];
    for (var element in _tickets) {
      list.add(element.toLocalMap());
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

  geRoleToLocalMap() {
    List list = [];
    for (var element in _roles) {
      list.add(element.toLocalMap());
    }
    return list;
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
    List l3 = [];

    l = madDecode['siteInfo'] ?? [];
    List<Lieu> lieux = getListLieuFrom(l);

    l1 = madDecode['role_acteurs'] ?? madDecode['roles'] ?? [];
    List<Role> roles = getListRoleFrom(l1);

    l2 = madDecode['tickets'] ?? [];
    l3 = map['tickets_restant'] == null ? [] : madDecode['tickets_restant'];
    List<Ticket> tickets = getListTicketFrom(l2);

    List<Marque> marquesFromApi = getMarquesFromApi(madDecode['marques'] ?? []);

    var event = Event1(
      // madDecode['id'] ?? 0,
      Categorie.fromMap(madDecode['categorie']),
      madDecode['access_conditions'] ?? '',
      madDecode['desc'] ?? madDecode['movie_overview'] ?? '',
      madDecode['image_url'] ?? '',
      lieux ?? [],
      (madDecode['pays_id']).toString() ?? '',
      roles,
      tickets,
      madDecode['titre'] ??
          madDecode['title'] ??
          madDecode['movie_title'] ??
          '',
      madDecode['ville'] ?? '',
    );

    event.categorie = Categorie.fromMap(madDecode['categorie']);
    event.titre = madDecode['titre'] ??
        madDecode['nom'] ??
        madDecode['movie_title'] ??
        madDecode['buffet_name'] ??
        madDecode['theme'] ??
        'testtst';
    event.description = madDecode['desc'] ??
        madDecode['description'] ??
        madDecode['movie_overview'] ??
        '';

    event.conditions =
        madDecode['access_conditions'] ?? madDecode['access_condition'] ?? '';

    // !!!!!!!
    event.image = madDecode['image_url'] ?? madDecode['image'] ?? '';
    event.pays = (madDecode['pays_id']).toString();
    event.roles = roles;
    event.tickets = tickets;
    event.ville = madDecode['ville'] ?? '';

    event.categorieId = int.parse(madDecode['categorie_id'] ?? '0');
    event.id = madDecode['id'] ?? 0;
    madDecode['organisateur'] != null
        ? event.auteur = DefaultUser.fromMap(madDecode['organisateur'])
        : madDecode['organisateur'] != null;

    event.code = madDecode['code'] ?? '';
    event.isReported =
        madDecode['reported'] == null || madDecode['reported'] == "0"
            ? false
            : true;
    event.created_at = madDecode['created_at'] ?? '';
    event.updated_at = madDecode['updated_at'] ?? '';
    // event.isActive = int.parse('${madDecode['is_active']}');
    event.favoris =
        madDecode['favoris'] != null ? int.parse(madDecode['favoris']) : 0;
    event.share =
        madDecode['nb_share'] != null ? int.parse(madDecode['nb_share']) : 0;

    event.theme = madDecode['theme'] ?? '';
    event.program = madDecode['program'] ?? '';

    String dateDebut = '';
    dateDebut = madDecode['date_debut'] ??
        madDecode['dateevent'] ??
        madDecode['date'] ??
        madDecode['creneauDate'] ??
        "";
    event.dateOneDay = DateConvertisseur().convertDateFormatToEEEE(dateDebut);

    String dateFin = '';
    dateFin = madDecode['end_date'] ?? "";
    event.dateFin = DateConvertisseur().convertDateFormatToEEEE(dateFin);

    event.heureDebut =
        madDecode['heure_debut'] ?? madDecode['creneauHoraireDebut'] ?? '';
    event.heureFin =
        madDecode['heure_fin'] ?? madDecode['creneauHoraireFin'] ?? '';
    event.isSurveyAccepted = madDecode['survey_satisfaction_selected'] == 1;
    event.newLieu = madDecode['lieu'] ?? '';
    event.notions = madDecode['covered_topics'] ?? '';
    event.savoirFaire = madDecode['skills_to_acquiert'] ?? '';
    event.methodologie = madDecode['methodology'] ?? '';
    event.prerequis =
        madDecode['pre-requists'] ?? madDecode['prerequisites'] ?? '';
    event.publicCible = madDecode['public_cible'] ?? '';
    event.type = madDecode['type'] ?? '';
    event.gastronomieEntree = madDecode['starter_dishes'] ?? '';
    event.gastronomieResistance = madDecode['main_dishes'] ?? '';
    event.gastronomieDessert = madDecode['desserts'] ?? '';
    event.gastronomieBoisson = madDecode['beverage'] ?? '';
    event.gastronomieType = madDecode['type'] ?? '';
    event.weekDaysInfo =
        madDecode['creneaux_infos'] ?? madDecode['daysinfos'] ?? '';
    event.informationNote =
        madDecode['note_infos'] ?? madDecode['note_informations'] ?? '';

    event.marques = marquesFromApi;
    return event;
  }

  factory Event1.fromJson(dynamic map) {
    var madDecode = json.decode(json.encode(map));
    List l = [];
    List l1 = [];
    List l2 = [];
    List l3 = [];
    l = madDecode['siteInfo'] != null ? json.decode(madDecode['siteInfo']) : [];
    List<Lieu> lieux = getListLieuFrom(l);
    l1 = madDecode['roleActeur'] != null
        ? json.decode(madDecode['roleActeur'])
        : [];
    List<Role> roles = getListRoleFrom(l1);

    l2 = madDecode['tickets'] == null ? [] : madDecode['tickets'];
    l3 = madDecode['tickets_restant'] == null
        ? []
        : madDecode['tickets_restant'];

    //print(l2);
    List<Ticket> tickets = getListTicketFrom(l2);

    var event = Event1(
      //madDecode['id'] ?? 0,
      Categorie.fromMap(madDecode['categorie']),
      madDecode['condition'] ?? '',
      madDecode['description'] ?? '',
      madDecode['image'] ?? '',
      lieux ?? [],
      madDecode['pays'] ?? '',
      roles ?? [],
      tickets ?? [],
      madDecode['titre'] ?? '',
      madDecode['ville'] ?? '',
    );
    event.categorieId = int.parse(madDecode['categorie_id']) ?? 0;
    event.id = madDecode['id'] != null ? madDecode['id'] : 0;
    event.code = madDecode['code'] != null ? madDecode['code'] : '';
    event.created_at = madDecode['created_at'] ?? '';
    event.updated_at = madDecode['updated_at'] ?? '';
    event.isActive =
        madDecode['is_active'] != null ? madDecode['is_active'] : 0;
    event.favoris =
        madDecode['favoris'] != null ? int.parse(madDecode['favoris']) : 0;

    return event;
  }

  @override
  String toString() {
    return 'Event1{ categorie: $categorie, condition: $conditions, description: $description, lieu: $lieux, pays: $pays,roles:$roles,tickets:$tickets,titre:$titre,ville:$ville}';
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
  if (mapList != null && mapList != []) {
    for (var element in mapList) {
      l.add(Ticket.fromMap(element)); /*mapList.indexOf(element)*/
    }
  }
  return l;
}

List<Marque> getMarquesFromApi(List marquesFromApi) {
  List<Marque> marques = [];
  if (marquesFromApi != []) {
    for (var element in marquesFromApi) {
      marques.add(Marque.fromMap(element));
    }
  }
  return marques;
}
