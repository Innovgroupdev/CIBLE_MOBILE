// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/core/routes.dart';
import 'package:cible/database/actionController.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/views/acceuil/acceuil.controller.dart';
import 'package:cible/views/acceuil/acceuil.widgets.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/views/acceuilDates/acceuilDates.screen.dart';
import 'package:cible/views/accueilLieux/accueilLieux.screen.dart';
import 'package:cible/views/cart/cart.controller.dart';
import 'package:cible/widgets/menu.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  var actions;

  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool activeMenu = false;

  var etat;

  @override
  initState() {
    initACtions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initACtions() async {
    actions = await ActionDBcontroller().liste() as List;
    Provider.of<DefaultUserProvider>(context, listen: false).actions = actions;
    Provider.of<DefaultUserProvider>(context, listen: false).imageType =
        await SharedPreferencesHelper.getValue("ppType");

    etat = await SharedPreferencesHelper.getBoolValue("logged");
    if (etat && etat != null) {
      Provider.of<DefaultUserProvider>(context, listen: false).logged =
          etat == true ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    var _bottomNavIndex = 0;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          activeMenu = false;
          if (!activeMenu) {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
          }
        });
        return Future.value(false);
      },
      child: Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Container(
          color: appColorProvider.menu,
          child: Stack(
            children: [
              menu(context, etat),
              AnimatedContainer(
                transform: Matrix4.translationValues(xOffset - 15,
                    yOffset + Device.getDiviseScreenHeight(context, 20), 0)
                  ..scale(scaleFactor - 0.1),
                duration: Duration(milliseconds: 250),
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(activeMenu == false ? 0 : 15),
                    child: Container(
                      color: Color.fromARGB(77, 185, 185, 185).withOpacity(0.5),
                    )),
              ),
              AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor),
                duration: Duration(milliseconds: 250),
                child: FutureBuilder(
                    future: UserDBcontroller().liste(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && actions != null) {
                        List users = snapshot.data as List;
                        if (etat != null && etat) {
                          Provider.of<DefaultUserProvider>(context,
                                  listen: false)
                              .fromDefaultUser(users[0]);
                          print('tel init -- = ' +
                              Provider.of<DefaultUserProvider>(context,
                                      listen: false)
                                  .tel1);
                        }

                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              activeMenu = false;
                              if (!activeMenu) {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                              }
                            });
                          }),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                activeMenu == false ? 0 : 15),
                            child: Scaffold(
                              // drawer: const Menu(),
                              bottomNavigationBar: BottomNavigationBar(
                                  backgroundColor: appColorProvider.darkMode
                                      ? Colors.black
                                      : Colors.white,
                                  selectedIconTheme: IconThemeData(
                                      color: appColorProvider.primary),
                                  selectedLabelStyle: GoogleFonts.poppins(
                                      fontSize: AppText.p5(context),
                                      fontWeight: FontWeight.w600,
                                      color: appColorProvider.primary),
                                  unselectedLabelStyle: GoogleFonts.poppins(
                                      fontSize: AppText.p6(context),
                                      fontWeight: FontWeight.w400,
                                      color: appColorProvider.darkMode
                                          ? Colors.white70
                                          : Colors.black),
                                  unselectedItemColor: appColorProvider.darkMode
                                      ? Colors.white70
                                      : Colors.black,
                                  items: [
                                    BottomNavigationBarItem(
                                        icon: Icon(LineIcons.calendarCheck),
                                        label: 'Evenements'),
                                    BottomNavigationBarItem(
                                        icon: Icon(LineIcons.search),
                                        label: ''),
                                    BottomNavigationBarItem(
                                        icon: Icon(LineIcons.creditCard),
                                        label: 'Mes Tickets'),
                                  ]),

                              appBar: AppBar(
                                  leading: activeMenu == false
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.menu_rounded,
                                            color: appColorProvider.black54,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              activeMenu = true;
                                              if (activeMenu) {
                                                xOffset =
                                                    Device.getDiviseScreenWidth(
                                                        context, 1.3);
                                                yOffset = Device
                                                    .getDiviseScreenHeight(
                                                        context, 20);
                                                scaleFactor = 0.9;
                                              }
                                            });
                                          },
                                          color: appColorProvider.black45,
                                        )
                                      : Icon(
                                          Icons.arrow_back,
                                          color: appColorProvider.black54,
                                        ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "CIBLE",
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.titre1(context),
                                            fontWeight: FontWeight.bold,
                                            color: appColorProvider.primary),
                                      ),
                                    ],
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.all(10),
                                  //   height: 60,
                                  //   child: Container(
                                  //     height: 100,
                                  //     width: 100,
                                  //     decoration: const BoxDecoration(
                                  //         // borderRadius: BorderRadius.all(
                                  //         //     Radius.circular(100)),
                                  //         image: DecorationImage(
                                  //       image: AssetImage(
                                  //           "assets/images/CIBLE_2.app.png"),
                                  //       fit: BoxFit.contain,
                                  //     )),
                                  //   ),
                                  // ),

                                  centerTitle: true,
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Badge(
                                            badgeContent:
                                                Consumer<DefaultUserProvider>(
                                                    builder: (context, Panier,
                                                        child) {
                                              return Text(
                                                Provider.of<TicketProvider>(
                                                        context)
                                                    .ticketsList
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color:
                                                        appColorProvider.white),
                                              );
                                            }),
                                            toAnimate: true,
                                            shape: BadgeShape.circle,
                                            padding: EdgeInsets.all(7),
                                            child: IconButton(
                                              icon: Icon(
                                                LineIcons.shoppingCart,
                                                size: AppText.titre1(context),
                                                color: appColorProvider.black87,
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, "/cart");
                                              },
                                            ),
                                          ),
                                        ),
                                        etat != null && !etat
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: 60,
                                                  width: 60,
                                                  child: Hero(
                                                    tag: "Image_Profile",
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100)),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/logo_blanc.png"),
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, "/moncompte");
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Badge(
                                                    toAnimate: true,
                                                    badgeColor: Color.fromARGB(
                                                        255, 93, 255, 28),
                                                    shape: BadgeShape.circle,
                                                    position: BadgePosition(
                                                        top: 10, end: 5),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      height: 60,
                                                      width: 60,
                                                      child: Hero(
                                                          tag: "Image_Profile",
                                                          child: photoProfil(
                                                              context,
                                                              appColorProvider
                                                                  .primaryColor4,
                                                              100)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                  backgroundColor: appColorProvider.defaultBg,
                                  elevation: 0),
                              body: Container(
                                color: appColorProvider.defaultBg,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _controller.animateToPage(0,
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease);
                                            },
                                            child: Container(
                                              decoration: currentPage == 0
                                                  ? BoxDecoration(
                                                      color: appColorProvider
                                                              .darkMode
                                                          ? appColorProvider
                                                              .black12
                                                          : appColorProvider
                                                              .white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)))
                                                  : BoxDecoration(
                                                      color: appColorProvider
                                                          .transparent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),

                                              // ignore: prefer_const_constructors
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              child: Text(
                                                "Catégories",
                                                style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontSize:
                                                        AppText.p3(context),
                                                    fontWeight: currentPage == 0
                                                        ? FontWeight.bold
                                                        : FontWeight.w400,
                                                    color: appColorProvider
                                                        .black87),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _controller.animateToPage(1,
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease);
                                            },
                                            child: Container(
                                                decoration: currentPage == 1
                                                    ? BoxDecoration(
                                                        color: appColorProvider
                                                                .darkMode
                                                            ? appColorProvider
                                                                .black12
                                                            : appColorProvider
                                                                .white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)))
                                                    : BoxDecoration(
                                                        color: appColorProvider
                                                            .transparent,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),

                                                // ignore: prefer_const_constructors
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                child: Text(
                                                  "Dates",
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p3(context),
                                                      fontWeight:
                                                          currentPage == 1
                                                              ? FontWeight.bold
                                                              : FontWeight.w400,
                                                      color: appColorProvider
                                                          .black87),
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _controller.animateToPage(2,
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease);
                                            },
                                            child: Container(
                                                decoration: currentPage == 2
                                                    ? BoxDecoration(
                                                        color: appColorProvider
                                                                .darkMode
                                                            ? appColorProvider
                                                                .black12
                                                            : appColorProvider
                                                                .white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)))
                                                    : BoxDecoration(
                                                        color: appColorProvider
                                                            .transparent,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),

                                                // ignore: prefer_const_constructors
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                child: Text(
                                                  "Lieux",
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p3(context),
                                                      fontWeight:
                                                          currentPage == 2
                                                              ? FontWeight.bold
                                                              : FontWeight.w400,
                                                      color: appColorProvider
                                                          .black87),
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _controller.animateToPage(3,
                                                  duration: Duration(
                                                      milliseconds: 250),
                                                  curve: Curves.ease);
                                            },
                                            child: Container(
                                                decoration: currentPage == 3
                                                    ? BoxDecoration(
                                                        color: appColorProvider
                                                                .darkMode
                                                            ? appColorProvider
                                                                .black12
                                                            : appColorProvider
                                                                .white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)))
                                                    : BoxDecoration(
                                                        color: appColorProvider
                                                            .transparent,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),

                                                // ignore: prefer_const_constructors
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                child: Text(
                                                  "Favoris",
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p3(context),
                                                      fontWeight:
                                                          currentPage == 3
                                                              ? FontWeight.bold
                                                              : FontWeight.w400,
                                                      color: appColorProvider
                                                          .black87),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Stack(
                                        children: [
                                          PageView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: _controller,
                                            onPageChanged: (value) {
                                              setState(() {
                                                currentPage = value;
                                              });
                                            },
                                            children: [
                                              Container(child: Categories()),
                                              Container(child: Dates()),
                                              Container(
                                                child: Lieux(),
                                              ),
                                              ListView.builder(
                                                  itemCount: actions.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Text(actions[index].id),
                                                        Text(actions[index]
                                                            .description),
                                                      ],
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          color: appColorProvider.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
