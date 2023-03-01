import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/monCompte/monCompte.controller.dart';
import 'package:cible/views/monCompte/monCompte.widgets.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

import '../../constants/localPath.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../../widgets/card.dart';
import '../../widgets/eventsActifs.dart';

class Evenement extends StatefulWidget {
  const Evenement({Key? key}) : super(key: key);

  @override
  State<Evenement> createState() => _EvenementState();
}

class _EvenementState extends State<Evenement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  // int _controller.index = 0;
  final _tabKey = GlobalKey<State>();
  final oCcy = NumberFormat("#,##0.00", "fr_FR");
  var solde;
  List devises = [];
  var countries;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    // _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    Provider.of<AppManagerProvider>(context, listen: false)
        .initprofilTabController(this);
    super.initState();
    // getCountryAvailableOnAPi();
    // getUserInfo();
    // getActionsUser();
  }

  // Future getCountryAvailableOnAPi() async {
  //   var response = await http.get(
  //     Uri.parse('$baseApiUrl/pays'),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var responseBody = jsonDecode(response.body);
  //     if (responseBody['data'] != null) {
  //       countries = responseBody['data'] as List;
  //     }
  //     for (var countrie in countries) {
  //       if (countrie['id'] ==
  //           Provider.of<DefaultUserProvider>(context, listen: false).paysId) {
  //         setState(() {
  //           devises = [countrie['devise']];
  //         });
  //       }
  //     }
  //   }
  // }

  // getUserInfo() async {
  //   var response;
  //   var token = await SharedPreferencesHelper.getValue('token');
  //   response = await http.get(
  //     Uri.parse('$baseApiUrl/auth/particular/sold'),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var responseBody = jsonDecode(response.body) as Map;
  //     if (responseBody['user'] != null) {
  //       setState(() {
  //         solde = double.parse(responseBody['montant']);
  //       });
  //       return responseBody;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  // getActionsUser() async {
  //   var response = await http.get(
  //     Uri.parse('$baseApiUrl/part'),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json"
  //     },
  //   );
  //   print(response.statusCode);
  //   // print(jsonDecode(response.body));
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var responseBody = jsonDecode(response.body);
  //     if (responseBody['actions'] != null) {
  //       setState(() {
  //         actions = remplieActionListe(responseBody['actions'] as List);
  //       });
  //     }
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
              "EVENEMENTS",
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p2(context),
                  fontWeight: FontWeight.bold,
                  color: appColorProvider.black54),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: appColorProvider.defaultBg,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                
                  Container(
                    child: CarouselSlider(
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        //height:   180,

                        aspectRatio: 16 / 6.8,

                        viewportFraction: 1,

                        initialPage: 0,

                        enableInfiniteScroll: true,

                        reverse: false,

                        autoPlay: true,

                        autoPlayInterval: Duration(seconds: 10),

                        autoPlayAnimationDuration: Duration(milliseconds: 800),

                        autoPlayCurve: Curves.fastOutSlowIn,

                        enlargeCenterPage: true,

                        enlargeFactor: 0.1,

                        scrollDirection: Axis.horizontal,
                      ),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  image: const DecorationImage(image: AssetImage(
                                        'assets/images/event2.jpg',
                                      ),
                                        fit: BoxFit.cover,),
                                    borderRadius: BorderRadius.circular(20)),
                                );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                  height: Device.getScreenHeight(context) / 50,
                ),
                SingleChildScrollView(
                  child: Consumer<AppManagerProvider>(
                      builder: (context, appManagerProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                appManagerProvider.profilTabController
                                    .animateTo(0,
                                        duration: const Duration(milliseconds: 250),
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
                                         const  BorderRadius.all(Radius.circular(5)))
                                  : BoxDecoration(
                                      color: appColorProvider.transparent,
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(0))),

                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              child: Text(
                                "Actifs",
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
                                        duration: const Duration(milliseconds: 250),
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: const BorderRadius.all(
                                             Radius.circular(0))),

                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: Text(
                                  " Passés",
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
                                        duration: const Duration(milliseconds: 250),
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: const BorderRadius.all(
                                             Radius.circular(0))),

                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: Text(
                                  "Sondages",
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
                      children:  [
                        SizedBox(
                          child: EventsActifs(type:'actifs'),
                          //child: Satistics(),
                        ),
                         SizedBox(
                          child: EventsActifs(type:'passés'),
                          //     Center(
                          //   child: Text('vide2'),
                          // ),
                        ),
                         SizedBox(
                          child: EventsActifs(type:'sondage'),
                          // child: Center(
                          //   child: Text('vide3'),
                          // ),
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
