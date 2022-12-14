import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

inputDecorationGrey(label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(255, 240, 240, 240),
    hintText: '${label}',
    hintStyle:
        GoogleFonts.poppins(fontSize: largeur / 35, color: Colors.black45),
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(106, 243, 143, 118)),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

datePicker(context) async {
  DateTime? choix = await showDatePicker(
      helpText: "Sélectionner une date",
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1950),
      lastDate: new DateTime(2100));
  print(choix);
  if (choix != null) {
    return choix;
  }
}

inputDecoration(context, label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Provider.of<AppColorProvider>(context, listen: false).darkMode
        ? Color.fromARGB(255, 65, 65, 65)
        : Color.fromARGB(255, 240, 240, 240),
    hintText: '${label}',
    hintStyle: GoogleFonts.poppins(
        fontSize: largeur / 30,
        color: Provider.of<AppColorProvider>(context, listen: false).black45),
    contentPadding: EdgeInsets.all(Device.getDiviseScreenHeight(context, 60)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(106, 243, 143, 118)),
      borderRadius:
          BorderRadius.circular(Device.getDiviseScreenHeight(context, 100)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Provider.of<AppColorProvider>(context, listen: false).white),
      borderRadius:
          BorderRadius.circular(Device.getDiviseScreenHeight(context, 100)),
    ),
  );
}

inputDecorationPrelogged(context, label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(255, 240, 240, 240),
    hintText: '${label}',
    hintStyle:
        GoogleFonts.poppins(fontSize: largeur / 30, color: Colors.black45),
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(106, 243, 143, 118)),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
