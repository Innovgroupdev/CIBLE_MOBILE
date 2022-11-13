import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/favorisProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:math';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/favorisProvider.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../core/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:like_button/like_button.dart';

class Favoris extends StatefulWidget {
  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  @override
  Widget build(BuildContext context) {
    List<Event> favoris = Provider.of<FavorisProvider>(context).favoris;
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: Device.getDiviseScreenHeight(context, 90),
              left: Device.getDiviseScreenWidth(context, 30),
              right: Device.getDiviseScreenWidth(context, 30)),
          shrinkWrap: true,
          itemCount: favoris.length,
          itemBuilder: (context, index) {
            int lent = favoris[index].titre.length;
            int lentAuteur = favoris[index].auteur['nom'].length;
            final Likecontroller = GlobalKey<LikeButtonState>();
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Hero(
                        tag: "Image_Event$index",
                        child: favoris[index].image == '' ||
                                favoris[index].image == null
                            ? Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/logo_blanc.png"),
                                      fit: BoxFit.cover,
                                    )),
                                height: Device.getDiviseScreenWidth(context, 4),
                                width: Device.getDiviseScreenWidth(context, 4),
                              )
                            : InkWell(
                                onDoubleTap: (() {
                                  Likecontroller.currentState!.onTap();
                                  if (favoris[index].like) {
                                    Provider.of<FavorisProvider>(context,
                                            listen: false)
                                        .removeFavoris(
                                      favoris[index],
                                    );
                                  } else {
                                    Provider.of<FavorisProvider>(context,
                                            listen: false)
                                        .addFavoris(
                                      favoris[index],
                                    );
                                  }
                                }),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        width: Device.getDiviseScreenWidth(
                                            context, 3),
                                        height: Device.getDiviseScreenHeight(
                                            context, 4.4),
                                        color: appColorProvider.primaryColor3,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              width:
                                                  Device.getDiviseScreenWidth(
                                                      context, 3),
                                              height:
                                                  Device.getDiviseScreenHeight(
                                                      context, 4.5),
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              imageUrl: favoris[index].image,
                                            ),
                                            new ClipRect(
                                              child: new BackdropFilter(
                                                filter: new ImageFilter.blur(
                                                    sigmaX: 3.0, sigmaY: 3.0),
                                                child: new Container(
                                                  width: Device
                                                      .getDiviseScreenWidth(
                                                          context, 2.9),
                                                  height: Device
                                                      .getDiviseScreenHeight(
                                                          context, 4.4),
                                                  decoration: new BoxDecoration(
                                                      color: Colors
                                                          .grey.shade200
                                                          .withOpacity(0.5)),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fitWidth,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            const CircularProgressIndicator()),
                                                imageUrl: favoris[index].image,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: Device.getDiviseScreenWidth(
                                            context, 100),
                                        top: Device.getDiviseScreenWidth(
                                            context, 90),
                                        child: Container(
                                          height: Device.getDiviseScreenWidth(
                                              context, 20),
                                          width: Device.getDiviseScreenWidth(
                                              context, 20),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              color: Colors.white),
                                          // ignore: prefer_const_constructors
                                          child: Center(
                                            // ignore: prefer_const_constructors
                                            child: Stack(
                                              children: [
                                                LikeButton(
                                                  key: Likecontroller,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  size: Device
                                                      .getDiviseScreenWidth(
                                                          context, 27),
                                                  // ignore: prefer_const_constructors
                                                  circleColor: CircleColor(
                                                      start:
                                                          const Color.fromARGB(
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
                                                  isLiked: favoris[index].like,
                                                  likeBuilder: (bool isLiked) {
                                                    favoris[index].like =
                                                        isLiked;
                                                    return Center(
                                                      child: Icon(
                                                        LineIcons.heartAlt,
                                                        color: favoris[index]
                                                                .like
                                                            ? appColorProvider
                                                                .primary
                                                            : Colors.black12,
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
                      padding: EdgeInsets.only(top: 3.5, left: 3.5),
                      width: Device.getDiviseScreenWidth(context, 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: Device.getDiviseScreenWidth(context, 90)),
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              favoris[index].titre,
                              style: GoogleFonts.poppins(
                                  color: appColorProvider.black54,
                                  fontSize: AppText.p5(context),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 3.5,
                          ),
                          Row(
                            children: [
                              Hero(
                                tag: "Image_auteur$index",
                                child: favoris[index].auteur['image'] == ''
                                    ? Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo_blanc.png"),
                                              fit: BoxFit.cover,
                                            )),
                                        height: Device.getDiviseScreenHeight(
                                            context, 50),
                                        width: 25,
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageUrl: categories[index]
                                                .events[index]
                                                .auteur['image'],
                                            height:
                                                Device.getDiviseScreenHeight(
                                                    context, 35),
                                            width: Device.getDiviseScreenHeight(
                                                context, 35)),
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: Device.getDiviseScreenWidth(
                                        context, 100)),
                                child: Text(
                                  favoris[index].auteur['nom'].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.black45,
                                      fontSize: AppText.p6(context),
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
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
          });
    });
  }
}
