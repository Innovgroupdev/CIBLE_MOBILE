import 'package:cible/constants/api.dart';
import 'package:cible/database/actionController.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class UserLocation {
  static double lat = 0;
  static double long = 0;
}

register(context) async {
  // Insertion via API

  registerUserInAPI(Provider.of<DefaultUserProvider>(context, listen: false)
      .toDefaulUserModel);

  // Insertion en local

  await UserDBcontroller().insert(
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel);
  Provider.of<DefaultUserProvider>(context, listen: false).actions.forEach(
    (element) async {
      await ActionDBcontroller().insert(element);
    },
  );

  SharedPreferencesHelper.setBoolValue("logged", true);
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacementNamed(context, '/acceuil');
  return true;
}

void registerUserInAPI(DefaultUser user) async {
  try {
    var response =
        await Dio().post('${baseApiUrl}/auth/particuler/register', data: {
      'email': user.email1,
      'password': user.password,
      'nom': user.nom,
      'prenom': user.prenom,
      'tel': user.tel1,
      'ville': user.ville,
      'pays': user.pays,
      'sexe': user.sexe,
      'dateNaiss': user.birthday,
      'cleRs': user.reseauCode,
      'libellers': user.reseauCode,
      'picture': user.image
    });
    print(response);
  } catch (e) {
    print(e);
  }
}
