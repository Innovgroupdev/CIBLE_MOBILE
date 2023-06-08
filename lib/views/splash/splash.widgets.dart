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
                "Optez pour la simplicité",
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
                "Retrouvez tous les événements à venir et achetez vos tickets numériques en 1 clic.",
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
                "Gardez des souvenirs",
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
                "Obtenez des gadgets souvenirs pour immortaliser vos participations.",
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
                "Donnez votre avis",
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
                "Après chaque évènement auquel vous participez, participez à l'enquête de satisfaction.",
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
