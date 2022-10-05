import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/database/actionController.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class UserLocation {
  static double lat = 0;
  static double long = 0;
}

registerUserInAPI(context, DefaultUser user) async {
  try {
    // Map<String, String> data = {
    //   'email': user.email1,
    //   'password': user.password,
    //   'nom': user.nom,
    //   'prenom': user.prenom,
    //   'tel': user.tel1,
    //   'ville': user.ville,
    //   'pays': user.pays,
    //   'sexe': user.sexe,
    //   'dateNaiss': user.birthday,
    //   'cleRs': user.reseauCode,
    //   'libelleRs': user.reseauCode,
    //   'picture': user.image
    // };
    Map<String, dynamic> data1 = {
      'email': user.email1,
      'password': user.password,
      'nom': user.nom,
      'prenom': user.prenom,
      'tel': user.tel1,
      'ville': user.ville,
      'pays': user.pays,
      'sexe': '',
      'dateNaiss': null,
      'cleRs': user.reseauCode,
      'libelleRs': user.reseauCode,
      'picture': user.image
    };
    print(jsonEncode(data1));
    var response = await http.post(
        Uri.parse('${baseApiUrl}/auth/particular/register'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data1));
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await registerUserDB(context, user);
      
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

registerUserDB(context, user) async {
  await UserDBcontroller().insert(
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel);
  Provider.of<DefaultUserProvider>(context, listen: false).actions.forEach(
    (element) async {
      await ActionDBcontroller().insert(element);
    },
  );
}
