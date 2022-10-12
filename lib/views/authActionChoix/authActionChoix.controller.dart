import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/action.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';

// Future actions = [
// ActionUser("0", "https://cdn-icons-png.flaticon.com/512/432/432312.png",
//     "Voir et acheter des tickets", "Voir et acheter des tickets", "0", false),
// ActionUser(
//     "1",
//     "https://cdn-icons-png.flaticon.com/512/7316/7316975.png",
//     "Etre recruter pour des évènnements",
//     "Etre recruter pour des évènnements",
//     "0",
//     false),
// ActionUser(
//     "2",
//     "https://cdn-icons-png.flaticon.com/512/1672/1672241.png",
//     "Investir dans les évènnements",
//     "Investir dans les évènnements",
//     "0",
//     false),
// ActionUser("3", "https://cdn-icons-png.flaticon.com/512/829/829452.png",
//     "Sponsoriser des évènnements", "Sponsoriser évènnements", "0", false),
// ];
dynamic actions;

remplieActionListe(responseBody) {
  // ignore: prefer_typing_uninitialized_variables
  List tab = [];
  for (int i = 0; i < responseBody.length; i++) {
    print(responseBody[i]);
    if (responseBody[i]['id'] != null) {
      // ignore: unnecessary_new
      tab.add(new ActionUser(
          responseBody[i]['id'].toString(),
          responseBody[i]['icon'],
          responseBody[i]['libelle'],
          responseBody[i]['libelle'],
          responseBody[i]['is_choice'].toString(),
          false));
    }
  }
  return tab;
}

addActionToUser(context) async {
  var status = false;
  var response;
  List actionSelected =
      Provider.of<DefaultUserProvider>(context, listen: false).actions;
  var token = await SharedPreferencesHelper.getValue('token');
  Map<String, dynamic> data = {'access_token': token, 'token_type': 'bearer'};
  print('token add Action : ' + token);
  for (int i = 0; i < actionSelected.length; i++) {
    response = await http.post(
        Uri.parse('$baseApiUrl/addactions/${actionSelected[i].titre}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));

    print(response.statusCode);
    print(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      status = true;
    } else {
      status = false;
    }
  }
  // return status;
}
