import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:cible/core/routes.dart';
import 'package:share_plus/share_plus.dart';

menu(context, etat) {
  // var etat = await SharedPreferencesHelper.getBoolValue("logged");
  // print(etat);
  return Container(
    width: Device.getDiviseScreenWidth(context, 1.4),
    child: SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: Device.getDiviseScreenHeight(context, 15),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Badge(
              toAnimate: true,
              badgeColor: Color.fromARGB(255, 93, 255, 28),
              shape: BadgeShape.circle,
              position: BadgePosition(bottom: 15, end: 15),
              padding: const EdgeInsets.all(5),
              child: etat != null && !etat
                  ? Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo_blanc.png"),
                            fit: BoxFit.cover,
                          )),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      child: photoProfil(
                          context,
                          Provider.of<AppColorProvider>(context, listen: false)
                              .primaryColor4,
                          100)),
            ),
          ),
        ),
        etat != null && etat
            ? Text(
                "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.titre4(context),
                    fontWeight: FontWeight.w800,
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .black54),
              )
            : SizedBox(),
        etat != null && etat
            ? Text(
                "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p2(context),
                    fontWeight: FontWeight.w400,
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .black38),
              )
            : Text(
                "Ayez une longueur d'avance",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p3(context),
                    fontWeight: FontWeight.w400,
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .black38),
              ),
        SizedBox(
          height: Device.getScreenHeight(context) / 50,
        ),
        Divider(
          color: Provider.of<AppColorProvider>(context, listen: false).black26,
        ),
        SizedBox(
          height: Device.getScreenHeight(context) / 40,
        ),
        etat != null && etat
            ? GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/moncompte");
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        LineIcons.userAlt,
                        color: Provider.of<AppColorProvider>(context,
                                listen: false)
                            .black38,
                      ),
                      SizedBox(
                        width: Device.getDiviseScreenWidth(context, 50),
                      ),
                      Text(
                        "Mon compte",
                        style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontSize: AppText.p2(context),
                            fontWeight: FontWeight.w400,
                            color: Provider.of<AppColorProvider>(context,
                                    listen: false)
                                .black38),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
        //
        SizedBox(
            height: etat != null && etat
                ? Device.getDiviseScreenHeight(context, 20)
                : 0),
        GestureDetector(
          onTap: () {
            print('Evenements !');
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.calendarAlt,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black38,
                ),
                SizedBox(
                  width: Device.getDiviseScreenWidth(context, 50),
                ),
                Text(
                  "Evenements",
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
              ],
            ),
          ),
        ),
        //
        //
        SizedBox(height: Device.getDiviseScreenHeight(context, 20)),
        GestureDetector(
          onTap: () {
            Share.share(
                "Téléchargez l'application CIBLE via le lien https://cible-app.com",
                subject: "Ayez une longueur d'avance !");
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.userPlus,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black38,
                ),
                SizedBox(
                  width: Device.getDiviseScreenWidth(context, 50),
                ),
                Text(
                  "Recommander CIBLE",
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
              ],
            ),
          ),
        ),
        //
        SizedBox(height: Device.getDiviseScreenHeight(context, 20)),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/parametre');
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.cog,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black38,
                ),
                SizedBox(
                  width: Device.getDiviseScreenWidth(context, 50),
                ),
                Text(
                  "Paramètres",
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
              ],
            ),
          ),
        ),
        //
        SizedBox(height: Device.getDiviseScreenHeight(context, 20)),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/parametre');
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.book,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black38,
                ),
                SizedBox(
                  width: Device.getDiviseScreenWidth(context, 50),
                ),
                Text(
                  "Termes et conditions",
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
              ],
            ),
          ),
        ),
        //
        SizedBox(height: Device.getDiviseScreenHeight(context, 20)),
        GestureDetector(
          onTap: () {
            etat != null && etat
                ? logoutPopup(context)
                : Navigator.pushNamed(context, '/login');
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.removeUser,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black38,
                ),
                SizedBox(
                  width: Device.getDiviseScreenWidth(context, 50),
                ),
                Text(
                  etat != null && etat ? "Déconnexion" : 'Me connecter',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),
              ],
            ),
          ),
        ),
        //
      ]),
    ),
  );
}
