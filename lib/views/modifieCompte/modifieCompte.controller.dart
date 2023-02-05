import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/userDBService.dart';
import 'package:cible/views/modifieCompte/modifieCompte.httpService.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

updateUser(context) async {
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('nom')) {
    Provider.of<DefaultUserProvider>(context, listen: false).nom =
        Provider.of<AppManagerProvider>(context, listen: false).userTemp['nom'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('prenom')) {
    Provider.of<DefaultUserProvider>(context, listen: false).prenom =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['prenom'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('email')) {
    Provider.of<DefaultUserProvider>(context, listen: false).email1 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['email'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('sexe')) {
    Provider.of<DefaultUserProvider>(context, listen: false).sexe =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['sexe'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('birthday')) {
    Provider.of<DefaultUserProvider>(context, listen: false).birthday =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['birthday'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('tel1')) {
    Provider.of<DefaultUserProvider>(context, listen: false).tel1 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['tel1'];
  }

  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('tel2')) {
    Provider.of<DefaultUserProvider>(context, listen: false).tel2 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['tel2'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('codeTel1')) {
    Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['codeTel1'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('codeTel2')) {
    Provider.of<DefaultUserProvider>(context, listen: false).codeTel2 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['codeTel2'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('codeTel2')) {
    Provider.of<DefaultUserProvider>(context, listen: false).codeTel2 =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['codeTel2'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('pays')) {
    Provider.of<DefaultUserProvider>(context, listen: false).paysId =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['pays'];
  }
  if (Provider.of<AppManagerProvider>(context, listen: false)
      .userTemp
      .containsKey('ville')) {
    Provider.of<DefaultUserProvider>(context, listen: false).ville =
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['ville'];
  }
  if (await apiUpdateUser(
      context,
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel)) {
    return true;
  } else {
    return false;
  }
}
