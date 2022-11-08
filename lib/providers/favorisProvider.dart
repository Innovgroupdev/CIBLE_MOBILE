import 'package:flutter/widgets.dart';

class FavorisProvider with ChangeNotifier {
  String _titre = '';
  String _image = '';
  String _auteur = '';
  String _like = '';

  String get titre => _titre;
  String get image => _image;
  String get auteur => _auteur;
  String get like => _like;

  void setTitre(String titre) {
    _titre = titre;
    notifyListeners();
  }

  void setImage(String image) {
    _image = image;
    notifyListeners();
  }

  void setAuteur(String auteur) {
    _auteur = auteur;
    notifyListeners();
  }

  void setLike(String like) {
    _like = like;
    notifyListeners();
  }
}
