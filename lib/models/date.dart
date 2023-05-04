import 'dart:convert';

class CreneauHeures {
  String _heureDebut;

  String get heureDebut => _heureDebut;

  set heureDebut(String heureDebut) {
    _heureDebut = heureDebut;
  }

  String _heureFin;

  String get heureFin => _heureFin;

  set heureFin(String heureFin) {
    _heureFin = heureFin;
  }

  CreneauHeures(this._heureDebut, this._heureFin);

  Map<String, dynamic> toMap() {
    return {
      'heureDebut': heureDebut,
      'heureFin': heureFin,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "heureDebut": "$heureDebut",
      "heureFin": "$heureFin",
    };
  }

  factory CreneauHeures.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    return CreneauHeures(
      madDecode['heureDebut'] ?? '',
      madDecode['heureFin'] ?? '',
    );
  }
}

class Date {
  String _valeur;

  String get valeur => _valeur;

  set valeur(String valeur) {
    _valeur = valeur;
  }

  int _type = 0;

  int get type => _type;

  set type(int type) {
    _type = type;
  }

  List<CreneauHeures> _creneauHeures;

  List<CreneauHeures> get creneauHeures => _creneauHeures;

  set creneauHeures(List<CreneauHeures> creneauHeures) {
    _creneauHeures = creneauHeures;
  }

  addCreneauHeure() {
    _creneauHeures.add(CreneauHeures("", ""));
  }

  removeCreneauHeure(index) {
    _creneauHeures.removeAt(index);
  }

  getCreneauHeuretoMap() {
    List list = [];
    for (var element in _creneauHeures) {
      list.add(element.toMap());
    }
    return list;
  }

  getCreneauHeuretoLocalMap() {
    List list = [];
    for (var element in _creneauHeures) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  List<CreneauHeures> getCreneauFromMap(mapList) {
    List<CreneauHeures> list = [];
    for (var element in mapList) {
      list.add(CreneauHeures.fromMap(element));
    }
    return list;
  }

  Date(this._valeur, this._type, this._creneauHeures);
  Map<String, dynamic> toMap() {
    return {
      'valeur': valeur,
      'type': type,
      'creneauHeures': getCreneauHeuretoMap(),
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "valeur": "$valeur",
      "type": "$type",
      "creneauHeures": "${getCreneauHeuretoLocalMap()}",
    };
  }

  factory Date.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    // print('ma code : $madDecode');
    List l2 = madDecode['creneauHeures'] ?? [];

    List<CreneauHeures> creneauHeures =
        l2.map((model) => CreneauHeures.fromMap(model)).toList();

    return Date(
        madDecode['valeur'] ?? '', madDecode['type'] ?? 0, creneauHeures ?? []);
  }
}

class Lieu {
  String _valeur;

  String get valeur => _valeur;

  set valeur(String valeur) {
    _valeur = valeur;
  }

  String _long;

  String get long => _long;

  set long(String long) {
    _long = long;
  }

  String _lat;

  String get lat => _lat;

  set lat(String lat) {
    _lat = lat;
  }

  List<Date> _dates;

  List<Date> get dates => _dates;

  set dates(List<Date> dates) {
    _dates = dates;
  }

  List<CreneauDate> _creneauDates = [
    CreneauDate("", "", [CreneauHeures("", "")], [CreneauHeures("", "")], [])
  ];

  List<CreneauDate> get creneauDates => _creneauDates;

  set creneauDates(List<CreneauDate> creneauDates) {
    _creneauDates = creneauDates;
  }

  addCrenau() {
    _creneauDates.add(CreneauDate(
        "", "", [CreneauHeures("", "")], [CreneauHeures("", "")], []));
  }

  removeCreneau(index) {
    _creneauDates.removeAt(index);
  }

  addDate(int type) {
    _dates.add(Date("", type, [CreneauHeures("", "")]));
  }

  removeDate(index) {
    _dates.removeAt(index);
  }

  getDatetoMapList() {
    List list = [];
    for (var element in _dates) {
      list.add(element.toMap());
    }
    return list;
  }

