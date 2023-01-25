import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/views/monCompte/monCompte.controller.dart';
import 'package:cible/views/monCompte/monCompte.widgets.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MonCompte extends StatefulWidget {
  const MonCompte({Key? key}) : super(key: key);

  @override
  State<MonCompte> createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  // int _controller.index = 0;
  final _tabKey = GlobalKey<State>();
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  @override
  void initState() {
    // _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    Provider.of<AppManagerProvider>(context, listen: false)
        .initprofilTabController(this);
    super.initState();
    getActionsUser();
  }

  getActionsUser() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    // print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['actions'] != null) {
        setState(() {
          actions = remplieActionListe(responseBody['actions'] as List);
        });
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
          backgroundColor: appColorProvider.defaultBg,
          appBar: AppBar(
            backgroundColor: appColorProvider.defaultBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              color: appColorProvider.black87,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p2(context),
                  fontWeight: FontWeight.bold,
                  color: appColorProvider.black54),
            ),
          ),
          body: Container(
            color: appColorProvider.defaultBg,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Device.getDiviseScreenWidth(context, 30),
              ),
              children: [
                Card(
                  color: appColorProvider.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 30),
                        vertical: Device.getDiviseScreenHeight(context, 50)),
                    child: Column(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'Image_Profile',
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    child: photoProfil(context,
                                        appColorProvider.primaryColor4, 100)),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p1(context),
                              fontWeight: FontWeight.w800,
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black54),
                        ),
                        Text(
                          "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p4(context),
                              fontWeight: FontWeight.w400,
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black38),
                        ),
                        SizedBox(
                          height: Device.getScreenHeight(context) / 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Column(
                            //   children: [
                            //     Text(
                            //       "0",
                            //       textAlign: TextAlign.center,
                            //       style: GoogleFonts.poppins(
                            //           textStyle:
                            //               Theme.of(context).textTheme.bodyLarge,
                            //           fontSize: AppText.p1(context),
                            //           fontWeight: FontWeight.w800,
                            //           color: Provider.of<AppColorProvider>(
                            //                   context,
                            //                   listen: false)
                            //               .black54),
                            //     ),
                            //     Text(
                            //       "Tickets",
                            //       textAlign: TextAlign.center,
                            //       style: GoogleFonts.poppins(
                            //           textStyle:
                            //               Theme.of(context).textTheme.bodyLarge,
                            //           fontSize: AppText.p4(context),
                            //           fontWeight: FontWeight.w400,
                            //           color: Provider.of<AppColorProvider>(
                            //                   context,
                            //                   listen: false)
                            //               .black38),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              children: [
                                Text(
                                  "0",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p1(context),
                                      fontWeight: FontWeight.w800,
                                      color: Provider.of<AppColorProvider>(
                                              context,
                                              listen: false)
                                          .black54),
                                ),
                                Text(
                                  "Notifications",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w400,
                                      color: Provider.of<AppColorProvider>(
                                              context,
                                              listen: false)
                                          .black38),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${oCcy.format(Provider.of<PortefeuilleProvider>(context, listen: false).solde)} F',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p1(context),
                                      fontWeight: FontWeight.w800,
                                      color: Provider.of<AppColorProvider>(
                                              context,
                                              listen: false)
                                          .black54),
                                ),
                                Text(
                                  "Solde",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w400,
                                      color: Provider.of<AppColorProvider>(
                                              context,
                                              listen: false)
                                          .black38),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: Device.getScreenHeight(context) / 50,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/modifiecompte');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide(
                                      width: 0.7,
                                      color: appColorProvider.black26),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(LineIcons.pen,
                                          color: appColorProvider.black87,
                                          size: AppText.p5(context)),
                                      SizedBox(width: 5),
                                      Text(
                                        "Modifier mon compte",
                                        style: GoogleFonts.poppins(
                                            color: appColorProvider.black87,
                                            fontSize: AppText.p5(context)),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: RaisedButtonDecor(
                                onPressed: () {
                                  // setState(() {});
                                  Navigator.pushNamed(context, "/wallet");
                                },
                                elevation: 0,
                                color: appColorProvider.primaryColor,
                                shape: BorderRadius.circular(5),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Recharger mon portefeuil",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: AppText.p5(context)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 100,
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: Device.getDiviseScreenWidth(context, 50),
                //       vertical: Device.getDiviseScreenHeight(context, 200)),
                //   margin: EdgeInsets.all(2),
                //   decoration: BoxDecoration(
                //       color: appColorProvider.darkMode
                //           ? appColorProvider.primaryColor2
                //           : appColorProvider.primaryColor5,
                //       borderRadius: BorderRadius.all(Radius.circular(5))),
                //   child: ListTile(
                //     onTap: () {},
                //     leading: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Icon(LineIcons.userCheck,
                //             size: AppText.titre2(context),
                //             color: appColorProvider.black54),
                //       ],
                //     ),
                //     title: Text(
                //       "Devenir un commercial de CIBLE",
                //       textAlign: TextAlign.start,
                //       overflow: TextOverflow.ellipsis,
                //       style: GoogleFonts.poppins(
                //           textStyle: Theme.of(context).textTheme.bodyLarge,
                //           fontSize: AppText.p2(context),
                //           fontWeight: FontWeight.w800,
                //           color: appColorProvider.black54),
                //     ),
                //     subtitle: Text(
                //       "Vous aurez la possibilité de gagner sur vos recommendation",
                //       textAlign: TextAlign.start,
                //       overflow: TextOverflow.ellipsis,
                //       style: GoogleFonts.poppins(
                //           textStyle: Theme.of(context).textTheme.bodyLarge,
                //           fontSize: AppText.p4(context),
                //           fontWeight: FontWeight.w400,
                //           color: appColorProvider.black38),
                //     ),
                //     trailing: Icon(Icons.arrow_forward_ios,
                //         size: AppText.p4(context),
                //         color: appColorProvider.black54),
                //   ),
                // ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 100,
                ),
                SingleChildScrollView(
                  child: Consumer<AppManagerProvider>(
                      builder: (context, appManagerProvider, child) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                appManagerProvider.profilTabController
                                    .animateTo(0,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease);
                              });
                            },
                            child: Container(
                              // height: 50,
                              decoration: Provider.of<AppManagerProvider>(
                                              context,
                                              listen: true)
                                          .profilTabController
                                          .index ==
                                      0
                                  ? BoxDecoration(
                                      color: appColorProvider.darkMode
                                          ? appColorProvider.black12
                                          : appColorProvider.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)))
                                  : BoxDecoration(
                                      color: appColorProvider.transparent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),

                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                "Statistiques",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p3(context),
                                    fontWeight: appManagerProvider
                                                .profilTabController.index ==
                                            0
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                    color: appColorProvider.black87),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // _tabKey.currentState.
                              setState(() {
                                appManagerProvider.profilTabController
                                    .animateTo(1,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease);
                              });
                            },
                            child: Container(
                                decoration: appManagerProvider
                                            .profilTabController.index ==
                                        1
                                    ? BoxDecoration(
                                        color: appColorProvider.darkMode
                                            ? appColorProvider.black12
                                            : appColorProvider.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),

                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  " Activités récentes",
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p3(context),
                                      fontWeight: appManagerProvider
                                                  .profilTabController.index ==
                                              1
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      color: appColorProvider.black87),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                appManagerProvider.profilTabController
                                    .animateTo(2,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.ease);
                              });
                            },
                            child: Container(
                                decoration: appManagerProvider
                                            .profilTabController.index ==
                                        2
                                    ? BoxDecoration(
                                        color: appColorProvider.darkMode
                                            ? appColorProvider.black12
                                            : appColorProvider.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),

                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Utilisation",
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p3(context),
                                      fontWeight: appManagerProvider
                                                  .profilTabController.index ==
                                              2
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      color: appColorProvider.black87),
                                )),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: Device.getDiviseScreenHeight(context, 1.5),
                  child: Listener(onPointerDown: (details) {
                    print("2 ++");

                    // onPointerMove: (details) {

                    if (details.delta.dx < 0 &&
                        Provider.of<AppManagerProvider>(context, listen: false)
                                .profilTabController
                                .index <
                            2) {
                      Provider.of<AppManagerProvider>(context, listen: false)
                          .tabControllerstateChangePlus();
                    }
                    if (details.delta.dx > 0 &&
                        Provider.of<AppManagerProvider>(context, listen: false)
                                .profilTabController
                                .index >
                            0) {
                      Provider.of<AppManagerProvider>(context, listen: false)
                          .tabControllerstateChangeMoins();
                    }

                    setState(() {});
                  }, child: Consumer<AppManagerProvider>(
                      builder: (context, appManagerProvider, child) {
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: appManagerProvider.profilTabController,
                      key: _tabKey,
                      children: const [
                        SizedBox(
                          child: Satistics(),
                        ),
                        SizedBox(
                          child: ActiviteRecentes(),
                          //     Center(
                          //   child: Text('vide2'),
                          // ),
                        ),
                        SizedBox(
                          child: Center(
                            child: Text('vide3'),
                          ),
                        ),
                      ],
                    );
                  })),
                ),
              ],
            ),
          ));
    });
  }
}
