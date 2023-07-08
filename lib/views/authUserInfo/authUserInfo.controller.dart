import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/database/actionController.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserLocation {
  static double lat = 0;
  static double long = 0;
}

registerUserInAPI(context, DefaultUser user) async {
  final prefs = await SharedPreferences.getInstance();
  final deviceId = await prefs.getString('deviceId');
  final fcmToken = await prefs.getString('fcmToken');
  print('rrrrrrrrrr'+user.toMap().toString());
  try {
    if (user.reseauCode.isNotEmpty) {
      if (await registerUserReseauInAPI(context, user)) {
        return true;
      }
      return false;
    }
    Map<String, dynamic> data1 = {
      'email': user.email1,
      'password': user.password,
      'nom': user.nom,
      'prenom': user.prenom,
      'tel': user.tel1.trim().contains('+') || user.tel1.trim().startsWith('00')
          ? user.tel1
          : user.codeTel1 + user.tel1,
      'ville': user.ville,
      'pays': user.paysId,
      'sexe': user.sexe == 'Homme' ? 'M' : 'F',
      'age_range_id': user.ageRangeId,
      'cleRs': user.reseauCode,
      'libelleRs': user.reseauCode,
      'picture': user.image,
      'user_type': "part"
      //'unique_reference' : deviceId,
    };
    var response = await http.post(
        Uri.parse('$baseApiUrl/users/register'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data1));
        
    print(jsonDecode(response.body));
    var responseBody = jsonDecode(response.body) as Map;
    if (response.statusCode == 200 || response.statusCode == 201) {
      Provider.of<DefaultUserProvider>(context, listen: false)
          .fromAPIUserMap(responseBody['data']);
      await registerUserDB(context, user);
      // await SharedPreferencesHelper.setBoolValue('key', true);
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
  Provider.of<DefaultUserProvider>(context, listen: false).password =
      await SharedPreferencesHelper.getValue('password');
      print('tggggggggggggggggggggg'+Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel.paysId.toString());
  await UserDBcontroller().insert(
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel);
  await ActionDBcontroller().vider();
  Provider.of<DefaultUserProvider>(context, listen: false).actions.forEach(
    (element) async {
      await ActionDBcontroller().insert(element);
    },
  );
}

 


registerUserReseauInAPI(context, DefaultUser user) async {
  Map<String, dynamic> data1 = {
    'nom': user.nom,
    'email': user.reseauCode == 'insta'
        ? '${Provider.of<DefaultUserProvider>(context, listen: false).userName}@cible.com'
        : user.email1,
    'id_rs': user.reseauCode,
    'prenom': user.prenom,
    'photo': user.image,
    // 'password': '123userpro@cible',
    'username':
        Provider.of<DefaultUserProvider>(context, listen: false).userName,
    // ignore: equal_keys_in_map
    'id_rs': user.reseauCode
  };
  var response = await http.post(
      Uri.parse('$baseApiUrl/storesocialinfos/${user.reseauCode}/part'),
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
}