  getDatetoLocalMapList() {
    List list = [];
    for (var element in _dates) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  getCreneauDatetoMapList() {
    List list = [];
    for (var element in _creneauDates) {
      list.add(element.toMap());
    }
    return list;
  }

  getCreneauDatetoLocalMapList() {
    List list = [];
    for (var element in _creneauDates) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  Lieu(this._valeur, this._lat, this._long, this._dates);
  Map<String, dynamic> toMap() {
    return {
      'valeur': valeur,
      'lat': lat,
      'long': long,
      'dates': getDatetoMapList(),
      'creneaudates': getCreneauDatetoMapList(),
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "valeur": "$valeur",
      "lat": "$lat",
      "long": "$long",
      "dates": "${getDatetoLocalMapList()}",
      "creneaudates": "${getCreneauDatetoLocalMapList()}",
    };
  }

  factory Lieu.fromMap(dynamic map) {
    var madDecode = json.decode(json.encode(map));

    List l = madDecode['dates'] as List;

    List<Date> dates = l.map((model) {
      return Date.fromMap(model);
    }).toList();

    List l1 = madDecode['creneaudates'] as List;
    List<CreneauDate> creneauDates =
        l1.map((model) => CreneauDate.fromMap(model)).toList();

    var event = Lieu(
      madDecode['valeur'] ?? '',
      madDecode['lat'] ?? '',
      madDecode['long'] ?? '',
      dates ?? [],
    );
    event._creneauDates = creneauDates;
    return event;
  }
}

class CreneauDate {
  String _dateDebut;

  String get dateDebut => _dateDebut;

  set dateDebut(String dateDebut) {
    _dateDebut = dateDebut;
  }

  String _dateFin;

  String get dateFin => _dateFin;

  set dateFin(String dateFin) {
    _dateFin = dateFin;
  }

  List<CreneauHeures> _creneauHeures;

  List<CreneauHeures> get creneauHeures => _creneauHeures;

  set creneauHeures(List<CreneauHeures> creneauHeures) {
    _creneauHeures = creneauHeures;
  }

  List<CreneauHeures> _creneauHeuresWeek;

  List<CreneauHeures> get creneauHeuresWeek => _creneauHeuresWeek;

  set creneauHeuresWeek(List<CreneauHeures> creneauHeuresWeek) {
    _creneauHeuresWeek = creneauHeuresWeek;
  }

  List<Date> _dateParticulieres;

  List<Date> get dateParticulieres => _dateParticulieres;

  set dateParticulieres(List<Date> dateParticulieres) {
    _dateParticulieres = dateParticulieres;
  }

  addCreneauHeure() {
    _creneauHeures.add(CreneauHeures("", ""));
  }

  removeCreneauHeure(index) {
    _creneauHeures.removeAt(index);
  }

  addCreneauHeureWeek() {
    _creneauHeuresWeek.add(CreneauHeures("", ""));
  }

  removeCreneauHeureWeek(index) {
    _creneauHeuresWeek.removeAt(index);
  }

  addDateParticuliere() {
    _dateParticulieres.add(Date("", 1, [CreneauHeures("", "")]));
  }

  removeDateParticuliere(index) {
    _dateParticulieres.removeAt(index);
  }

  CreneauDate(this._dateDebut, this._dateFin, this._creneauHeures,
      this._creneauHeuresWeek, this._dateParticulieres);

  getCreneauHeuretoMap() {
    List list = [];
    for (var element in _creneauHeures) {
      list.add(element.toMap());
    }
    return list;
  }

  getCreneauHeuretoLocalMap() {
    List list = [];
    for (var element in _creneauHeures) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  getCreneauHeureWeektoMap() {
    List list = [];
    for (var element in _creneauHeuresWeek) {
      list.add(element.toMap());
    }
    return list;
  }

  getCreneauHeureWeektoLocalMap() {
    List list = [];
    for (var element in _creneauHeuresWeek) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  getDatetoMap() {
    List list = [];
    for (var element in _dateParticulieres) {
      list.add(element.toMap());
    }
    return list;
  }

  getDatetoLocalMap() {
    List list = [];
    for (var element in _dateParticulieres) {
      list.add(element.toLocalMap());
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'dateDebut': dateDebut,
      'dateFin': dateFin,
      'datesParticuliere': getDatetoMap(),
      'creneauHeuresWeek': getCreneauHeureWeektoMap(),
      'creneauHeures': getCreneauHeuretoMap(),
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      "dateDebut": "$dateDebut",
      "dateFin": "$dateFin",
      "datesParticuliere": "${getDatetoLocalMap()}",
      "creneauHeuresWeek": "${getCreneauHeureWeektoLocalMap()}",
      "creneauHeures": "${getCreneauHeuretoLocalMap()}",
    };
  }

  factory CreneauDate.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    List l = madDecode['datesParticuliere'] as List;
    List<Date> datesParticuliere =
        l.map((model) => Date.fromMap(model)).toList();
    //

    List l1 = madDecode['creneauHeures'] as List;
    List<CreneauHeures> creneauHeures =
        l1.map((model) => CreneauHeures.fromMap(model)).toList();

    //

    List l2 = madDecode['creneauHeuresWeek'] as List;
    List<CreneauHeures> creneauHeuresWeek =
        l2.map((model) => CreneauHeures.fromMap(model)).toList();

    return CreneauDate(map['dateDebut'] ??"", map['dateFin'] ?? '',
        creneauHeures ?? [], creneauHeuresWeek ?? [], datesParticuliere ?? []);
  }
}
