import 'package:cible/models/defaultUser.dart';
import 'package:flutter/material.dart';

class DefaultUserProvider with ChangeNotifier {
  String _id = "";

  String get id => _id;

  set id(String id) {
    _id = id;
    notifyListeners();
  }

  bool _logged = false;

  bool get logged => _logged;

  set logged(bool logged) {
    _logged = logged;
    notifyListeners();
  }

  String _password = '';

  String get password => _password;

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _sexe = '';

  String get sexe => _sexe;

  set sexe(String sexe) {
    _sexe = sexe;
    notifyListeners();
  }

  String _email1 = '';

  String get email1 => _email1;

  set email1(String email1) {
    _email1 = email1;
    notifyListeners();
  }

  String _email2 = '';

  String get email2 => _email2;

  set email2(String email2) {
    _email2 = email2;
    notifyListeners();
  }

  String _nom = '';

  String get nom => _nom;

  set nom(String nom) {
    _nom = nom;
    notifyListeners();
  }

  String _prenom = '';

  String get prenom => _prenom;

  set prenom(String prenom) {
    _prenom = prenom;
    notifyListeners();
  }

  String _image = '';

  String get image => _image;

  set image(String image) {
    _image = image;
    notifyListeners();
  }

  String _codeTel1 = '';

  String get codeTel1 => _codeTel1;

  set codeTel1(String codeTel1) {
    _codeTel1 = codeTel1;
    notifyListeners();
  }

  String _tel1 = '';

  String get tel1 => _tel1;

  set tel1(String tel1) {
    _tel1 = tel1;
    notifyListeners();
  }

  String _codeTel2 = '';

  String get codeTel2 => _codeTel2;

  set codeTel2(String codeTel2) {
    _codeTel2 = codeTel2;
    notifyListeners();
  }

  String _tel2 = '';

  String get tel2 => _tel2;

  set tel2(String tel2) {
    _tel2 = tel2;
    notifyListeners();
  }

  String _birthday = '';

  String get birthday => _birthday;

  set birthday(String birthday) {
    _birthday = birthday;
    notifyListeners();
  }

  String _pays = '';

  String get pays => _pays;

  set pays(String pays) {
    _pays = pays;
    notifyListeners();
  }

  String _ville = '';

  String get ville => _ville;

  set ville(String ville) {
    _ville = ville;
    notifyListeners();
  }

  String _reseauCode = '';

  String get reseauCode => _reseauCode;

  set reseauCode(String reseauCode) {
    _reseauCode = reseauCode;
    notifyListeners();
  }

  Map _reseauInfo = {};

  Map get reseauInfo => _reseauInfo;

  set reseauInfo(Map reseauInfo) {
    _reseauInfo = reseauInfo;
    notifyListeners();
  }

  List _actions = [];

  List get actions => _actions;

  set actions(List actions) {
    _actions = actions;
    notifyListeners();
  }

  Map _otp = {"loading": false};

  Map get otp => _otp;

  set otp(Map otp) {
    _otp = otp;
    notifyListeners();
  }

  otpload() {
    _otp['loading'] = true;
    notifyListeners();
  }

  // ignore: unnecessary_new
  DefaultUser get toDefaulUserModel => new DefaultUser(
      _id,
      _birthday,
      _codeTel1,
      _codeTel2,
      _email1,
      _email2,
      _image,
      _logged,
      _nom,
      _password,
      _pays,
      _prenom,
      _reseauCode,
      _sexe,
      _tel1,
      _tel2,
      _ville);
}
