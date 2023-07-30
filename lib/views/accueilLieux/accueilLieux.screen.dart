import 'dart:convert';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/lieuEvent.dart';
import 'package:cible/models/categorie.dart' as categorieModel;
import 'package:cible/providers/eventsProvider.dart';
import 'package:cible/views/accueilLieux/accueilLieux.controller.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cible/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../accueilFavoris/acceuilFavoris.controller.dart';

class Lieux extends StatefulWidget {
  Lieux({required this.countryLibelle, super.key});
  String countryLibelle;

  @override
  State<Lieux> createState() => _LieuxState();
}

class _LieuxState extends State<Lieux> {
  List? _data;
  List _lieux = [];

  List<dynamic> allEventLieu = [];
  List<Event1>? listFavoris;
  List favorisId = [];
  var token;
  bool? etat;
  String? selectedLieu;
  List? EventLieuxSelected;

  @override
  void initState() {
    getFavorisFromAPI();
    getLieuxFromAPI();
    print('data');
    print(_data);
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
    print(response.statusCode);

    //print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        listFavoris = categorieModel
            .getEventFromMap(jsonDecode(response.body)['data'] as List, {});
        for (var favoris in listFavoris!) {
          favorisId.add(favoris.id);
        }
        print('favoris id' + favorisId.toString());
      });
    }
  }

  getLieuxFromAPI() async {
    etat = await SharedPreferencesHelper.getBoolValue("logged");
    print('etaaaaaaaaaaaaaat' + etat.toString());
    token = await SharedPreferencesHelper.getValue('token');
    List data = [];
    var response = etat!
        ? await http.get(
            Uri.parse('$baseApiUrl/evenements/grouped_by_villes'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          )
        : await http.get(
            Uri.parse(
                '$baseApiUrl/evenements/evenements_par_lieu/${widget.countryLibelle}'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $apiKey',
            },
          );

    print('WTFffffffffffffffffff' + response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(response.body)['data'];

      //Provider.of<EventsProvider>(context, listen: false).setEventsLieux(data);
      //print("helllllllllll"+Provider.of<EventsProvider>(context, listen: false).eventsLieux.toString());
      setState(() {
        _data = getLieuFromMap(data);
        Provider.of<EventsProvider>(context, listen: false)
            .setEventsLieux(_data!);
        //_data = Provider.of<EventsProvider>(context, listen: false).eventsLieux;
      });

      // for (var i = 0; i < data.length; i++) {
      //   _lieux.add(data[i]['lieu']);
      // }
      return _data;
    }
  }

  getLieuFromMap(List lieuListFromAPI) {
    final List tagObjs = [];
    for (var element in lieuListFromAPI) {
      print('fatouuuu' + element.toString());
      if (element['lieu'] != null) {
        allEventLieu.add(element['lieu']);
      }

      var lieu = {
        'lieu': element['ville'],
        'events': getEventFromMap(
          element['events'] ?? [],
        ),
      };
      List<Event1> events = lieu['events'];
      if (events.isNotEmpty) {
        tagObjs.add(lieu);
      }
    }

    print('zsssssssssssssssssssss' + allEventLieu.toString());
    return tagObjs;
  }

  Stream<LieuEvent> categoriesStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      LieuEvent lieux = getLieuxFromAPI();
      yield lieux;
    }
  }

  getLieuEvent(events) {
    for (var element in lieux) {
      element.events = events;
    }
  }

  // getLieuFromMap(List lieuListFromAPI) {
  //   final List<LieuEvent> tagObjs = [];
  //   for (var element in lieuListFromAPI) {
  //     var lieu = LieuEvent.fromMap(element);
  //     if (lieu.events.isNotEmpty) {
  //       tagObjs.add(lieu);
  //     }
  //   }
  //   return tagObjs;
  // }

  @override
  Widget build(BuildContext context) {
    return _data == null
        ? Center(child: CircularProgressIndicator())
        : _data!.isEmpty
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
                      height: Device.getDiviseScreenHeight(context, 20),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: Device.getDiviseScreenHeight(context, 90),
                            left: Device.getDiviseScreenWidth(context, 30),
                            right: Device.getDiviseScreenWidth(context, 30)),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _data!.length,
                        itemExtent: Device.getDiviseScreenWidth(context, 5),
                        itemBuilder: (BuildContext context, int index) {
                          return _data![index]['lieu'] == null ||
                                  _data![index]['lieu'] == ''
                              ? const SizedBox()
                              : InkWell(
                                  onTap: (() {
                                    print('Liliiiiiiii' + index.toString());
                                    setState(() {
                                      if (selectedLieu ==
                                          _data![index]['lieu']) {
                                        selectedLieu = '';
                                        _data = Provider.of<EventsProvider>(
                                                context,
                                                listen: false)
                                            .eventsLieux;
                                      } else {
                                        selectedLieu = _data![index]['lieu'];
                                        _data = [_data![index]];
                                      }
                                    });
                                    // Provider.of<EventsProvider>(context, listen: false).setEventsLieux(_data!);
                                    //   Navigator.pushNamed(
                                    //     context,
                                    //     '/lieuEvents',
                                    //     arguments: {"indexLieu": index},
                                    //   );
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          selectedLieu == _data![index]['lieu']
                                              ? appColorProvider.white
                                              : appColorProvider.primaryColor4,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                      right: Device.getDiviseScreenHeight(
                                          context, 150),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _data![index]['lieu'] ?? '',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: appColorProvider.primaryColor1,
                                          fontSize: AppText.p4(context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _data!.length,
                      itemBuilder: (context, index) {
                        return _data![index]['events'].isEmpty
                            ? const SizedBox()
                            : Column(
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
                                          _data![index]['lieu'] ?? '',
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.black,
                                              fontSize: AppText.p2(context),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        // InkWell(
                                        //   onTap: () {
                                        //     Navigator.pushNamed(
                                        //       context,
                                        //       '/lieuEvents',
                                        //       arguments: {"indexLieu": index},
                                        //     );
                                        //   },
                                        //   child: Text(
                                        //     "AFFICHER PLUS",
                                        //     style: GoogleFonts.poppins(
                                        //         color: appColorProvider.primaryColor1,
                                        //         fontSize: AppText.p4(context),
                                        //         fontWeight: FontWeight.w500),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: Device.getDiviseScreenHeight(
                                            context, 90),
                                        left: Device.getDiviseScreenWidth(
                                            context, 30),
                                        right: Device.getDiviseScreenWidth(
                                            context, 30)),
                                    shrinkWrap: true,
                                    itemCount: _data![index]['events'].length,
                                    itemBuilder: (context, index1) {
                                      int lent = _data![index]['events'][index1]
                                          .titre
                                          .length;
                                      final Likecontroller =
                                          GlobalKey<LikeButtonState>();
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Card(
                                            color: appColorProvider.menu
                                                .withOpacity(0.5),
                                            elevation: 0,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Hero(
                                                  tag:
                                                      "Image_Event$index$index1",
                                                  child:
                                                      _data![index]['events']
                                                                  [index1]
                                                              .image
                                                              .isEmpty
                                                          ? Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
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
                                                                      context,
                                                                      3.5),
                                                              height: Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      7),
                                                            )
                                                          : InkWell(
                                                              onDoubleTap: (() {
                                                                Likecontroller
                                                                    .currentState!
                                                                    .onTap();
                                                              }),
                                                              onTap: () {
                                                                // Event1 event1 =
                                                                //     Event1.fromMap(
                                                                //         _data![index]
                                                                //                     ['events']
                                                                //                 [index1]
                                                                //             ['event']);
                                                                Provider.of<AppManagerProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .currentEventIndex = index1;
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/eventDetails',
                                                                  arguments: {
                                                                    "event": _data![index]
                                                                            [
                                                                            'events']
                                                                        [index1]
                                                                  },
                                                                );
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
                                                                    child:
                                                                        Container(
                                                                      width: Device.getDiviseScreenWidth(
                                                                          context,
                                                                          3.5),
                                                                      height: Device
                                                                          .getDiviseScreenHeight(
                                                                              context,
                                                                              7),
                                                                      color: appColorProvider
                                                                          .primaryColor3,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            // _data![index]['events']
                                                                            //                 [
                                                                            //                 index1]
                                                                            //             [
                                                                            //             'event']
                                                                            //         [
                                                                            //         'image'] ??
                                                                            //     "",
                                                                            _data![index]['events'][index1].image ??
                                                                                "",
                                                                            width:
                                                                                Device.getDiviseScreenWidth(context, 3.5),
                                                                            height:
                                                                                Device.getDiviseScreenHeight(context, 7),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                          ClipRect(
                                                                            child:
                                                                                BackdropFilter(
                                                                              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                                                              child: Container(
                                                                                width: Device.getDiviseScreenWidth(context, 3.5),
                                                                                height: Device.getDiviseScreenHeight(context, 7),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.black45.withOpacity(.3),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Image.network(
                                                                                // _data![index]['events'][index1]['event']
                                                                                //               [
                                                                                //               'image'] ??
                                                                                //           "",

                                                                                _data![index]['events'][index1].image ?? "",
                                                                                fit: BoxFit.fitWidth),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  !etat!
                                                                      ? const SizedBox()
                                                                      : Positioned(
                                                                          right: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              100),
                                                                          top: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              100),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                Device.getDiviseScreenWidth(context, 20),
                                                                            width:
                                                                                Device.getDiviseScreenWidth(context, 20),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(
                                                                                  100,
                                                                                ),
                                                                              ),
                                                                              color: Colors.white,
                                                                            ),
                                                                            // ignore: prefer_const_constructors
                                                                            child:
                                                                                Center(
                                                                              // ignore: prefer_const_constructors
                                                                              child: Stack(
                                                                                children: [
                                                                                  LikeButton(
                                                                                    onTap: (isLiked) async {
                                                                                      var isLike;
                                                                                      print('dddddddddddddd1' + _data![index]['events'][index1].isLike.toString());

                                                                                      _data![index]['events'][index1].isLike = !_data![index]['events'][index1].isLike;
                                                                                      print('dddddddddddddd2' + _data![index]['events'][index1].isLike.toString());
                                                                                      UserDBcontroller().liste().then((value) async {
                                                                                        // print('ertttttt' +
                                                                                        //     categories[
                                                                                        //             index]
                                                                                        //         .events[
                                                                                        //             index1]
                                                                                        //         .isLike
                                                                                        //         .toString());
                                                                                        if (_data![index]['events'][index1].isLike) {
                                                                                          print(_data![index]['events'][index1].favoris);
                                                                                          _data![index]['events'][index1].setFavoris(_data![index]['events'][index1].favoris + 1);
                                                                                          print(_data![index]['events'][index1].favoris);

                                                                                          isLike = await addFavoris(_data![index]['events'][index1].id);
                                                                                          setState(() {
                                                                                            favorisId.add(_data![index]['events'][index1].id);
                                                                                          });
                                                                                        } else {
                                                                                          print(_data![index]['events'][index1].favoris);
                                                                                          _data![index]['events'][index1].setFavoris(_data![index]['events'][index1].favoris - 1);
                                                                                          print(_data![index]['events'][index1].favoris);
                                                                                          isLike = await removeFavoris(_data![index]['events'][index1].id);
                                                                                          setState(() {
                                                                                            favorisId.remove(_data![index]['events'][index1].id);
                                                                                          });
                                                                                        }
                                                                                      });
                                                                                      return isLike;
                                                                                    },

                                                                                    key: Likecontroller,
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    size: Device.getDiviseScreenWidth(context, 27),
                                                                                    // ignore: prefer_const_constructors
                                                                                    circleColor: CircleColor(start: const Color.fromARGB(255, 255, 0, 157), end: const Color.fromARGB(255, 204, 0, 61)),
                                                                                    bubblesColor: const BubblesColor(
                                                                                      dotPrimaryColor: Color.fromARGB(255, 229, 51, 205),
                                                                                      dotSecondaryColor: Color.fromARGB(255, 204, 0, 95),
                                                                                    ),
                                                                                    isLiked: _data![index]['events'][index1].isLike,
                                                                                    likeBuilder: (bool isLiked) {
                                                                                      _data![index]['events'][index1].isLike = isLiked;
                                                                                      if (favorisId.contains(_data![index]['events'][index1].id)) {
                                                                                        _data![index]['events'][index1].isLike = true;
                                                                                      }
                                                                                      return Center(
                                                                                        child: Icon(
                                                                                          LineIcons.heartAlt,
                                                                                          color: favorisId.contains(_data![index]['events'][index1].id) || _data![index]['events'][index1].isLike ? appColorProvider.primary : Colors.black12,
                                                                                          size: 15,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      top: Device
                                                          .getDiviseScreenHeight(
                                                              context, 90),
                                                      left: Device
                                                          .getDiviseScreenWidth(
                                                              context, 50),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: Device
                                                                .getDiviseScreenHeight(
                                                                    context,
                                                                    90),
                                                            left: Device
                                                                .getDiviseScreenWidth(
                                                                    context,
                                                                    90),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                '${_data![index]['events'][index1].titre ?? ''}',
                                                                style: GoogleFonts.poppins(
                                                                    color: appColorProvider
                                                                        .black87,
                                                                    fontSize:
                                                                        AppText.p3(
                                                                            context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          200)),
                                                              Container(
                                                                width: Device
                                                                    .getDiviseScreenWidth(
                                                                        context,
                                                                        1.8),
                                                                height: Device
                                                                    .getDiviseScreenHeight(
                                                                        context,
                                                                        20),
                                                                child: Text(
                                                                  '${_data![index]['events'][index1].description ?? ''}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 3,
                                                                  style: GoogleFonts.poppins(
                                                                      color: appColorProvider
                                                                          .black45,
                                                                      fontSize:
                                                                          AppText.p4(
                                                                              context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Hero(
                                                              tag:
                                                                  "Image_auteur$index$index1",
                                                              child: _data![index]['events'][index1]
                                                                              .auteur
                                                                              .image ==
                                                                          null ||
                                                                      _data![index]['events'][index1]
                                                                              .auteur
                                                                              .image ==
                                                                          ''
                                                                  ? Container(
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                          image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/logo_blanc.png"),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                      height: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          50),
                                                                      width: 25,
                                                                    )
                                                                  : ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child: Image
                                                                          .network(
                                                                        _data![index]['events'][index1].auteur.image ??
                                                                            "",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height: Device.getDiviseScreenHeight(
                                                                            context,
                                                                            35),
                                                                        width: Device.getDiviseScreenHeight(
                                                                            context,
                                                                            35),
                                                                      ),
                                                                    ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(
                                                                  left: Device
                                                                      .getDiviseScreenWidth(
                                                                          context,
                                                                          100)),
                                                              child: Text(
                                                                (_data![index]['events'][index1]
                                                                            .auteur
                                                                            .raisonSociale ??
                                                                        '')
                                                                    .toUpperCase(),
                                                                style: GoogleFonts.poppins(
                                                                    color: appColorProvider
                                                                        .black45,
                                                                    fontSize:
                                                                        AppText.p6(
                                                                            context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                );
              });
  }
}
