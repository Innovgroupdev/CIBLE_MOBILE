import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

inputDecoration(label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(134, 255, 255, 255),
    hintText: '${label}',
    hintStyle: GoogleFonts.poppins(fontSize: largeur / 25, color: Colors.black),
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
