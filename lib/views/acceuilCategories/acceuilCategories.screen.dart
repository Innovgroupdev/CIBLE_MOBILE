import 'dart:math';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
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

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: Device.getDiviseScreenHeight(context, 12),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 10, left: 25, right: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemExtent: Device.getDiviseScreenWidth(context, 5),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // height: Device.getDiviseScreenHeight(context, 14),
                  // width: Device.getDiviseScreenHeight(context, 13),
                  decoration: BoxDecoration(
                    color: appColorProvider.categoriesColor(index),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Provider.of<AppManagerProvider>(context, listen: false)
                            .categoriesIcon(index),
                        color: appColorProvider.white,
                        size: AppText.p1(context),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text(
                        categories[index].titre,
                        style: GoogleFonts.poppins(
                            color: appColorProvider.white,
                            fontSize: AppText.p6(context),
                            fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 22, left: 30, right: 15),
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
                                  color: appColorProvider.primaryColor2,
                                  fontSize: AppText.p4(context),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: Device.getDiviseScreenHeight(context, 3.35),
                        child: Expanded(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  EdgeInsets.only(top: 10, left: 25, right: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: categories[index].events.length,
                              itemExtent:
                                  Device.getDiviseScreenWidth(context, 3),
                              itemBuilder: (context, index1) {
                                int lent = categories[index]
                                    .events[index1]
                                    .titre
                                    .length;
                                int lentAuteur = categories[index]
                                    .events[index1]
                                    .auteur['nom']
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
                                            tag: "Image_Profile",
                                            child:
                                                categories[index]
                                                                .events[index1]
                                                                .image ==
                                                            '' ||
                                                        categories[index]
                                                                .events[index1]
                                                                .image ==
                                                            null
                                                    ? Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100)),
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/logo_blanc.png"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                        height: Device
                                                            .getDiviseScreenWidth(
                                                                context, 4),
                                                        width: Device
                                                            .getDiviseScreenWidth(
                                                                context, 4),
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
                                                                      .circular(
                                                                          3),
                                                              child: Container(
                                                                width: Device
                                                                    .getDiviseScreenWidth(
                                                                        context,
                                                                        3),
                                                                height: Device
                                                                    .getDiviseScreenHeight(
                                                                        context,
                                                                        4.5),
                                                                color: appColorProvider
                                                                    .primaryColor3,
                                                                child:
                                                                    CachedNetworkImage(
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
                                                              ),
                                                            ),
                                                            Positioned(
                                                                right: 5,
                                                                top: 7,
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              100)),
                                                                      color: Colors
                                                                          .white),
                                                                  // ignore: prefer_const_constructors
                                                                  child: Center(
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
                                                                              20,
                                                                          // ignore: prefer_const_constructors
                                                                          circleColor: CircleColor(
                                                                              start: const Color.fromARGB(255, 255, 0, 157),
                                                                              end: const Color.fromARGB(255, 204, 0, 61)),
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
                                                                          isLiked: categories[index]
                                                                              .events[index1]
                                                                              .like,
                                                                          likeBuilder:
                                                                              (bool isLiked) {
                                                                            print(categories[index].events[index1].like);
                                                                            categories[index].events[index1].like =
                                                                                isLiked;
                                                                            return Center(
                                                                              child: Icon(
                                                                                LineIcons.heartAlt,
                                                                                color: categories[index].events[index1].like ? appColorProvider.primary : appColorProvider.black12,
                                                                                size: 15,
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
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 3.5, left: 3.5),
                                          width: Device.getDiviseScreenWidth(
                                              context, 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  lent > 23
                                                      ? categories[index]
                                                              .events[index1]
                                                              .titre
                                                              .substring(
                                                                  1, 23) +
                                                          '...'
                                                      : categories[index]
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
                                                    tag: "Image_Profile",
                                                    child: categories[index]
                                                                .events[index1]
                                                                .auteur['image'] ==
                                                            ''
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
                                                            height: 25,
                                                            width: 25,
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                imageUrl: categories[
                                                                        index]
                                                                    .events[
                                                                        index1]
                                                                    .auteur['image'],
                                                                height: 25,
                                                                width: 25),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    lentAuteur > 20
                                                        ? categories[index]
                                                                .events[index1]
                                                                .auteur['nom']
                                                                .substring(
                                                                    1, 20)
                                                                .toUpperCase() +
                                                            '...'
                                                        : categories[index]
                                                            .events[index1]
                                                            .auteur['nom']
                                                            .toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                        color: appColorProvider
                                                            .black45,
                                                        fontSize:
                                                            AppText.p6(context),
                                                        fontWeight:
                                                            FontWeight.w400),
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
                      ),
                    ],
                  );
                }),
          ),
        ],
      );
    });
  }
}
