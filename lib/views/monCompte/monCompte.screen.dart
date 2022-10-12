import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/views/monCompte/monCompte.controller.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                                  "Tickets",
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
                                  "0 F",
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
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: RaisedButtonDecor(
                                onPressed: () {
                                  setState(() {});
                                },
                                elevation: 0,
                                color: appColorProvider.primaryColor,
                                shape: BorderRadius.circular(5),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Mon portefeuil",
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
                  height: Device.getScreenHeight(context) / 50,
                ),
                Consumer<AppManagerProvider>(
                    builder: (context, appManagerProvider, child) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                          BorderRadius.all(Radius.circular(50)))
                                  : BoxDecoration(
                                      color: appColorProvider.transparent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),

                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                "Activités récentes",
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
                                            Radius.circular(50)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),

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
                                            Radius.circular(50)))
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
                      ));
                }),
                SizedBox(
                  height: Device.getDiviseScreenHeight(context, 3),
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
                    // var check;
                    // setState(() {
                    //   print(check);
                    //   if (details.delta.dx < 0 &&
                    //       Provider.of<AppManagerProvider>(context,
                    //                   listen: false)
                    //               .profilTabController
                    //               .index <
                    //           1) {
                    //     print(Provider.of<AppManagerProvider>(context,
                    //             listen: false)
                    //         .profilTabController
                    //         .previousIndex);
                    //     Provider.of<AppManagerProvider>(context, listen: false)
                    //         .profilTabController
                    //         .index += 2;
                    //     setState(() {
                    //       Provider.of<AppManagerProvider>(context,
                    //               listen: false)
                    //           .profilTabController
                    //           .index -= 1;
                    //     });
                    //   }
                    // });
                    // setState(() {
                    //   print(check);
                    //   if (details.delta.dx < 0 &&
                    //       Provider.of<AppManagerProvider>(context,
                    //                   listen: false)
                    //               .profilTabController
                    //               .index >
                    //           1) {
                    //     print(Provider.of<AppManagerProvider>(context,
                    //             listen: false)
                    //         .profilTabController
                    //         .previousIndex);
                    //     Provider.of<AppManagerProvider>(context, listen: false)
                    //         .profilTabController
                    //         .index -= 2;
                    //     setState(() {
                    //       Provider.of<AppManagerProvider>(context,
                    //               listen: false)
                    //           .profilTabController
                    //           .index += 1;
                    //     });
                    //   }
                    // });
                  }, child: Consumer<AppManagerProvider>(
                      builder: (context, appManagerProvider, child) {
                    return TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: appManagerProvider.profilTabController,
                      key: _tabKey,
                      children: [
                        Container(
                          child: Center(
                            child: Text('vide1'),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text('vide2'),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text('vide3'),
                          ),
                        ),
                      ],
                    );
                  })),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Device.getDiviseScreenWidth(context, 20),
                      vertical: Device.getDiviseScreenHeight(context, 50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ajouter d'autres fonctionnalités",
                        style: GoogleFonts.poppins(
                            color: appColorProvider.black,
                            fontSize: AppText.p2(context),
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "AFFICHER PLUS",
                        style: GoogleFonts.poppins(
                            color: appColorProvider.primaryColor1,
                            fontSize: AppText.p4(context),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                actions == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: Device.getDiviseScreenHeight(context, 5),
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                              left: Device.getDiviseScreenWidth(context, 30)),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: actions.length,
                          itemExtent: Device.getDiviseScreenWidth(context, 2.5),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (() {
                                setState(() {
                                  actions[index].changeEtat();
                                  if (actions[index].etat) {
                                  } else {
                                    if (actions[index] != null) {}
                                  }
                                });
                              }),
                              child: Card(
                                elevation: 3,
                                shadowColor: appColorProvider.black12,
                                color: appColorProvider.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: actions[index].etat
                                                        ? appColorProvider
                                                            .primaryColor1
                                                        : const Color.fromARGB(
                                                            31, 151, 151, 151)),
                                                color: actions[index].etat
                                                    ? appColorProvider
                                                        .primaryColor1
                                                    : appColorProvider.grey2,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100))),
                                            child: Icon(
                                              LineIcons.check,
                                              size: 7,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            Device.getScreenHeight(context) /
                                                100,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: Device.getScreenHeight(
                                                    context) /
                                                22,
                                            height: Device.getScreenHeight(
                                                    context) /
                                                22,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              imageUrl: actions[index].image,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Device.getScreenHeight(
                                                    context) /
                                                50,
                                          ),
                                          Text(
                                            actions[index].titre,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize: AppText.p4(context),
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    appColorProvider.black54),
                                          ),
                                        ], //just for testing, will fill with image later
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
          ));
    });
  }
}
