import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:flutter/material.dart';

import '../../providers/appColorsProvider.dart';
import 'package:google_fonts/google_fonts.dart';

class MarqueWidget extends StatelessWidget {
  final String libelle;
  final String description;

  const MarqueWidget(
      {super.key, required this.libelle, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Device.getDiviseScreenHeight(context, 50),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Device.getDiviseScreenHeight(context, 60),
        horizontal: Device.getDiviseScreenWidth(context, 30),
      ),
      width: 300,
      decoration: BoxDecoration(
        color: AppColorProvider().primary.withOpacity(0.6),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 99, 62, 168),
            Color.fromARGB(255, 108, 10, 126),
            Color.fromARGB(255, 155, 24, 144),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            Device.getDiviseScreenHeight(context, 200),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              libelle,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: AppColorProvider().white,
              ),
            ),
            Text(
              description,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p4(context),
                color: AppColorProvider().white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
