import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:http/http.dart' as http;

modifyFavoris(int id, int eventId) async {
  Map<String, dynamic> data = {
    'user_particulier_id': id,
    'favoris': 4, //pour l'insant livlic
  };
  var response = await http.put(
      Uri.parse('$baseApiUrl/events/favoris/$eventId'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print('bommmmmmmmmmm' + response.body.toString());
}
