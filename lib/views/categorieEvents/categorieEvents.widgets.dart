import 'package:cible/helpers/colorsHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

inputDecoration(label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(255, 240, 240, 240),
    hintText: '$label',
    hintStyle:
        GoogleFonts.poppins(fontSize: largeur / 30, color: Colors.black45),
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color.fromARGB(106, 243, 143, 118)),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
