import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/action.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:flutter/material.dart';

import '../models/categorie.dart';

class DefaultUserProvider with ChangeNotifier {
  String _id = '';

  String get id => _id;

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

  String _userName = '';

  String get userName => _userName;

  set userName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  String _image = '';

  String get image => _image;

  set image(String image) {
    _image = image;
    notifyListeners();
  }

  String _imageType = '';

  String get imageType => _imageType;

  set imageType(String imageType) {
    _imageType = imageType;
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

  int _ageRangeId = 0;

  int get ageRangeId => _ageRangeId;

  set ageRangeId(int ageRangeId) {
    _ageRangeId = ageRangeId;
    notifyListeners();
  }

  int _paysId = 0;

  int get paysId => _paysId;

  set paysId(int paysId) {
    _paysId = paysId;
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

  String _token = '';

  String get token => _token;

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  Map _reseauInfo = {};

  Map get reseauInfo => _reseauInfo;

  set reseauInfo(Map reseauInfo) {
    _reseauInfo = reseauInfo;
    notifyListeners();
  }

  List<ActionUser> _actions = [];

  List<ActionUser> get actions => _actions;

  set actions(List<ActionUser> actions) {
    _actions = actions;
    notifyListeners();
  }

    List<Categorie> _categorieList = [];

  List<Categorie> get categorieList => _categorieList;

  set categorieList(List<Categorie> categorieList) {
    _categorieList = categorieList;
    notifyListeners();
  }

  Map _otp = {"loading": false};

  Map get otp => _otp;

  set otp(Map otp) {
    _otp = otp;
    notifyListeners();
  }

  otpload() {
    if (_otp['val1'] != null &&
        _otp['val2'] != null &&
        _otp['val3'] != null &&
        _otp['val4'] != null) {
      _otp['loading'] = true;
    } else {
      _otp['loading'] = false;
    }
    notifyListeners();
  }

  get otpValue {
    if (_otp['val1'] != null &&
        _otp['val2'] != null &&
        _otp['val3'] != null &&
        _otp['val4'] != null) {
      return "${_otp['val1']}${_otp['val2']}${_otp['val3']}${_otp['val4']}";
    }
  }

  otpPurge() {
    for (int i = 0; i < 4; i++) {
      _otp.removeWhere((key, value) => key.contains('val${i + 1}'));
    }
    _otp['loading'] = false;
    notifyListeners();
  }

  // ignore: unnecessary_new
  DefaultUser get toDefaulUserModel => new DefaultUser(
      _id,
      _ageRangeId,
      _codeTel1,
      _codeTel2,
      _email1,
      _email2,
      _image,
      _logged,
      _nom,
      _password,
      _paysId,
      _prenom,
      _reseauCode,
      _sexe,
      _tel1,
      _tel2,
      _ville);
  getDBImage(DefaultUser map) async {
    _sexe = map.sexe;
    _image = map.image;
    _imageType = (await SharedPreferencesHelper.getValue('ppType')) as String;
  }

  clearDBImage() {
    _sexe = '';
    _image = '';
    _imageType = '';
  }

  fromDefaultUser(DefaultUser map) {
    _id = map.id;
    _ageRangeId = map.ageRangeId;
    _codeTel1 = map.codeTel1;
    _codeTel2 = map.codeTel2;
    _email1 = map.email1;
    _email2 = map.email2;
    _image = map.image;
    _logged = map.logged;
    _nom = map.nom;
    _password = map.password;
    _paysId = map.paysId;
    _prenom = map.prenom;
    _reseauCode = map.reseauCode;
    _sexe = map.sexe;
    _tel1 = map.tel1;
    _tel2 = map.tel2;
    _ville = map.ville;
  }

  clear() {
    _id = "";
    _ageRangeId = 0;
    _codeTel1 = '';
    _codeTel2 = '';
    _email1 = '';
    _email2 = '';
    _imageType = '';
    _image = '';
    _logged = false;
    _nom = '';
    _password = '';
    _paysId = 0;
    _prenom = '';
    _reseauCode = '';
    _sexe = '';
    _tel1 = '';
    _tel2 = '';
    _ville = '';
    _actions = [];
    _token = '';
    _reseauInfo = {};
    return true;
  }

  clearUserInfos() {
    _id = "";
    _ageRangeId = 0;
    _codeTel1 = '';
    _codeTel2 = '';
    _email1 = '';
    _email2 = '';
    _image = '';
    _logged = false;
    _nom = '';
    _password = '';
    _paysId = 0;
    _prenom = '';
    _reseauCode = '';
    _sexe = '';
    _tel1 = '';
    _tel2 = '';
    _ville = '';
    _imageType = '';
    notifyListeners();
  }

  fromAPIUserMap(Map map) async {
    if (map.containsKey('id')) {
      _id = map['id'].toString() ?? '';
    }
    if (map.containsKey('age_range_id')) {
      _ageRangeId = int.parse(map['age_range_id'].toString()) ?? 0;
    }
    if (map.containsKey('email')) {
      _email1 = map['email'] ?? '';
    }
    if (map.containsKey('nom')) {
      _nom = map['nom'] ?? '';
    }
    if (map.containsKey('prenom')) {
      _prenom = map['prenom'] ?? '';
    }

    if (map.containsKey('tel')) {
      _tel1 = map['tel'] ?? '';
    }
    if (map.containsKey('telephone')) {
      _tel1 = map['telephone'] ?? '';
    }
    if (map.containsKey('ville')) {
      _ville = map['ville'] ?? '';
    }

    if (map.containsKey('pays_id')) {
      _paysId = int.parse(map['pays_id'].toString()) ?? 0;/*int.parse(map['pays_id'])*/
    }

    if (map.containsKey('sexe')) {
      if (map['sexe'] == 'M') {
        _sexe = 'Homme';
      } else {
        _sexe = map['sexe'] == 'F' ? 'Femme' : '';
      }
    }
    if (map.containsKey('cleRS')) {
      _reseauCode = map['cleRS'] ?? '';
    }
    if (map.containsKey('picture')) {
      _image = map['picture'] ?? '';
    }
    notifyListeners();
  }

  getDBimage() async {
    List user;
    user = await UserDBcontroller().liste() as List;
    return user[0].image;
  }

  clearAndNotify() {
    clear();
    notifyListeners();
  }
}
