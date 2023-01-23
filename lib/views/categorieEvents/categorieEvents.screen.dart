import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.controller.dart';
import 'package:cible/views/eventDetails/eventDetails.controller.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:gap/gap.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';

class CategorieEvents extends StatefulWidget {
  Map data;
  CategorieEvents({super.key, required this.data});

  @override
  State<CategorieEvents> createState() =>
      _CategorieEventsState(data['categorie'] as Categorie);
}

const String image =
    "https://musee-possen.lu/wp-content/uploads/2020/08/placeholder.png";

class _CategorieEventsState extends State<CategorieEvents> {
  Categorie categorie;
  final Likecontroller = GlobalKey<LikeButtonState>();
  final disLikecontroller = GlobalKey<LikeButtonState>();
  final favoriscontroller = GlobalKey<LikeButtonState>();
  final sharecontroller = GlobalKey<LikeButtonState>();
  _CategorieEventsState(this.categorie);

  @override
  void initState() {
    getCategoriesFromAPI();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  getCategoriesFromAPI() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/events/categorieevents/${categorie.id}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        categorie.events =
            getEventFromMap(jsonDecode(response.body)['data'] as List);
      });
    }
  }

  getEventFromMap(List eventsListFromAPI) {
    final List<Event1> tagObjs = [];
    for (var element in eventsListFromAPI) {
      var event = Event1.fromMap(element, null);

      // print(event.created_at);
      // Event1()
      tagObjs.add(event);
    }
    return tagObjs;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
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
            "${categorie.titre}",
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p1(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black87),
          ),
        ),
        body: Container(
          color: appColorProvider.white,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: categorie.events.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10000)),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(
                                  base64Decode(categorie.events[index].image)),
                              fit: BoxFit.cover,
                            )),
                            height: Device.getDiviseScreenHeight(context, 20),
                            width: Device.getDiviseScreenHeight(context, 20),
                          ),
                        ),
                        title: Text(
                          "DIGITAL INNOV GROUP",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p3(context),
                            fontWeight: FontWeight.w800,
                            color: appColorProvider.black87,
                          ),
                        ),
                        subtitle: Text(
                          "digitalinnovgroup@gmail.com",
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p4(context),
                            fontWeight: FontWeight.w400,
                            color: appColorProvider.black54,
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: appColorProvider.primary,
                        ),
                      ),
                    ),
                    const Gap(5),
                    categorie.events[index].image.isEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/logo_blanc.png"),
                                  fit: BoxFit.cover,
                                )),
                            width: Device.getDiviseScreenWidth(context, 1),
                            height: Device.getDiviseScreenHeight(context, 2.4),
                          )
                        : InkWell(
                            onTap: () {
                              Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .currentEventIndex = index;
                              Navigator.pushNamed(context, '/eventDetails',
                                  arguments: {
                                    "event": categorie.events[index]
                                  });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  // borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width:
                                        Device.getDiviseScreenWidth(context, 1),
                                    height: Device.getDiviseScreenHeight(
                                        context, 2.4),
                                    color: appColorProvider.primaryColor3,
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                            width: Device.getDiviseScreenWidth(
                                                context, 1),
                                            height:
                                                Device.getDiviseScreenHeight(
                                                    context, 2.4),
                                            base64Decode(
                                                categorie.events[index].image),
                                            fit: BoxFit.cover),
                                        ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 4.0, sigmaY: 4.0),
                                            child: Container(
                                              width:
                                                  Device.getDiviseScreenWidth(
                                                      context, 1),
                                              height:
                                                  Device.getDiviseScreenHeight(
                                                      context, 2.4),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Image.memory(
                                              base64Decode(categorie
                                                  .events[index].image),
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Device.getDiviseScreenHeight(context, 100),
                        horizontal: Device.getDiviseScreenHeight(context, 70),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: appColorProvider.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Device.getDiviseScreenHeight(
                                                  context, 100),
                                          vertical:
                                              Device.getDiviseScreenHeight(
                                                  context, 100)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              LikeButton(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                size:
                                                    Device.getDiviseScreenWidth(
                                                        context, 27),
                                                // ignore: prefer_const_constructors
                                                circleColor: CircleColor(
                                                    start: const Color.fromARGB(
                                                        255, 255, 0, 157),
                                                    end: const Color.fromARGB(
                                                        255, 204, 0, 61)),
                                                bubblesColor:
                                                    const BubblesColor(
                                                  dotPrimaryColor:
                                                      Color.fromARGB(
                                                          255, 229, 51, 205),
                                                  dotSecondaryColor:
                                                      Color.fromARGB(
                                                          255, 204, 0, 95),
                                                ),
                                                isLiked: categorie
                                                    .events[index].isLike,
                                                onTap: ((isLiked) async {
                                                  categorie.events[index]
                                                          .isLike =
                                                      !categorie
                                                          .events[index].isLike;
                                                  addLike(
                                                      categorie.events[index]);
                                                  Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {});
                                                  });
                                                  return await isLiked;
                                                }),

                                                likeBuilder: (bool isLiked) {
                                                  return Center(
                                                    child: Icon(
                                                      LineIcons.thumbsUp,
                                                      color: categorie
                                                              .events[index]
                                                              .isLike
                                                          ? appColorProvider
                                                              .primary
                                                          : appColorProvider
                                                              .black38,
                                                      size: AppText.p1(context),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const Gap(15),
                                              Text(
                                                '${categorie.events[index].like}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      appColorProvider.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              LikeButton(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                size:
                                                    Device.getDiviseScreenWidth(
                                                        context, 27),
                                                // ignore: prefer_const_constructors
                                                circleColor: CircleColor(
                                                    start: Color.fromARGB(
                                                        255, 0, 119, 255),
                                                    end: Color.fromARGB(
                                                        255, 0, 37, 204)),
                                                bubblesColor:
                                                    const BubblesColor(
                                                  dotPrimaryColor:
                                                      Color.fromARGB(
                                                          255, 51, 84, 229),
                                                  dotSecondaryColor:
                                                      Color.fromARGB(
                                                          255, 0, 129, 204),
                                                ),
                                                isLiked: categorie
                                                    .events[index].isDislike,
                                                onTap: ((isLiked) async {
                                                  categorie.events[index]
                                                          .isDislike =
                                                      !categorie.events[index]
                                                          .isDislike;
                                                  addDisLike(
                                                      categorie.events[index]);
                                                  Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {});
                                                  });
                                                  return await isLiked;
                                                }),
                                                likeBuilder: (bool isLiked) {
                                                  return Center(
                                                    child: Icon(
                                                      LineIcons.thumbsDown,
                                                      color: categorie
                                                              .events[index]
                                                              .isDislike
                                                          ? Colors.blue
                                                          : appColorProvider
                                                              .black38,
                                                      size: AppText.p1(context),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const Gap(15),
                                              Text(
                                                '${categorie.events[index].dislike}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      appColorProvider.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              LikeButton(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                size:
                                                    Device.getDiviseScreenWidth(
                                                        context, 27),
                                                // ignore: prefer_const_constructors
                                                circleColor: CircleColor(
                                                    start: const Color.fromARGB(
                                                        255, 255, 0, 157),
                                                    end: const Color.fromARGB(
                                                        255, 204, 0, 61)),
                                                bubblesColor:
                                                    const BubblesColor(
                                                  dotPrimaryColor:
                                                      Color.fromARGB(
                                                          255, 229, 51, 205),
                                                  dotSecondaryColor:
                                                      Color.fromARGB(
                                                          255, 204, 0, 95),
                                                ),
                                                isLiked: categorie
                                                    .events[index].isFavoris,
                                                onTap: ((isLiked) async {
                                                  categorie.events[index]
                                                          .isFavoris =
                                                      !categorie.events[index]
                                                          .isFavoris;
                                                  // addLike(categorie
                                                  //     .events[index]);
                                                  Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {});
                                                  });
                                                  return await isLiked;
                                                }),

                                                likeBuilder: (bool isLiked) {
                                                  categorie.events[index]
                                                      .isFavoris = isLiked;
                                                  return Center(
                                                    child: Icon(
                                                      LineIcons.heart,
                                                      color: categorie
                                                              .events[index]
                                                              .isFavoris
                                                          ? Colors.red
                                                          : appColorProvider
                                                              .black38,
                                                      size: AppText.p1(context),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const Gap(15),
                                              Text(
                                                '${categorie.events[index].favoris}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      appColorProvider.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              LikeButton(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                size:
                                                    Device.getDiviseScreenWidth(
                                                        context, 27),
                                                // ignore: prefer_const_constructors
                                                circleColor: CircleColor(
                                                    start: Color.fromARGB(
                                                        255, 0, 255, 255),
                                                    end: Color.fromARGB(
                                                        255, 0, 204, 109)),
                                                bubblesColor:
                                                    const BubblesColor(
                                                  dotPrimaryColor:
                                                      Color.fromARGB(
                                                          255, 2, 172, 67),
                                                  dotSecondaryColor:
                                                      Color.fromARGB(
                                                          255, 2, 116, 49),
                                                ),
                                                isLiked: categorie
                                                    .events[index].isShare,
                                                onTap: ((isLiked) async {
                                                  categorie.events[index]
                                                          .isShare =
                                                      !categorie.events[index]
                                                          .isShare;
                                                  addLike(
                                                      categorie.events[index]);
                                                  Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {});
                                                  });
                                                  return await isLiked;
                                                }),
                                                likeBuilder: (bool isLiked) {
                                                  categorie.events[index]
                                                      .isShare = isLiked;
                                                  return Center(
                                                    child: Icon(
                                                      Icons.share,
                                                      color: categorie
                                                              .events[index]
                                                              .isShare
                                                          ? Colors.green
                                                          : appColorProvider
                                                              .black38,
                                                      size: AppText.p1(context),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const Gap(15),
                                              Text(
                                                '${categorie.events[index].share}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      appColorProvider.black87,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Gap(5),
                                    Text(
                                      categorie.events[index].titre
                                          .toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: appColorProvider.black,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Gap(3),
                                    Text(
                                      categorie.events[index].description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          color: appColorProvider.black87,
                                          fontSize: AppText.p4(context),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const Gap(5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Publié le ${DateConvertisseur().convertirDateFromApI(categorie.events[index].created_at)}",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.black45,
                                              fontSize: AppText.p6(context),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                );
              }),
        ),
      );
    });
  }
}
