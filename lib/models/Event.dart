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
