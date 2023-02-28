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
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var token;
  @override
  void initState() {
    getCategoriesFromAPI();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCategoriesFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    print('token'+token);
    var response = await http.get(
      Uri.parse('$baseApiUrl/events/categoriesWithEvents'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() { var ddd = jsonDecode(response.body)['data'] as List;
        categories =
            getCategorieFromMap(jsonDecode(response.body)['data'] as List);
            print("livliccccccccccfffff"+ddd.length.toString());
      });
      for (var element in categories!) {
        await CategorieDBcontroller().insert(element);
        //var test = jsonEncode(element.events);

      }
      final eventsDB = await CategorieDBcontroller().liste();

      //print('eventdb1111111111444' +
      // jsonDecode(jsonDecode(jsonEncode(eventsDB))[0]['events'])[0]['titre']
      //     .toString());

      final eventDB1 =
          getCategorieFromLocalMap(jsonDecode(jsonEncode(eventsDB)));
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
      var categorie = Categorie.fromMap(element);
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
    return categories == null
        ? Center(child: CircularProgressIndicator())
        : categories!.isEmpty?
        Center(child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: 350,
              width: 350,
                      child: Image.asset('assets/images/empty.png'),
                    ),
             const Text(
                            'Pas de Favoris',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.primary,
                            ),
                          ),
          ],
        ),)
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
                              right:
                                  Device.getDiviseScreenHeight(context, 150)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .categoriesIcon(categories![index].code),
                                color: appColorProvider.darkMode
                                    ? Colors.white70
                                    : appColorProvider.white,
                                size: AppText.p1(context),
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
                                top: Device.getDiviseScreenHeight(context, 40),
                                left: Device.getDiviseScreenWidth(context, 30),
                                right:
                                    Device.getDiviseScreenWidth(context, 30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          "categorie":
                                              categories![index] as Categorie
                                        });
                                  }),
                                  child: Text(
                                    "AFFICHER PLUS ",
                                    style: GoogleFonts.poppins(
                                        color: appColorProvider.primaryColor1,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints.expand(
                              height:
                                  Device.getDiviseScreenHeight(context, 3.1),
                            ),
                            height: Device.getDiviseScreenHeight(context, 3.1),
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
                                  
                      // print('fffffffffff'+base64.decode(base64Decode(categories![index].events[index1]
                      //                                                         .image).toString()).toString());
                                  int lent = categories![index]
                                      .events[index1]
                                      .titre
                                      .length;
                                  int lentAuteur = categories![index]
                                      .events[index1]
                                      .auteur
                                      .nom
                                      .length;
                                  final Likecontroller =
                                      GlobalKey<LikeButtonState>();
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            child: Hero(
                                              tag: "Image_Event$index$index1",
                                              child:
                                                  categories![index]
                                                          .events[index1]
                                                          .image
                                                          .isEmpty
                                                      ? Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              100)),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/logo_blanc.png"),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                          width: Device
                                                              .getDiviseScreenWidth(
                                                                  context, 3),
                                                          height: Device
                                                              .getDiviseScreenHeight(
                                                                  context, 4.4),
                                                        )
                                                      : InkWell(
                                                          onDoubleTap: (() {
                                                            Likecontroller
                                                                .currentState!
                                                                .onTap();
                                                            // print('trrtttttttttttttt' +
                                                            //     categories[
                                                            //             index]
                                                            //         .events[
                                                            //             index1]
                                                            //         .favoris
                                                            //         .toString());
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
                                                                print(categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .favoris);
                                                                categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .setFavoris(
                                                                        categories![index].events[index1].favoris +
                                                                            1);
                                                                print(categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .favoris);

                                                                await modifyFavoris(
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .id,
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .favoris);
                                                                        await addFavoris(
                                                          categories![
                                                                            index]
                                                                        .events[index].id,);
                                                              } else {
                                                                print(categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .favoris);
                                                                categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .setFavoris(
                                                                        categories![index].events[index1].favoris -
                                                                            1);
                                                                print(categories![
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .favoris);
                                                                await modifyFavoris(
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .id,
                                                                    categories![
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .favoris);
                                                                         await addFavoris(
                                                          categories![
                                                                            index]
                                                                        .events[index].id,);
                                                              }
                                                            });
                                                          }),
                                                          onTap: () {
                                                            Provider.of<AppManagerProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .currentEventIndex =
                                                                index1;
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/eventDetails',
                                                                arguments: {
                                                                  "event": categories![
                                                                          index]
                                                                      .events[index1]
                                                                });
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                child:
                                                                    Container(
                                                                  width: Device
                                                                      .getDiviseScreenWidth(
                                                                          context,
                                                                          3),
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          4.4),
                                                                  color: appColorProvider
                                                                      .primaryColor3,
                                                                  child: Stack(
                                                                    children: [
                                                                      Image.network(
                                                                          width: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              3),
                                                                          height: Device.getDiviseScreenHeight(
                                                                              context,
                                                                              4.4),
                                                                              'https://weezevent.com/wp-content/uploads/2018/08/27184142/organiser-un-concert-en-7-etapes.png',
                                                                          // base64Decode('aHR0cHM6Ly93ZWV6ZXZlbnQuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE4LzA4LzI3MTg0MTQyL29yZ2FuaXNlci11bi1jb25jZXJ0LWVuLTctZXRhcGVzLnBuZw=='
                                                                          //   // categories![index]
                                                                          //   //   .events[index1]
                                                                          //   //   .image
                                                                          //     ),
                                                                          fit: BoxFit.cover),
                                                                      ClipRect(
                                                                        child:
                                                                            BackdropFilter(
                                                                          filter: ImageFilter.blur(
                                                                              sigmaX: 4.0,
                                                                              sigmaY: 4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                Device.getDiviseScreenWidth(context, 2.9),
                                                                            height:
                                                                                Device.getDiviseScreenHeight(context, 4.4),
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.black45.withOpacity(.3)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: Image.network('https://weezevent.com/wp-content/uploads/2018/08/27184142/organiser-un-concert-en-7-etapes.png',
                                                                            // base64Decode('aHR0cHM6Ly93ZWV6ZXZlbnQuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE4LzA4LzI3MTg0MTQyL29yZ2FuaXNlci11bi1jb25jZXJ0LWVuLTctZXRhcGVzLnBuZw=='
                                                                            //  // categories![index].events[index1].image
                                                                            //   ),
                                                                            fit: BoxFit.fitWidth),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  right:
                                                                      Device.getDiviseScreenWidth(
                                                                          context,
                                                                          100),
                                                                  top: Device
                                                                      .getDiviseScreenWidth(
                                                                          context,
                                                                          90),
                                                                  child:
                                                                      Container(
                                                                    height: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            20),
                                                                    width: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            20),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                100)),
                                                                        color: Colors
                                                                            .white),
                                                                    // ignore: prefer_const_constructors
                                                                    child:
                                                                        Center(
                                                                      // ignore: prefer_const_constructors
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          LikeButton(
                                                                            key:
                                                                                Likecontroller,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            size:
                                                                                Device.getDiviseScreenWidth(context, 27),
                                                                            // ignore: prefer_const_constructors
                                                                            circleColor:
                                                                                CircleColor(start: const Color.fromARGB(255, 255, 0, 157), end: const Color.fromARGB(255, 204, 0, 61)),
                                                                            bubblesColor:
                                                                                const BubblesColor(
                                                                              dotPrimaryColor: Color.fromARGB(255, 229, 51, 205),
                                                                              dotSecondaryColor: Color.fromARGB(255, 204, 0, 95),
                                                                            ),
                                                                            isLiked:
                                                                                categories![index].events[index1].isLike,
                                                                            likeBuilder:
                                                                                (bool isLiked) {
                                                                              categories![index].events[index1].isLike = isLiked;

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
                                                                                  LineIcons.heartAlt,
                                                                                  color: categories![index].events[index1].isLike ? appColorProvider.primary : Colors.black12,
                                                                                  size: 15,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 3.5, left: 3.5),
                                            width: Device.getDiviseScreenWidth(
                                                context, 3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: Device
                                                          .getDiviseScreenWidth(
                                                              context, 90)),
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    categories![index]
                                                        .events[index1]
                                                        .titre,
                                                    style: GoogleFonts.poppins(
                                                        color: appColorProvider
                                                            .black54,
                                                        fontSize:
                                                            AppText.p5(context),
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                                      child:
                                                          categories![index]
                                                                  .events[
                                                                      index1]
                                                                  .auteur
                                                                  .image
                                                                  .isEmpty
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              1000),
                                                                  child: Image.network(
                                                                      height: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          35),
                                                                      width: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          35),
                                                                          'https://weezevent.com/wp-content/uploads/2018/08/27184142/organiser-un-concert-en-7-etapes.png',
                                                                      // base64Decode('aHR0cHM6Ly93ZWV6ZXZlbnQuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE4LzA4LzI3MTg0MTQyL29yZ2FuaXNlci11bi1jb25jZXJ0LWVuLTctZXRhcGVzLnBuZw=='
                                                                      //   // categories![
                                                                      //   //       index]
                                                                      //   //   .events[
                                                                      //   //       index1]
                                                                      //   //   .image
                                                                      //     ),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              1000),
                                                                  child: Image.network(
                                                                      height: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          35),
                                                                      width: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          35),
                                                                          'https://weezevent.com/wp-content/uploads/2018/08/27184142/organiser-un-concert-en-7-etapes.png',
                                                                      // base64Decode('aHR0cHM6Ly93ZWV6ZXZlbnQuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE4LzA4LzI3MTg0MTQyL29yZ2FuaXNlci11bi1jb25jZXJ0LWVuLTctZXRhcGVzLnBuZw=='
                                                                      //   // categories![
                                                                      //   //       index]
                                                                      //   //   .events[
                                                                      //   //       index1]
                                                                      //   //   .auteur
                                                                      //   //   .image
                                                                      //     ),
                                                                      fit: BoxFit
                                                                          .cover),
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
                                                              categories![index]
                                                                  .events[
                                                                      index1]
                                                                  .titre
                                                                  .toUpperCase(),
                                                              style: GoogleFonts.poppins(
                                                                  color: appColorProvider
                                                                      .black45,
                                                                  fontSize:
                                                                      AppText.p6(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
