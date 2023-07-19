import 'dart:convert';

class Marque {
  String libelle;

  String description;

  Marque({required this.libelle, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'nom': libelle,
      'presentation': description,
    };
  }

  factory Marque.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));

    var event = Marque(
      libelle: madDecode['nom'] ?? '',
      description: madDecode['presentation'] ?? '',
    );
    return event;
  }
}
