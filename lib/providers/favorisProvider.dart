import 'package:flutter/widgets.dart';

class FavorisProvider with ChangeNotifier {
  final String _titre = '';
  final String _image = '';
  final String _auteur = '';
  final String _like = '';

  String get titre => _titre;
  String get image => _image;
  String get auteur => _auteur;
  String get like => _like;

  
}
