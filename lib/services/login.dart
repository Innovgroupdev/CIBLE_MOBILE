import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/userDBService.dart';
import 'package:cible/views/authUserInfo/authUserInfo.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:cible/constants/instagramApi.dart' as instagramApi;
import 'package:cible/constants/linkedinApi.dart' as linkedinAPi;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'dart:async';

Future<void> logoutPopup(context) async {
  bool etat = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(Device.getScreenHeight(context) / 70),
          child: Container(
            height: Device.getDiviseScreenHeight(context, 3),
            width: Device.getDiviseScreenWidth(context, 1.2),
            color: Provider.of<AppColorProvider>(context, listen: false).white,
            padding: EdgeInsets.symmetric(
                horizontal: Device.getScreenHeight(context) / 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.warning_rounded,
                    size: Device.getDiviseScreenHeight(context, 20),
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .primary,
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 100,
                ),
                Text(
                  "Se déconnecter de CIBLE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.titre4(context),
                      fontWeight: FontWeight.w800,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black54),
                ),
                Text(
                  "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p3(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(
                              Device.getDiviseScreenHeight(context, 70)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                              width: 0.7,
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black26),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Annuler",
                                style: GoogleFonts.poppins(
                                    color: Provider.of<AppColorProvider>(
                                            context,
                                            listen: false)
                                        .black87,
                                    fontSize: AppText.p2(context)),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          etat = true;
                          if (!await logout(context)) {
                            etat = false;
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(
                              Device.getDiviseScreenHeight(context, 70)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                              width: 0.7,
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black26),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Se déconnecter",
                                style: GoogleFonts.poppins(
                                    color: Provider.of<AppColorProvider>(
                                            context,
                                            listen: false)
                                        .primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppText.p2(context)),
                              ),
                            ]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

logout(context) async {
  if (Provider.of<DefaultUserProvider>(context, listen: false)
      .reseauCode
      .isNotEmpty) {
    if (Provider.of<DefaultUserProvider>(context, listen: false).reseauCode ==
        "face") {
      await facebookLogout();
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false).reseauCode ==
        "link") {
      linkedinLogout();
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false).reseauCode ==
        "insta") {
      instagramLogout();
    }
  }
  if (await logoutfromAPI(context)) {
    await SharedPreferencesHelper.setBoolValue("logged", false);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/login');
    return true;
  } else {
    Navigator.pop(context);
    return false;
  }
}

facebookLogout() async {
  await FacebookAuth.instance.logOut();
}

linkedinLogout() async {
  LinkedInUserWidget(
    redirectUrl: linkedinAPi.redirectUrl,
    clientId: linkedinAPi.clientId,
    clientSecret: linkedinAPi.clientSecret,
    destroySession: true,
    onGetUserProfile: (UserSucceededAction value) {},
  );
}

instagramLogout() async {
  await FacebookAuth.instance.logOut();
}

logoutfromAPI(context) async {
  var token = await SharedPreferencesHelper.getValue('token');
  print('token : ' + token);
  Map<String, dynamic> data = {'access_token': token, 'token_type': 'bearer'};
  var response = await http.post(Uri.parse('$baseApiUrl/particular/logout'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data));
  print('logout code ${response.statusCode}');
  if (response.statusCode == 200 || response.statusCode == 201) {
    await SharedPreferencesHelper.setValue("token", '');
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
    imageCache.clear();
    return true;
  } else {
    return true;
  }
}

loginUser(context, user) async {
  if (user.reseauCode.isNotEmpty) {
    print(user.email1);
    if (await loginUserReseau(context, user.email1)) {
      return true;
    }
    return false;
  }
  Map<String, dynamic> data = {
    'email': user.email1,
    'password': user.password,
  };
  print(jsonEncode(data));
  var response = await http.post(Uri.parse('$baseApiUrl/auth/particular/login'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));

  print(jsonDecode(response.body));

  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body) as Map;
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
    await SharedPreferencesHelper.setValue("ppType", '');
    imageCache.clear();

    Provider.of<DefaultUserProvider>(context, listen: false)
        .fromAPIUserMap(responseBody['user']);
    Provider.of<DefaultUserProvider>(context, listen: false).password =
        await SharedPreferencesHelper.getValue('password');
    await registerUserDB(
        context,
        Provider.of<DefaultUserProvider>(context, listen: false)
            .toDefaulUserModel);
    Provider.of<DefaultUserProvider>(context, listen: false).token =
        responseBody['access_token'].toString();
    await SharedPreferencesHelper.setValue(
        "token", responseBody['access_token'].toString());
    SharedPreferencesHelper.setBoolValue("logged", true);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/acceuil');
    return true;
  } else {
    return false;
  }
}

loginUserReseau(context, email) async {
  Map<String, dynamic> data = {
    'email': Provider.of<DefaultUserProvider>(context, listen: false)
                .reseauCode ==
            'insta'
        ? '${Provider.of<DefaultUserProvider>(context, listen: false).userName}@cible.com'
        : email,
    'password': '123userpro@cible',
  };
  print(jsonEncode(data));
  var response = await http.post(Uri.parse('$baseApiUrl/auth/particular/login'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.statusCode);
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body) as Map;
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
    await SharedPreferencesHelper.setValue("ppType", '');
    imageCache.clear();
    Provider.of<DefaultUserProvider>(context, listen: false)
        .fromAPIUserMap(responseBody['user']);
    Provider.of<DefaultUserProvider>(context, listen: false).password =
        await SharedPreferencesHelper.getValue('password');
    await registerUserDB(
        context,
        Provider.of<DefaultUserProvider>(context, listen: false)
            .toDefaulUserModel);
    Provider.of<DefaultUserProvider>(context, listen: false).token =
        responseBody['access_token'].toString();
    await SharedPreferencesHelper.setValue(
        "token", responseBody['access_token'].toString());
    SharedPreferencesHelper.setBoolValue("logged", true);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/acceuil');
    return true;
  } else {
    return false;
  }
}
