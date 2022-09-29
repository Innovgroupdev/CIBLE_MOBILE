import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:cible/core/routes.dart';

menu(context) {
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
              child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                width: 100,
                child: Hero(
                  tag: "Image_Profile",
                  child: Provider.of<DefaultUserProvider>(context,
                                  listen: false)
                              .image ==
                          ''
                      ? Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_blanc.png"),
                                fit: BoxFit.cover,
                              )),
                          height: 50,
                          width: 50,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: Provider.of<DefaultUserProvider>(
                                      context,
                                      listen: false)
                                  .image,
                              height: 100,
                              width: 100),
                        ),
                ),
              ),
            ),
          ),
        ),
        Text(
          "KOEVI Komi Pascal",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              fontSize: AppText.titre4(context),
              fontWeight: FontWeight.w800,
              color: Provider.of<AppColorProvider>(context, listen: false)
                  .black54),
        ),
        Text(
          "koevipascaldecor@gmail.com",
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
        GestureDetector(
          onTap: () {
            print('Mon compte !');
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.userAlt,
                  color: Provider.of<AppColorProvider>(context, listen: false)
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
            print('Evenements !');
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
            print('Paramètres !');
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
            print('Paramètres !');
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
            logoutPopup(context);
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
                  "Déconnexion",
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
