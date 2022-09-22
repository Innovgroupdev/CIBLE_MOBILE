import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget toastSuccess = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.greenAccent,
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check),
      SizedBox(
        width: 12.0,
      ),
      Text("This is a Custom Toast"),
    ],
  ),
);
Widget toastError(context, msg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromARGB(255, 255, 223, 227),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: AppText.p3(context),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(msg,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w500,
                color: Colors.red,
              )),
        ],
      ),
    );
