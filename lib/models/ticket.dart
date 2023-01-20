import 'dart:convert';
import 'dart:ffi';

import 'package:cible/models/date.dart';

class Ticket {
  // int _id;

  // int get id => _id;

  // set id(int id) {
  //   _id = id;
  // }

  String _libelle;

  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

// d	libelle	prix	nb_pace	nb_pace_init	desc	is_promot1	is_promot2	reduction1	reduction2	nbr_max_promot1	nbr_min_promot2	created_at	updated_at	evenement_id
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

  Map _promo1 = {"libelle": "Offrir une réduction aux  premiers acheteurs"};

  Map get promo1 => _promo1;

  set promo1(Map promo1) {
    _promo1 = promo1;
  }

  Map _promo2 = {
    "libelle": "Offrir une réduction suivant le nombre de tickets achetés"
  };

  Map get promo2 => _promo2;

  set promo2(Map promo2) {
    _promo2 = promo2;
  }

  List<DateMontant> _datesMontant;
  List<DateMontant> get datesMontant => _datesMontant;

  set dates(List<DateMontant> datesMontant) {
    _datesMontant = datesMontant;
  }

  addPromo1(double pourcentage, int nbreMax) {
    promo1 = {
      "libelle": "Offrir une réduction aux  premiers acheteurs",
      "pourcentage": pourcentage,
      "nbreMax": nbreMax,
    };
  }

  removePromo1() {
    promo1 = {
      "libelle": "Offrir une réduction aux  premiers acheteurs",
    };
  }

  addPromo2(double pourcentage, int nbreMax) {
    promo2 = {
      "libelle": "Offrir une réduction suivant le nombre de tickets achetés",
      "pourcentage": pourcentage,
      "nbreMin": nbreMax,
    };
  }

  removePromo2() {
    promo2 = {
      "libelle": "Offrir une réduction suivant le nombre de tickets achetés",
    };
  }

  addDateMontant() {
    _datesMontant.add(DateMontant([], 0));
  }

  removeDateMontant(int index) {
    _datesMontant.removeAt(index);
  }

  changeMontantForDateMontant(int index, double montant) {
    _datesMontant[index]._montant = montant;
  }

  Ticket(
    // this._id,
    this._libelle,
    this._prix,
    this._nombrePlaces,
    this._description,
    this._promo1,
    this._promo2,
    this._datesMontant,
  );

  getDatesMontanttoMap() {
    List list = [];
    for (var element in _datesMontant) {
      list.add(element.toMap());
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'libelle': libelle,
      'prix': prix,
      'nombrePlaces': nombrePlaces,
      'description': description,
      'promo1': promo1,
      'promo2': promo2,
      'datesMontant': getDatesMontanttoMap(),
    };
  }

  factory Ticket.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    List l1 = madDecode['datesMontant'] as List;
    List<DateMontant> datesMontant =
        l1.map((model) => DateMontant.fromMap(model)).toList();

    var event = Ticket(
      // madDecode['id'] ?? 0,
      madDecode['libelle'],
      madDecode['prix'],
      madDecode['nombrePlaces'],
      madDecode['description'],
      json.decode(json.encode(madDecode['promo1'])),
      json.decode(json.encode(madDecode['promo2'])),
      datesMontant,
    );
    return event;
  }
}

class DateMontant {
  List<Date> _date;

  List<Date> get date => _date;

  set date(List<Date> date) {
    _date = date;
  }

  double _montant;

  double get montant => _montant;

  set montant(double montant) {
    _montant = montant;
  }

  addDate(Date date) {
    this._date.add(date);
  }

  removeDate(Date date) {
    for (int i = 0; i < this._date.length; i++) {
      if (this._date[i].valeur == date.valeur) {
        this._date.removeAt(i);
        return;
      }
    }
  }

  getDateToMap() {
    List list = [];
    for (var element in _date) {
      list.add(element.toMap());
    }
    return list;
  }

  DateMontant(this._date, this._montant);
  Map<String, dynamic> toMap() {
    return {
      'date': getDateToMap(),
      'montant': montant,
    };
  }

  factory DateMontant.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    List l1 = madDecode['date'] as List;
    List<Date> dates = l1.map((model) => Date.fromMap(model)).toList();

    var event = DateMontant(
      dates,
      madDecode['montant'],
    );
    return event;
  }
}
