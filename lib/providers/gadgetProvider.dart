import 'package:cible/models/gadget.dart';
import 'package:cible/models/modelGadgetUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:flutter/widgets.dart';

class ModelGadgetProvider extends ChangeNotifier {
  List<ModelGadgetUser> _gadgetsList = [];
  double _total = 0;

  List<ModelGadgetUser> get gadgetsList => _gadgetsList;
  double get total => _total;

  void setTotal(double newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void setGadgetsList(List<ModelGadgetUser> newGadgetsList) {
    _gadgetsList = newGadgetsList;
    notifyListeners();
  }

  void addGadget(ModelGadgetUser newGadget) {
    for (var t in gadgetsList) {
      if (identical(newGadget.gadget, t.gadget)) {
        newGadget.quantite = newGadget.quantite + t.quantite;
        _gadgetsList.add(newGadget);
        removeGadget(t);
        return;
      }
    }
    _gadgetsList.add(newGadget);
    notifyListeners();
  }

  void removeGadget(ModelGadgetUser oldGadget) {
    _gadgetsList.remove(oldGadget);
    notifyListeners();
  }
}
