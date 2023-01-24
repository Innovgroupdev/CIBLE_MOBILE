class DefaultUser {
  int  _id = 0;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  bool _logged = false;

  bool get logged => _logged;

  set logged(bool logged) {
    _logged = logged;
  }

  String _password = '';

  String get password => _password;

  set password(String password) {
    _password = password;
  }

  String _sexe = '';

  String get sexe => _sexe;

  set sexe(String sexe) {
    _sexe = sexe;
  }

  String _email1 = '';

  String get email1 => _email1;

  set email1(String email1) {
    _email1 = email1;
  }

  String _email2 = '';

  String get email2 => _email2;

  set email2(String email2) {
    _email2 = email2;
  }

  String _nom = '';

  String get nom => _nom;

  set nom(String nom) {
    _nom = nom;
  }

  String _prenom = '';

  String get prenom => _prenom;

  set prenom(String prenom) {
    _prenom = prenom;
  }

  String _image = '';

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  String _codeTel1 = '';

  String get codeTel1 => _codeTel1;

  set codeTel1(String codeTel1) {
    _codeTel1 = codeTel1;
  }

  String _tel1 = '';

  String get tel1 => _tel1;

  set tel1(String tel1) {
    _tel1 = tel1;
  }

  String _codeTel2 = '';

  String get codeTel2 => _codeTel2;

  set codeTel2(String codeTel2) {
    _codeTel2 = codeTel2;
  }

  String _tel2 = '';

  String get tel2 => _tel2;

  set tel2(String tel2) {
    _tel2 = tel2;
  }

  String _birthday = '';

  String get birthday => _birthday;

  set birthday(String birthday) {
    _birthday = birthday;
  }

  String _pays = '';

  String get pays => _pays;

  set pays(String pays) {
    _pays = pays;
  }

  String _ville = '';

  String get ville => _ville;

  set ville(String ville) {
    _ville = ville;
  }

  String _reseauCode = '';

  String get reseauCode => _reseauCode;

  set reseauCode(String reseauCode) {
    _reseauCode = reseauCode;
  }

  DefaultUser(
      this._id,
      this._birthday,
      this._codeTel1,
      this._codeTel2,
      this._email1,
      this._email2,
      this._image,
      this._logged,
      this._nom,
      this._password,
      this._pays,
      this._prenom,
      this._reseauCode,
      this._sexe,
      this._tel1,
      this._tel2,
      this._ville);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email1': email1,
      'email2': email2,
      'nom': nom,
      'prenom': prenom,
      'tel1': tel1,
      'tel2': tel2,
      'codeTel1': codeTel1,
      'codeTel2': codeTel2,
      'birthday': birthday,
      'logged': logged,
      'image': image,
      'password': password,
      'pays': pays,
      'ville': ville,
      'sexe': sexe,
      'reseauCode': reseauCode,
    };
  }

  factory DefaultUser.fromMap(Map map) {
    return DefaultUser(
        map['id'] ?? 0,
        map['birthday'],
        map['codeTel1'],
        map['codeTel2'],
        map['email1'],
        map['email2'],
        map['image'],
        map['logged'] == 0,
        map['nom'],
        map['password'],
        map['pays'],
        map['prenom'],
        map['reseauCode'],
        map['sexe'],
        map['tel1'],
        map['tel2'],
        map['ville']);
  }
}
