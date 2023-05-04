import 'package:flutter/cupertino.dart';

class PayementProvider extends ChangeNotifier {
  int _idCommande = 0;
  List _recap = [];

  int get idCommande => _idCommande;
  List get recap => _recap;

  void setIdCommande(int newIdCommande) {
    _idCommande = newIdCommande;
    notifyListeners();
  }

  void setRecap(List newRecap) {
    _recap = newRecap;
    notifyListeners();
  }
}
