import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/services/userDBService.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

apiUpdateUser(context, DefaultUser user) async {
  var token = await SharedPreferencesHelper.getValue('token');
  print(token);
  try {
    Map<String, dynamic> data1 = {
      'email': user.email1,
      'password': user.password,
      'nom': user.nom,
      'prenom': user.prenom,
      'tel': user.tel1.trim().contains('+') || user.tel1.trim().startsWith('00')
          ? user.tel1
          : user.codeTel1 + user.tel1,
      'ville': user.ville,
      'pays': user.pays,
      'sexe': user.sexe == 'Homme' ? 0 : 1,
      'dateNaiss': user.birthday,
      'cleRs': user.reseauCode,
      'libelleRs': user.reseauCode,
      'picture': user.image
    };
    print(data1);
    var response = await http.post(Uri.parse('${baseApiUrl}/modifierprofile'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data1));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await dbupdateUser(context, user);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
