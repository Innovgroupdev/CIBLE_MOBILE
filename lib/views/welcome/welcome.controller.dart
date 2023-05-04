import 'package:cible/core/routes.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:flutter/material.dart';

gotonextPage(context) async {
  var pagePosition = await getSharepreferencePagePosition();
  var logged = await SharedPreferencesHelper.getBoolValue("logged");
  print(pagePosition);
  if (logged == true) {
    print("Connecté !");
    Navigator.pushReplacementNamed(context, '/acceuil');
    return;
  } else {
    switch (pagePosition) {
      case 0:
        Navigator.pushReplacementNamed(context, '/splash');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/auth');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/actions', arguments: {});
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/authUserInfo', arguments: {});
        break;
      default:
        Navigator.pushReplacementNamed(context, '/splash');
    }
  }
}
