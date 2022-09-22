import 'package:cible/database/userDBcontroller.dart';
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
  Navigator.pushNamed(context, '/acceuil');
  return true;
}
