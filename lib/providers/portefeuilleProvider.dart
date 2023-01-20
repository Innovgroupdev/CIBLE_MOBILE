import 'package:flutter/widgets.dart';

class PortefeuilleProvider extends ChangeNotifier {
  double _solde = 100000;

  double get solde => _solde;

  void setSolde(double newSolde) {
    _solde = newSolde;
    notifyListeners();
  }
}
