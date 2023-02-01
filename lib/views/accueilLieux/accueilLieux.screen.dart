import 'dart:convert';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/lieuEvent.dart';
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

class Lieux extends StatefulWidget {
  const Lieux({super.key});

  @override
  State<Lieux> createState() => _LieuxState();
}

class _LieuxState extends State<Lieux> {
  List _data = [];
  List _lieux = [];

  @override
  void initState() {
    getLieuxFromAPI();
    _data = Provider.of<EventsProvider>(context, listen: false).eventsLieux;
    print('data');
    print(_data);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLieuxFromAPI() async {
    List data = [];
    print("herrrrrrrrrrrrrrr");
    var response = await http.get(
      Uri.parse('$baseApiUrl/events/ville'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(response.body)['data'];

      Provider.of<EventsProvider>(context, listen: false).setEventsLieux(data);

      for (var i = 0; i < data.length; i++) {
        _lieux.add(data[i]['lieu']);
      }
    }
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

  getLieuFromMap(List lieuListFromAPI) {
    final List<LieuEvent> tagObjs = [];
    for (var element in lieuListFromAPI) {
      var lieu = LieuEvent.fromMap(element);
      if (lieu.events.isNotEmpty) {
        tagObjs.add(lieu);
      }
    }
    return tagObjs;
  }

  @override
  Widget build(BuildContext context) {
    return _data.isEmpty
        ? Center(child: CircularProgressIndicator())
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
                    itemCount: _data.length,
                    itemExtent: Device.getDiviseScreenWidth(context, 5),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (() {
                          Navigator.pushNamed(
                            context,
                            '/lieuEvents',
                            arguments: {"indexLieu": index},
                          );
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColorProvider.primaryColor4,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            right: Device.getDiviseScreenHeight(context, 150),
                          ),
                          child: Center(
                            child: Text(
                              _data[index]['lieu'] ?? '',
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
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: Device.getDiviseScreenHeight(context, 40),
                              left: Device.getDiviseScreenWidth(context, 30),
                              right: Device.getDiviseScreenWidth(context, 30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _data[index]['lieu'] ?? '',
                                style: GoogleFonts.poppins(
                                    color: appColorProvider.black,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w700),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/lieuEvents',
                                    arguments: {"indexLieu": index},
                                  );
                                },
                                child: Text(
                                  "AFFICHER PLUS",
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.primaryColor1,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: Device.getDiviseScreenHeight(context, 90),
                              left: Device.getDiviseScreenWidth(context, 30),
                              right: Device.getDiviseScreenWidth(context, 30)),
                          shrinkWrap: true,
                          itemCount: _data[index]['events'].length,
                          itemBuilder: (context, index1) {
                            final Likecontroller = GlobalKey<LikeButtonState>();
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Card(
                                  color: appColorProvider.menu.withOpacity(0.5),
                                  elevation: 0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: "Image_Event$index$index1",
                                        child: _data[index]['events'][index1]
                                                    ['event']['image']
                                                .isEmpty
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/logo_blanc.png"),
                                                      fit: BoxFit.cover,
                                                    )),
                                                width:
                                                    Device.getDiviseScreenWidth(
                                                        context, 3.5),
                                                height: Device
                                                    .getDiviseScreenHeight(
                                                        context, 7),
                                              )
                                            : InkWell(
                                                onDoubleTap: (() {
                                                  Likecontroller.currentState!
                                                      .onTap();
                                                }),
                                                onTap: () {
                                                  Event1 event1 =
                                                      Event1.fromMap(
                                                          _data[index]
                                                                      ['events']
                                                                  [index1]
                                                              ['event']);
                                                  Provider.of<AppManagerProvider>(
                                                              context,
                                                              listen: false)
                                                          .currentEventIndex =
                                                      index1;
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/eventDetails',
                                                    arguments: {
                                                      "event": event1
                                                    },
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      child: Container(
                                                        width: Device
                                                            .getDiviseScreenWidth(
                                                                context, 3.5),
                                                        height: Device
                                                            .getDiviseScreenHeight(
                                                                context, 7),
                                                        color: appColorProvider
                                                            .primaryColor3,
                                                        child: Stack(
                                                          children: [
                                                            Image.memory(
                                                              width: Device
                                                                  .getDiviseScreenWidth(
                                                                      context,
                                                                      3.5),
                                                              height: Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      7),
                                                              fit: BoxFit.fill,
                                                              base64Decode(_data[index]['events']
                                                                              [
                                                                              index1]
                                                                          [
                                                                          'event']
                                                                      [
                                                                      'image'] ??
                                                                  ""),
                                                            ),
                                                            ClipRect(
                                                              child:
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            3.0,
                                                                        sigmaY:
                                                                            3.0),
                                                                child:
                                                                    Container(
                                                                  width: Device
                                                                      .getDiviseScreenWidth(
                                                                          context,
                                                                          3.5),
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          7),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black45
                                                                        .withOpacity(
                                                                            .3),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Image.memory(
                                                                  base64Decode(
                                                                      _data[index]['events'][index1]['event']
                                                                              [
                                                                              'image'] ??
                                                                          ""),
                                                                  fit: BoxFit
                                                                      .fitWidth),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: Device
                                                          .getDiviseScreenWidth(
                                                              context, 100),
                                                      top: Device
                                                          .getDiviseScreenWidth(
                                                              context, 100),
                                                      child: Container(
                                                        height: Device
                                                            .getDiviseScreenWidth(
                                                                context, 20),
                                                        width: Device
                                                            .getDiviseScreenWidth(
                                                                context, 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                              100,
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        // ignore: prefer_const_constructors
                                                        child: Center(
                                                          // ignore: prefer_const_constructors
                                                          child: Stack(
                                                            children: [
                                                              // LikeButton(
                                                              //   key:
                                                              //       Likecontroller,
                                                              //   mainAxisAlignment:
                                                              //       MainAxisAlignment
                                                              //           .end,
                                                              //   size: Device.getDiviseScreenWidth(
                                                              //       context,
                                                              //       27),
                                                              //   // ignore: prefer_const_constructors
                                                              //   circleColor: CircleColor(
                                                              //       start: const Color.fromARGB(
                                                              //           255,
                                                              //           255,
                                                              //           0,
                                                              //           157),
                                                              //       end: const Color.fromARGB(
                                                              //           255,
                                                              //           204,
                                                              //           0,
                                                              //           61)),
                                                              //   bubblesColor:
                                                              //       const BubblesColor(
                                                              //     dotPrimaryColor: Color.fromARGB(
                                                              //         255,
                                                              //         229,
                                                              //         51,
                                                              //         205),
                                                              //     dotSecondaryColor: Color.fromARGB(
                                                              //         255,
                                                              //         204,
                                                              //         0,
                                                              //         95),
                                                              //   ),
                                                              // isLiked: _data[index]['events'][index1]
                                                              //         [
                                                              //         'event']
                                                              //     .isLike,
                                                              // isLiked:
                                                              //     false,
                                                              //   likeBuilder:
                                                              //       (bool
                                                              //           isLiked) {
                                                              //     _data[index]['events'][index1]['event'].isLike =
                                                              //         isLiked;
                                                              //     return Center(
                                                              //       child:
                                                              //           Icon(
                                                              //         LineIcons.heartAlt,
                                                              //         color: _data[index]['events'][index1]['event'].isLike
                                                              //             ? appColorProvider.primary
                                                              //             : Colors.black12,
                                                              //         size:
                                                              //             15,
                                                              //       ),
                                                              //     );
                                                              //   },
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: Device.getDiviseScreenHeight(
                                              context, 90),
                                          left: Device.getDiviseScreenWidth(
                                              context, 50),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: Device
                                                    .getDiviseScreenHeight(
                                                        context, 90),
                                                left:
                                                    Device.getDiviseScreenWidth(
                                                        context, 90),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    '${_data[index]['events'][index1]['event']['titre'] ?? ''}',
                                                    style: GoogleFonts.poppins(
                                                        color: appColorProvider
                                                            .black87,
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const Gap(3),
                                                  Container(
                                                    width: Device
                                                        .getDiviseScreenWidth(
                                                            context, 1.8),
                                                    child: Text(
                                                      '${_data[index]['events'][index1]['event']['desc'] ?? ''}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      maxLines: 3,
                                                      style: GoogleFonts.poppins(
                                                          color:
                                                              appColorProvider
                                                                  .black45,
                                                          fontSize: AppText.p4(
                                                              context),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Gap(3),
                                            Row(
                                              children: [
                                                Hero(
                                                  tag:
                                                      "Image_auteur$index$index1",
                                                  child: _data[index]['events'][
                                                                          index1]
                                                                      ['event']
                                                                  ['user']
                                                              ['picture'] ==
                                                          null
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
                                                          height: Device
                                                              .getDiviseScreenHeight(
                                                                  context, 50),
                                                          width: 25,
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            imageUrl: _data[index]['events']
                                                                            [
                                                                            index1]
                                                                        [
                                                                        'event']['user']
                                                                    [
                                                                    'picture'] ??
                                                                "",
                                                            height: Device
                                                                .getDiviseScreenHeight(
                                                                    context,
                                                                    35),
                                                            width: Device
                                                                .getDiviseScreenHeight(
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
                                                              context, 100)),
                                                  child: Text(
                                                    (_data[index]['events'][index1]
                                                                        [
                                                                        'event']
                                                                    ['user'][
                                                                'nomResponsable'] ??
                                                            '')
                                                        .toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                        color: appColorProvider
                                                            .black45,
                                                        fontSize:
                                                            AppText.p6(context),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
