import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:flutter/material.dart';
import 'package:cible/constants/localPath.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../helpers/colorsHelper.dart';
import 'package:line_icons/line_icons.dart';

slide1(context) {
  return Container(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 3.5),
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            height: Device.getDiviseScreenHeight(context, 4),
            child: Image.asset('${imagesPath}slide_1.png'),
          ),
        ),
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 20),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ayez une longueur d'avance",
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.titre1(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: Device.getDiviseScreenHeight(context, 95),
              ),
              Text(
                "Trouvez ou annoncez vos événements coup de cœur  et achetez ou vendez vos tickets en ligne en 3 clics.",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p1(context),
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

slide2(context) {
  return Container(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 3.5),
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            height: Device.getDiviseScreenHeight(context, 4),
            child: Image.asset('${imagesPath}slide_2.png'),
          ),
        ),
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 20),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Des partenariats illimités",
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.titre1(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: Device.getDiviseScreenHeight(context, 95),
              ),
              Text(
                "Trouvez les sponsors et les investisseurs adéquats pour la réussite de votre évènement aujourd'hui.",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p1(context),
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

slide3(context) {
  return Container(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 3.5),
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            height: Device.getDiviseScreenHeight(context, 4),
            child: Image.asset('${imagesPath}slide_3.png'),
          ),
        ),
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 20),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Des profils très qualifiés",
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.titre1(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: Device.getDiviseScreenHeight(context, 95),
              ),
              Text(
                "Recrutez des organisateurs et prestataires évènementiels. Trouvez une main d'œuvre qualifiée pour vos évènements.",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p1(context),
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
