// ignore_for_file: unnecessary_this

class NotificationModel {
  int _id;
  String _image = "";
  String _titre = "";
  String _type = "0";
  String _description = "";
  bool _etat = false;

  int get id => _id;
  String get image => _image;
  String get titre => _titre;
  String get description => _description;
  String get type => _type;
  bool get etat => _etat;

  set id(int id) {
    _id = id;
  }

  set image(String image) {
    _image = image;
  }

  set titre(String titre) {
    _titre = titre;
  }

  set description(String description) {
    _description = description;
  }

  set type(String type) {
    _type = type;
  }

  set etat(bool etat) {
    _etat = etat;
  }

  NotificationModel(this._id, this._image, this._titre, this._description,
      this._type, this._etat);

  bool getEtat() {
    return etat;
  }

  setEtat() {
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

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(map['id'], map['image'], map['titre'],
        map['description'], map['type'], map['etat'] == "1" ? true : false);
  }
}
