import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:cible/constants/instagramApi.dart' as instagramApi;
import 'package:cible/constants/linkedinApi.dart' as linkedinAPi;

import 'dart:async';

Future<void> logoutPopup(context) async {
  // bool etat = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: Device.getDiviseScreenHeight(context, 3),
            width: Device.getDiviseScreenWidth(context, 1.2),
            color: Provider.of<AppColorProvider>(context, listen: false).white,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.warning_rounded,
                    size: 60,
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .primary,
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 50,
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
                  "koevipascaldecor@gmail.com",
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
                  height: Device.getScreenHeight(context) / 30,
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
                          padding: const EdgeInsets.all(15),
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
                        onPressed: () {
                          logout(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
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
        "FB") {
      await facebookLogout();
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false).reseauCode ==
        "LN") {
      linkedinLogout();
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false).reseauCode ==
        "IN") {   
      instagramLogout();
    }
  }

  await SharedPreferencesHelper.setBoolValue("logged", false);
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacementNamed(context, '/login');
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
