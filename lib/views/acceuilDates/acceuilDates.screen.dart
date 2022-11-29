import 'dart:math';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/views/acceuilDates/acceuilDates.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../core/routes.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class Dates extends StatefulWidget {
  const Dates({Key? key}) : super(key: key);

  @override
  State<Dates> createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
              padding: EdgeInsets.only(
                left: Device.getDiviseScreenWidth(context, 30),
              ),
              height: Device.getDiviseScreenHeight(context, 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: appColorProvider.primary,
                    selectedTextColor: Colors.white,
                    dateTextStyle: GoogleFonts.poppins(
                        color: appColorProvider.black,
                        fontSize: AppText.titre4(context),
                        fontWeight: FontWeight.w800),
                    dayTextStyle: GoogleFonts.poppins(
                        color: appColorProvider.black45,
                        fontSize: AppText.p5(context),
                        fontWeight: FontWeight.w500),
                    monthTextStyle: GoogleFonts.poppins(
                        color: appColorProvider.black45,
                        fontSize: AppText.p6(context),
                        fontWeight: FontWeight.w500),
                    deactivatedColor: appColorProvider.black12,
                    locale: 'fr',
                    height: Device.getDiviseScreenHeight(context, 10),
                    width: Device.getDiviseScreenWidth(context, 6.5),
                    inactiveDates: [
                      DateTime.now().add(Duration(days: 3)),
                      DateTime.now().add(Duration(days: 4)),
                      DateTime.now().add(Duration(days: 7))
                    ],
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        _selectedValue = date;
                        print(_selectedValue);
                      });
                    },
                  ),
                ],
              )),
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
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
                            categories[index].titre,
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
                    Container(
                      // constraints: BoxConstraints.expand(
                      //     height: Device.getDiviseScreenHeight(context, 3.1)),
                      // height: Device.getDiviseScreenHeight(context, 3.1),
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: Device.getDiviseScreenHeight(context, 90),
                              left: Device.getDiviseScreenWidth(context, 30),
                              right: Device.getDiviseScreenWidth(context, 30)),
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          itemCount: categories[index].events.length,
                          // itemExtent: Device.getDiviseScreenWidth(context, 3),
                          itemBuilder: (context, index1) {
                            int lent =
                                categories[index].events[index1].titre.length;
                            int lentAuteur = categories[index]
                                .events[index1]
                                .auteur
                                .nom
                                .length;
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
                                    children: [
                                      Hero(
                                        tag: "Image_Event$index$index1",
                                        child:
                                            categories[index]
                                                    .events[index1]
                                                    .image
                                                    .isEmpty
                                                ? Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100)),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/logo_blanc.png"),
                                                              fit: BoxFit.cover,
                                                            )),
                                                    width: Device
                                                        .getDiviseScreenWidth(
                                                            context, 3.5),
                                                    height: Device
                                                        .getDiviseScreenHeight(
                                                            context, 7),
                                                  )
                                                : InkWell(
                                                    onDoubleTap: (() {
                                                      Likecontroller
                                                          .currentState!
                                                          .onTap();
                                                    }),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          child: Container(
                                                            width: Device
                                                                .getDiviseScreenWidth(
                                                                    context,
                                                                    3.5),
                                                            height: Device
                                                                .getDiviseScreenHeight(
                                                                    context, 7),
                                                            color: appColorProvider
                                                                .primaryColor3,
                                                            child: Stack(
                                                              children: [
                                                                CachedNetworkImage(
                                                                  width: Device
                                                                      .getDiviseScreenWidth(
                                                                          context,
                                                                          3.5),
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          7),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              const CircularProgressIndicator()),
                                                                  imageUrl: categories[
                                                                          index]
                                                                      .events[
                                                                          index1]
                                                                      .image,
                                                                ),
                                                                ClipRect(
                                                                  child:
                                                                      BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            3.0,
                                                                        sigmaY:
                                                                            3.0),
                                                                    child:
                                                                        Container(
                                                                      width: Device.getDiviseScreenWidth(
                                                                          context,
                                                                          3.5),
                                                                      height: Device
                                                                          .getDiviseScreenHeight(
                                                                              context,
                                                                              7),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300
                                                                              .withOpacity(0.5)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Center(
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                const CircularProgressIndicator()),
                                                                    imageUrl: categories[
                                                                            index]
                                                                        .events[
                                                                            index1]
                                                                        .image,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                            right: Device
                                                                .getDiviseScreenWidth(
                                                                    context,
                                                                    100),
                                                            top: Device
                                                                .getDiviseScreenWidth(
                                                                    context,
                                                                    100),
                                                            child: Container(
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
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              100)),
                                                                  color: Colors
                                                                      .white),
                                                              // ignore: prefer_const_constructors
                                                              child: Center(
                                                                // ignore: prefer_const_constructors
                                                                child: Stack(
                                                                  children: [
                                                                    LikeButton(
                                                                      key:
                                                                          Likecontroller,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      size: Device.getDiviseScreenWidth(
                                                                          context,
                                                                          27),
                                                                      // ignore: prefer_const_constructors
                                                                      circleColor: CircleColor(
                                                                          start: const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              0,
                                                                              157),
                                                                          end: const Color.fromARGB(
                                                                              255,
                                                                              204,
                                                                              0,
                                                                              61)),
                                                                      bubblesColor:
                                                                          const BubblesColor(
                                                                        dotPrimaryColor: Color.fromARGB(
                                                                            255,
                                                                            229,
                                                                            51,
                                                                            205),
                                                                        dotSecondaryColor: Color.fromARGB(
                                                                            255,
                                                                            204,
                                                                            0,
                                                                            95),
                                                                      ),
                                                                      isLiked: categories[
                                                                              index]
                                                                          .events[
                                                                              index1]
                                                                          .isLike,
                                                                      likeBuilder:
                                                                          (bool
                                                                              isLiked) {
                                                                        categories[index]
                                                                            .events[index1]
                                                                            .isLike = isLiked;
                                                                        return Center(
                                                                          child:
                                                                              Icon(
                                                                            LineIcons.heartAlt,
                                                                            color: categories[index].events[index1].isLike
                                                                                ? appColorProvider.primary
                                                                                : Colors.black12,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    //  Icon(
                                                                    //     size: 15,
                                                                    //     LineIcons
                                                                    //         .heartAlt,
                                                                    //     color: categories[index]
                                                                    //             .events[
                                                                    //                 index1]
                                                                    //             .like
                                                                    //         ? appColorProvider
                                                                    //             .primary
                                                                    //         : appColorProvider
                                                                    //             .black12),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: Device.getDiviseScreenHeight(
                                                context, 90),
                                            left: Device.getDiviseScreenWidth(
                                                context, 50)),
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
                                                  left: Device
                                                      .getDiviseScreenWidth(
                                                          context, 90)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    categories[index]
                                                        .events[index1]
                                                        .titre,
                                                    style: GoogleFonts.poppins(
                                                        color: appColorProvider
                                                            .black87,
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                      height: Device
                                                          .getDiviseScreenHeight(
                                                              context, 200)),
                                                  Container(
                                                    width: Device
                                                        .getDiviseScreenWidth(
                                                            context, 1.8),
                                                    height: Device
                                                        .getDiviseScreenHeight(
                                                            context, 20),
                                                    child: Text(
                                                      "Il n’est pas toujours facile de trouver les mots justes quand on s’aperçoit que son enfant souffre de problèmes de santé mentale.Voici quelques exemples de ce que les parents disent généralement aux jeunes, et les mots que ceux-ci préféreraient entendre",
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
                                                  SizedBox(
                                                      height: Device
                                                          .getDiviseScreenHeight(
                                                              context, 200)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3.5,
                                            ),
                                            Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.end,
                                              children: [
                                                Hero(
                                                  tag:
                                                      "Image_auteur$index$index1",
                                                  child: categories[index]
                                                              .events[index1]
                                                              .auteur
                                                              .image ==
                                                          ''
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
                                                          child: CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              imageUrl:
                                                                  categories[
                                                                          index]
                                                                      .events[
                                                                          index1]
                                                                      .auteur
                                                                      .image,
                                                              height: Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      35),
                                                              width: Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      35)),
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
                                                    categories[index]
                                                        .events[index1]
                                                        .auteur
                                                        .nom
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
                                      ),
                                    ],
                                  ),
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
