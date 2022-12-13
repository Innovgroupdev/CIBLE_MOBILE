// ignore_for_file: unnecessary_new

import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/favorisProvider.dart';
import 'package:cible/views/detail/detail.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:like_button/like_button.dart';

class AfficherCategorie extends StatelessWidget {
  final String titre;
  final List<Event> events;
  const AfficherCategorie({
    super.key,
    required this.titre,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        backgroundColor: AppColorProvider().defaultBg,
        appBar: AppBar(
          title: Text(
            titre,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              top: Device.getDiviseScreenHeight(context, 90),
              left: Device.getDiviseScreenWidth(context, 30),
              right: Device.getDiviseScreenWidth(context, 30)),
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index1) {
            final Likecontroller = GlobalKey<LikeButtonState>();
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 70),
              height: MediaQuery.of(context).size.height / 3,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(
                          events[index1].image,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 3.5, left: 7),
                      height: 150,
                      width: 350,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    events[index1].titre,
                                    style: GoogleFonts.poppins(
                                        color: appColorProvider.black,
                                        fontSize: AppText.p3(context),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 3.5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Organisateur : ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: AppText.p3(context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        events[index1]
                                            .auteur['nom']
                                            .toUpperCase(),
                                        style: GoogleFonts.poppins(
                                            color:
                                                appColorProvider.primaryColor1,
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 3.5,
                                // ),
                                // Text(
                                //   'Rue CAIMAN, Agbalépédogan | Lomé',
                                //   style: GoogleFonts.poppins(
                                //     color: Colors.black,
                                //     fontSize: AppText.p3(context),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 3.5,
                                // ),
                                // Text(
                                //   'Mercredi 30 Mars 2021',
                                //   style: GoogleFonts.poppins(
                                //     color: Colors.black,
                                //     fontSize: AppText.p3(context),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Icon(
                                    LineIcons.thumbsUp,
                                    color: appColorProvider.grey10,
                                    size: 20,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Icon(
                                    LineIcons.thumbsDownAlt,
                                    color: appColorProvider.grey10,
                                    size: 20,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Icon(
                                    LineIcons.heart,
                                    color: appColorProvider.grey10,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
