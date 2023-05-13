import 'dart:convert';
import 'dart:io';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/services/userDBService.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

apiUpdateUser(context, DefaultUser user) async {
  var token = await SharedPreferencesHelper.getValue('token');
     var pictureExtension = 
   user.image == ''?
   null:
   user.image.contains('https://')?
   null:
  p.extension(File(user.image).path).split('.');
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
      'pays': user.paysId,
      'sexe': user.sexe == 'Homme' ? 'M' : 'F',
      'age_range_id': user.ageRangeId,
      'cleRs': user.reseauCode,
      'libelleRs': user.reseauCode,
      'picture': user.image == '' ? null :
      user.image.contains('https://') ? user.image:
      base64Encode(File(user.image).readAsBytesSync()),
      'picture_extension': (user.image == '' || user.image.contains('https://'))?null:
       pictureExtension![1]
    };
    print(data1);
    var response = await http.post(Uri.parse('${baseApiUrl}/modifierprofile'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data1));
    print('data that I need'+jsonEncode(data1));

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
