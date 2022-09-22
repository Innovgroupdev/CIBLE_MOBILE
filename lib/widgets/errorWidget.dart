import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

textSimpleError(context, message, icone, size) {
  return Wrap(children: [
    Icon(
      icone,
      size: size + 2,
      color: AppColor.primaryColor,
    ),
    SizedBox(
      width: 5,
    ),
    Text(
      message,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodyLarge,
          fontSize: size,
          fontWeight: FontWeight.w400,
          color: AppColor.primaryColor),
    ),
  ]);
}
