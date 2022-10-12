import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/views/welcome/welcome.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var darkmode;
  @override
  void initState() {
    initThemeData();
    super.initState();
  }

  initThemeData() async {
    darkmode = await SharedPreferencesHelper.getBoolValue('darkMode');
    if (darkmode == null) {
      darkmode = false;
    }
    if (darkmode && darkmode != null) {
      Provider.of<AppColorProvider>(context, listen: false).todarkMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      gotonextPage(context);
    });
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Container(
        color: appColorProvider.white,
        width: Device.getScreenWidth(context),
        height: Device.getScreenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(),
            Container(
              alignment: Alignment.center,
              height: Device.getDiviseScreenHeight(context, 5),
              child: Image.asset('${imagesPath}CIBLE 2_1.png'),
            ),
            SizedBox(height: Device.getDiviseScreenHeight(context, 30)),
            Positioned(
                child: Text(
              "Ayez une longueur d'avance",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: appColorProvider.primaryColor),
            ))
          ],
        ),
      );
    });
  }
}
