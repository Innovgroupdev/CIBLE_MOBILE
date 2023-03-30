import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:http/http.dart' as http;

import '../../helpers/sharePreferenceHelper.dart';

removeFavoris(int eventId) async {
 var token = await SharedPreferencesHelper.getValue('token');
  
      //print('eeeeeeeeee55555');
  var response = await http.post(
      Uri.parse('$baseApiUrl/event/$eventId/removetofavori'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });
  print('eeeeeeeeee55555'+response.body.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == 'success') {
      print('eeeeeeeeee23333'+responseBody['status']);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

addFavoris(int eventId) async {
  var token = await SharedPreferencesHelper.getValue('token');
  
      print('middddddddd'+eventId.toString());
  var response = await http.post(
      Uri.parse('$baseApiUrl/event/$eventId/addtofavori'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });
  print('eeeeeeeeee'+response.body.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == 'success') {
      print('eeeeeeeeee'+responseBody['status']);
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
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
  //print(response.body.toString());
}
