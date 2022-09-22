import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Action {
  String id = "";
  String image = "";
  String titre = "";
  String description = "";
  int type = 0;
  bool etat = false;
  dynamic user = {};

  Action(this.id, this.image, this.titre, this.description);

  bool getEtat() {
    return this.etat;
  }

  changeEtat() {
    this.etat = !this.etat;
  }
}

List actions = [
  Action("0", "https://cdn-icons-png.flaticon.com/512/432/432312.png",
      "Voir et acheter des tickets", "Voir et acheter des tickets"),
  Action(
      "1",
      "https://cdn-icons-png.flaticon.com/512/7316/7316975.png",
      "Etre recruter pour des évènnements",
      "Etre recruter pour des évènnements"),
  Action("2", "https://cdn-icons-png.flaticon.com/512/1672/1672241.png",
      "Investir dans les évènnements", "Investir dans les évènnements"),
  Action("3", "https://cdn-icons-png.flaticon.com/512/829/829452.png",
      "Sponsoriser des évènnements", "Sponsoriser évènnements"),
];
