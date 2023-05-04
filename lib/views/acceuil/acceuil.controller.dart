import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> showLinkedinAuthDialog(context) async {
  // bool etat = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Device.getDiviseScreenHeight(context, 8),
            horizontal: Device.getDiviseScreenWidth(context, 20)),
        child: Center(
         
        ),
      );
    },
  );
}

 List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Favorite',
    'Settings',
    'Account',
  ];