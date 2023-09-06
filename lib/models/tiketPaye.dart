import 'dart:convert';

import 'package:cible/models/Event.dart';
import 'package:cible/models/date.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../database/userDBcontroller.dart';
import '../helpers/sharePreferenceHelper.dart';

class TicketPaye {
  int _id;
  int get id => _id;

  set id(int id) {
    _id = id;
  }

  int _eventId;
  int get eventId => _eventId;

  set eventId(int eventId) {
    _eventId = eventId;
  }

  bool isexp = false;

  bool isSelected = false;
  String _libelle;
  String get libelle => _libelle;

  set libelle(String libelle) {
    _libelle = libelle;
  }

  String _titre;
  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  bool _isReported;
  bool get isReported => _isReported;

  set isReported(bool isReported) {
    _isReported = isReported;
  }

  bool _isCancelled;
  bool get isCancelled => _isCancelled;

  set isCancelled(bool _isCancelled) {
    _isCancelled = _isCancelled;
  }

  String _dateCreation;
  String get dateCreation => _dateCreation;

  set dateCreation(String dateCreation) {
    _dateCreation = dateCreation;
  }

  String _avantages;
  String get avantages => _avantages;

  set avantages(String avantages) {
    _avantages = avantages;
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

  String _descriptionEvent;

  String get descriptionEvent => _descriptionEvent;

  set descriptionEvent(String descriptionEvent) {
    _descriptionEvent = descriptionEvent;
  }

  String _codeQr;

  String get codeQr => _codeQr;

  set codeQr(String codeQr) {
    _codeQr = codeQr;
  }

  String _ticketAccessToken;

  String get ticketAccessToken => _ticketAccessToken;

  set ticketAccessToken(String ticketAccessToken) {
    _ticketAccessToken = ticketAccessToken;
  }

  Event1 _event;

  Event1 get event => _event;

  set event(Event1 events) {
    _event = events;
  }

  TicketPaye(
      this._id,
      this._eventId,
      this._titre,
      this._libelle,
      this._prix,
      this._nombrePlaces,
      this._description,
      this._descriptionEvent,
      this._dateCreation,
      this._isReported,
      this._isCancelled,
      this._event,
      this._avantages,
      this._codeQr,
      this._ticketAccessToken);

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
      madDecode['evenement']['id'],
      madDecode['evenement']['titre'] ?? '',
      madDecode['ticket']['libelle'],
      double.parse('${madDecode['ticket']['prix']}'),
      int.parse(madDecode['ticket']['nb_place'] ?? '0'),
      madDecode['ticket']['desc'] ?? "",
      madDecode['evenement']['desc'] ?? "",
      madDecode['evenement']['created_at'] ?? '',
      madDecode['evenement']['reported'] == 1,
      madDecode['evenement']['cancelled'] == 1,
      Event1.fromMap(madDecode['evenement'] /*, null*/),
      madDecode['ticket']['avantages'] ?? '',
      madDecode['code_qr'],
      madDecode['ticket_access_token'] ?? '',
    );
    return event;
  }
}

userReclamation(int eventId) async {
  var users;
  users = await UserDBcontroller().liste() as List;
  int userId = int.parse(users[0].id);
  var token = await SharedPreferencesHelper.getValue('token');
  //print(userId.runtimeType.toString());
  var response = await http.post(
    Uri.parse('$baseApiUrl/event/requestrefund/$eventId/$userId'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  //print(response.body.toString());
}
