import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/regexHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/userDBService.dart';
import 'package:cible/views/authUserInfo/authUserInfo.controller.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

FToast fToast = FToast();
bool isLoading = false;

refundPopup(BuildContext context, Event1 event) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(Device.getScreenHeight(context) / 70),
              child: Container(
                width: Device.getDiviseScreenWidth(context, 1.2),
                color:
                    Provider.of<AppColorProvider>(context, listen: false).white,
                padding: EdgeInsets.symmetric(
                  horizontal: Device.getScreenHeight(context) / 30,
                  vertical: Device.getScreenHeight(context) / 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.warning_rounded,
                        size: Device.getDiviseScreenHeight(context, 20),
                        color: Provider.of<AppColorProvider>(context,
                                listen: false)
                            .primary,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "Êtes-vous sûr de vouloir annuler cet évènement ?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.bold,
                          color: Provider.of<AppColorProvider>(context,
                                  listen: false)
                              .primary),
                    ),
                    Gap(Device.getScreenHeight(context) / 60),
                    Text(
                      "Vous serez rembourser.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p4(context),
                          fontWeight: FontWeight.w400,
                          color: Provider.of<AppColorProvider>(context,
                                  listen: false)
                              .black38),
                    ),
                    Gap(Device.getScreenHeight(context) / 60),
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
                                  width: 1,
                                  color: Provider.of<AppColorProvider>(context,
                                          listen: false)
                                      .black26),
                            ),
                            child: Center(
                              child: Text(
                                "Non",
                                style: GoogleFonts.poppins(
                                  color: Provider.of<AppColorProvider>(context,
                                          listen: false)
                                      .black87,
                                  fontSize: AppText.p2(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await refund(context, event);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.all(
                                  Device.getDiviseScreenHeight(context, 70)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Provider.of<AppColorProvider>(
                                      context,
                                      listen: false)
                                  .primary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Oui",
                                  style: GoogleFonts.poppins(
                                    color: Provider.of<AppColorProvider>(
                                            context,
                                            listen: false)
                                        .white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppText.p2(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      });
}

Future refund(context, Event1 event) async {
  var token = await SharedPreferencesHelper.getValue('token');
  var users;
  users = await UserDBcontroller().liste() as List;
  int userId = int.parse(users[0].id);
  print(users);
  print(userId);

  var response = await http.post(
    Uri.parse('$baseApiUrl/events/${event.id}/refund/$userId'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  print("response!!!!!!!!!!");
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    fToast.showToast(
      fadeDuration: const Duration(milliseconds: 500),
      child: toastsuccess(
        context,
        "L'évènement a bien été annulé pour vous !",
      ),
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, '/moncompte');
  } else {
    fToast.showToast(
      fadeDuration: const Duration(milliseconds: 1000),
      child: toastError(
        context,
        "Une erreur s'est produite veuillez réssayer !",
      ),
    );
  }
}
