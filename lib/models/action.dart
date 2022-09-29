// ignore_for_file: unnecessary_this

class ActionUser {
  String _id = "";

  String get id => _id;

  set id(String id) {
    _id = id;
  }

  String _image = "";

  String get image => _image;

  set image(String image) {
    _image = image;
  }

  String _titre = "";

  String get titre => _titre;

  set titre(String titre) {
    _titre = titre;
  }

  String _description = "";

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  String _type = "0";

  String get type => _type;

  set type(String type) {
    _type = type;
  }

  bool _etat = false;

  bool get etat => _etat;

  set etat(bool etat) {
    _etat = etat;
  }

  ActionUser(this._id, this._image, this._titre, this._description, this._type,
      this._etat);

  bool getEtat() {
    return etat;
  }

  changeEtat() {
    this.etat = !this.etat;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'titre': titre,
      'description': description,
      'type': type,
      'etat': etat ? "1" : "0",
    };
  }

  factory ActionUser.fromMap(Map map) {
    return ActionUser(map['id'], map['image'], map['titre'], map['description'],
        map['type'], map['etat'] == "1" ? true : false);
  }
}
