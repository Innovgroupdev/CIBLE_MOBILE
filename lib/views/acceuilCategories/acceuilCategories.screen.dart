import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cible/constants/api.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../core/routes.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;

import '../../database/categorieDBcontroller.dart';
import '../../database/favorisDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../accueilFavoris/acceuilFavoris.controller.dart';

class Categories extends StatefulWidget {
  Categories({required this.countryLibelle, Key? key}) : super(key: key);
  String countryLibelle;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var token;
  List<Event1>? listFavoris;
  List favorisId = [];
  bool? etat;
  @override
  void initState() {
    getCategoriesFromAPI();
    getFavorisFromAPI();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavorisFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');

    var response = await http.get(
      Uri.parse('$baseApiUrl/evenements/favoris'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        listFavoris =
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
        for (var favoris in listFavoris!) {
          favorisId.add(favoris.id);
        }
      });
    }
  }

  // Here we receive events grouped by categgory
  getCategoriesFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    etat = await SharedPreferencesHelper.getBoolValue("logged");
    var response = etat!
        ? await http.get(
            Uri.parse('$baseApiUrl/evenements/grouped_by_categories'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
            },
          )
        : await http.get(
            Uri.parse(
                '$baseApiUrl/evenements/evenements_par_categories/${widget.countryLibelle}'),
            /*${widget.countryLibelle}*/
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $apiKey',
            },
          );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];

      setState(() {
        categories =
            getCategorieFromMap(jsonDecode(response.body)['data'] as List);
      });
      for (var element in categories!) {
        //await CategorieDBcontroller().insert(element);
        //var test = jsonEncode(element.events);
      }
      //final eventsDB = await CategorieDBcontroller().liste();

      //print('eventdb1111111111444' +
      // jsonDecode(jsonDecode(jsonEncode(eventsDB))[0]['events'])[0]['titre']
      //     .toString());

      // final eventDB1 =
      //     getCategorieFromLocalMap(jsonDecode(jsonEncode(eventsDB)));
      return categories;
    }
  }

  Stream<Categorie> categoriesStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      Categorie categoriess = getCategoriesFromAPI();
      yield categoriess;
    }
    // print('$categories');
  }

  getCategorieEvent(events) {
    for (var element in categories!) {
      element.events = events;
    }
  }

  getCategorieFromMap(List categorieListFromAPI) {
    final List<Categorie> tagObjs = [];
    for (var element in categorieListFromAPI) {
      late Categorie categorie;
      if (element['events'] != []) {
        categorie = Categorie.fromMap(element);
      }
      if (categorie.events.isNotEmpty) {
        tagObjs.add(categorie);
      }
    }
    return tagObjs;
  }

  getCategorieFromLocalMap(List categorieListFromAPI) {
    final List<Categorie> tagObjs = [];
    for (var element in categorieListFromAPI) {
      var categorie = Categorie.fromLocalMap(element);
      if (categorie.events.isNotEmpty) {
        tagObjs.add(categorie);
      }
    }
    return tagObjs;
  }

  @override
  Widget build(BuildContext context) {
    return categories == null || etat == null
        ? Center(child: CircularProgressIndicator())
        : categories!.isEmpty
            ? Center(
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 150),
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.asset('assets/images/empty.png'),
                    ),
                    const Center(
                      child: Text(
                        'Pas d\'évènements',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Consumer<AppColorProvider>(
                builder: (context, appColorProvider, child) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      height: Device.getDiviseScreenHeight(context, 9),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: Device.getDiviseScreenHeight(context, 90),
                            left: Device.getDiviseScreenWidth(context, 30),
                            right: Device.getDiviseScreenWidth(context, 30)),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories!.length,
                        itemExtent: Device.getDiviseScreenWidth(context, 5),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (() {
                              Navigator.pushNamed(context, '/categorieEvents',
                                  arguments: {
                                    "categorie": categories![index] as Categorie
                                  });
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                color: appColorProvider.categoriesColor(index),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  right: Device.getDiviseScreenHeight(
                                      context, 150)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .categoriesIcon(
                                            categories![index].code),
                                    color: appColorProvider.darkMode
                                        ? Colors.white70
                                        : appColorProvider.white,
                                    size: AppText.titre3(context),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                      child: Text(
                                    categories![index].titre,
                                    style: GoogleFonts.poppins(
                                        color: appColorProvider.darkMode
                                            ? Colors.white70
                                            : appColorProvider.white,
                                        fontSize: AppText.p6(context),
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categories!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: Device.getDiviseScreenHeight(
                                        context, 40),
                                    left: Device.getDiviseScreenWidth(
                                        context, 30),
                                    right: Device.getDiviseScreenWidth(
                                        context, 30)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      categories![index].titre,
                                      style: GoogleFonts.poppins(
                                          color: appColorProvider.black,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    InkWell(
                                      onTap: (() {
                                        Navigator.pushNamed(
                                            context, '/categorieEvents',
                                            arguments: {
                                              "categorie": categories![index]
                                                  as Categorie
                                            });
                                      }),
                                      child: Text(
                                        "AFFICHER PLUS ",
                                        style: GoogleFonts.poppins(
                                            color:
                                                appColorProvider.primaryColor1,
                                            fontSize: AppText.p4(context),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints.expand(
                                  height: Device.getDiviseScreenHeight(
                                      context, 3.1),
                                ),
                                height:
                                    Device.getDiviseScreenHeight(context, 3.1),
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: Device.getDiviseScreenHeight(
                                            context, 90),
                                        left: Device.getDiviseScreenWidth(
                                            context, 30),
                                        right: Device.getDiviseScreenWidth(
                                            context, 30)),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories![index].events.length,
                                    itemExtent:
                                        Device.getDiviseScreenWidth(context, 3),
                                    itemBuilder: (context, index1) {
                                      int lent = categories![index]
                                          .events[index1]
                                          .titre
                                          .length;
                                      // int lentAuteur = categories![index]
                                      //     .events[index1]
                                      //     .auteur
                                      //     .nom
                                      //     .length;
                                      final Likecontroller =
                                          GlobalKey<LikeButtonState>();
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Card(
                                                    child: Hero(
                                                      tag:
                                                          "Image_Event$index$index1",
                                                      child:
                                                          categories![index]
                                                                  .events[
                                                                      index1]
                                                                  .image
                                                                  .isEmpty
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        "dateOneday");
                                                                    print(categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .dateOneDay);
                                                                    print(
                                                                        "dateFin");
                                                                    print(categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .dateFin);
                                                                    print(
                                                                        "heureDe");
                                                                    print(categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .heureDebut);
                                                                    print(
                                                                        "heureFin");
                                                                    print(categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .heureFin);
                                                                    print(
                                                                        "weekdays");
                                                                    print(categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .weekDaysInfo);
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/eventDetails',
                                                                        arguments: {
                                                                          "event":
                                                                              categories![index].events[index1]
                                                                        });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(100)),
                                                                            image: DecorationImage(
                                                                              image: AssetImage("assets/images/logo_blanc.png"),
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                    width: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            3),
                                                                    height: Device
                                                                        .getDiviseScreenHeight(
                                                                            context,
                                                                            4.4),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    Provider.of<AppManagerProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .currentEventIndex = index1;
                                                                    Provider.of<AppManagerProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .currentEvent = categories![index]
                                                                            .events[
                                                                        index1];
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/eventDetails',
                                                                        arguments: {
                                                                          "event":
                                                                              categories![index].events[index1]
                                                                        });
                                                                  },
                                                                  child: Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(3),
                                                                        child:
                                                                            Container(
                                                                          width: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              3),
                                                                          height: Device.getDiviseScreenHeight(
                                                                              context,
                                                                              4.4),
                                                                          color:
                                                                              appColorProvider.primaryColor3,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.network(
                                                                                  width: Device.getDiviseScreenWidth(context, 3),
                                                                                  height: Device.getDiviseScreenHeight(context, 4.4),
                                                                                  // categories![index]
                                                                                  // .events[index1]
                                                                                  // .image,
                                                                                  categories![index].events[index1].image,
                                                                                  fit: BoxFit.cover),
                                                                              ClipRect(
                                                                                child: BackdropFilter(
                                                                                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                                                                  child: Container(
                                                                                    width: Device.getDiviseScreenWidth(context, 2.9),
                                                                                    height: Device.getDiviseScreenHeight(context, 4.4),
                                                                                    decoration: BoxDecoration(color: Colors.black45.withOpacity(.3)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: Image.network(
                                                                                    //categories![index].events[index1].image,
                                                                                    categories![index].events[index1].image,
                                                                                    fit: BoxFit.fitWidth),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3.5,
                                                            left: 3.5),
                                                    width: Device
                                                        .getDiviseScreenWidth(
                                                            context, 3),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(
                                                              left: Device
                                                                  .getDiviseScreenWidth(
                                                                      context,
                                                                      90)),
                                                          child: Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            categories![index]
                                                                .events[index1]
                                                                .titre,
                                                            style: GoogleFonts.poppins(
                                                                color:
                                                                    appColorProvider
                                                                        .black54,
                                                                fontSize:
                                                                    AppText.p5(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3.5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Hero(
                                                              tag:
                                                                  "Image_auteur$index$index1",
                                                              child: categories![index]
                                                                              .events[
                                                                                  index1]
                                                                              .auteur
                                                                              .image ==
                                                                          null ||
                                                                      categories![
                                                                              index]
                                                                          .events[
                                                                              index1]
                                                                          .auteur
                                                                          .image
                                                                          .isEmpty
                                                                  ? Container(
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                          image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/logo_blanc.png"),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                    )
                                                                  : ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              1000),
                                                                      child: Image.network(
                                                                          height: Device.getDiviseScreenHeight(context, 35),
                                                                          width: Device.getDiviseScreenHeight(context, 35),
                                                                          // categories![
                                                                          //     index]
                                                                          // .events[
                                                                          //     index1]
                                                                          // .auteur
                                                                          // .image,
                                                                          categories![index].events[index1].auteur.image,
                                                                          fit: BoxFit.cover),
                                                                    ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    left: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            60)),
                                                                child: Wrap(
                                                                  children: [
                                                                    Text(
                                                                      categories![
                                                                              index]
                                                                          .events[
                                                                              index1]
                                                                          .auteur
                                                                          .raisonSociale
                                                                          .toUpperCase(),
                                                                      style: GoogleFonts.poppins(
                                                                          color: appColorProvider
                                                                              .black45,
                                                                          fontSize: AppText.p6(
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            !etat!
                                                ? const SizedBox()
                                                : Positioned(
                                                    top: 9,
                                                    right: 7,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white70,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 6.0,
                                                                right: 3,
                                                                top: 3,
                                                                bottom: 3),
                                                        child: LikeButton(
                                                          onTap:
                                                              (isLiked) async {
                                                            // Likecontroller
                                                            //     .currentState!
                                                            //     .onTap();

                                                            // print('trrtttttttttttttt' +
                                                            //     categories[
                                                            //             index]
                                                            //         .events[
                                                            //             index1]
                                                            //         .favoris
                                                            //         .toString());
                                                            var isLike;

                                                            categories![index]
                                                                    .events[index1]
                                                                    .isLike =
                                                                !categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .isLike;
                                                            UserDBcontroller()
                                                                .liste()
                                                                .then(
                                                                    (value) async {
                                                              // print('ertttttt' +
                                                              //     categories[
                                                              //             index]
                                                              //         .events[
                                                              //             index1]
                                                              //         .isLike
                                                              //         .toString());
                                                              if (categories![
                                                                      index]
                                                                  .events[
                                                                      index1]
                                                                  .isLike) {
                                                                categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .setFavoris(
                                                                        categories![index].events[index1].favoris +
                                                                            1);

                                                                isLike = await addFavoris(
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .id);
                                                                setState(() {
                                                                  favorisId.add(categories![
                                                                          index]
                                                                      .events[
                                                                          index1]
                                                                      .id);
                                                                });
                                                              } else {
                                                                categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .setFavoris(
                                                                        categories![index].events[index1].favoris -
                                                                            1);
                                                                isLike = await removeFavoris(
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .id);
                                                                setState(() {
                                                                  favorisId.remove(categories![
                                                                          index]
                                                                      .events[
                                                                          index1]
                                                                      .id);
                                                                });
                                                              }
                                                            });
                                                            return isLike;
                                                          },

                                                          key: Likecontroller,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          /*  size: Device
                                                              .getDiviseScreenWidth(
                                                                  context, 22), */

                                                          // ignore: prefer_const_constructors
                                                          circleColor: CircleColor(
                                                              start: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  255,
                                                                  0,
                                                                  157),
                                                              end: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  204,
                                                                  0,
                                                                  61)),
                                                          bubblesColor:
                                                              const BubblesColor(
                                                            dotPrimaryColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    229,
                                                                    51,
                                                                    205),
                                                            dotSecondaryColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    204,
                                                                    0,
                                                                    95),
                                                          ),
                                                          isLiked: categories![
                                                                  index]
                                                              .events[index1]
                                                              .isLike,
                                                          likeBuilder:
                                                              (bool isLiked) {
                                                            categories![index]
                                                                .events[index1]
                                                                .isLike = isLiked;
                                                            if (favorisId.contains(
                                                                categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .id)) {
                                                              categories![index]
                                                                  .events[
                                                                      index1]
                                                                  .isLike = true;
                                                            }
                                                            // categories[index].events[index1].isLike
                                                            //     ? FavorisDBcontroller().insert(categories[index].events[index1]).then((value) {
                                                            //         FavorisDBcontroller().liste().then((value) {
                                                            //           print('favoris list' + value.toString());
                                                            //         });
                                                            //       })
                                                            //     : FavorisDBcontroller().delete(categories[index].events[index1]).then((value) {
                                                            //         FavorisDBcontroller().liste().then((value) {
                                                            //           print('favoris list' + value.toString());
                                                            //         });
                                                            //       });

                                                            return Center(
                                                              child: Icon(
                                                                LineIcons
                                                                    .heartAlt,
                                                                color: favorisId.contains(categories![index]
                                                                            .events[
                                                                                index1]
                                                                            .id) ||
                                                                        categories![index]
                                                                            .events[
                                                                                index1]
                                                                            .isLike
                                                                    //categories![index].events[index1].isLike
                                                                    ? appColorProvider
                                                                        .primary
                                                                    : Colors
                                                                        .black54,
                                                                size: 26,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          );
                        }),
                  ],
                );
              });
  }
}
