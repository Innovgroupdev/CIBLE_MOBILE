import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:http/http.dart' as http;

modifyFavoris(int eventId, int favoris) async {
  print(favoris.toString());
  Map<String, dynamic> data = {
    'favoris': favoris, //pour l'insant livlic
  };
  var response = await http.put(
      Uri.parse('$baseApiUrl/events/favoris/$eventId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.body.toString());
}

modifyNbShare(int eventId, int nbShare) async {
  print(nbShare.toString());
  Map<String, dynamic> data = {
    'nb_share': nbShare, //pour l'insant livlic
  };
  var response = await http.put(Uri.parse('$baseApiUrl/events/shared/$eventId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.body.toString());
}
