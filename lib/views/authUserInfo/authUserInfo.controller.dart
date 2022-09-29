import 'package:cible/database/actionController.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserLocation {
  static double lat = 0;
  static double long = 0;
}

register(context) async {
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
