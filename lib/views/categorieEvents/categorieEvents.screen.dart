import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cible/constants/api.dart';
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
      var event = Event1.fromMap(element);

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
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54),
          ),
        ),
        body: Container(
          color: appColorProvider.defaultBg,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: categorie.events.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                                height:
                                    Device.getDiviseScreenHeight(context, 2.4),
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
                                        width: Device.getDiviseScreenWidth(
                                            context, 1),
                                        height: Device.getDiviseScreenHeight(
                                            context, 2.4),
                                        color: appColorProvider.primaryColor3,
                                        child: Stack(
                                          children: [
                                            Image.memory(
                                                width:
                                                    Device.getDiviseScreenWidth(
                                                        context, 1),
                                                height: Device
                                                    .getDiviseScreenHeight(
                                                        context, 2.4),
                                                base64Decode(categorie
                                                    .events[index].image),
                                                fit: BoxFit.cover),
                                            ClipRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 4.0, sigmaY: 4.0),
                                                child: Container(
                                                  width: Device
                                                      .getDiviseScreenWidth(
                                                          context, 1),
                                                  height: Device
                                                      .getDiviseScreenHeight(
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
                        Positioned(
                          top: Device.getDiviseScreenHeight(context, 2.7),
                          left: (Device.getDiviseScreenWidth(context, 1) -
                                  Device.getDiviseScreenWidth(context, 1.07)) /
                              2,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: Device.getDiviseScreenHeight(context, 100),
                                bottom:
                                    Device.getDiviseScreenHeight(context, 100),
                                left: Device.getDiviseScreenWidth(context, 20),
                                right:
                                    Device.getDiviseScreenWidth(context, 20)),
                            width: Device.getDiviseScreenWidth(context, 1.07),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categorie.events[index].titre
                                            .toUpperCase(),
                                        style: GoogleFonts.poppins(
                                            color: appColorProvider.black,
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: 'Organisateur : ',
                                          style: GoogleFonts.poppins(
                                            color: appColorProvider.black87,
                                            fontSize: AppText.p5(context),
                                          ),
                                          children: [
                                            TextSpan(
                                                text: categorie
                                                    .events[index].titre,
                                                style: TextStyle(
                                                    color: appColorProvider
                                                        .primaryColor))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        "AFFICHER PLUS",
                                        style: GoogleFonts.poppins(
                                            color:
                                                appColorProvider.primaryColor1,
                                            fontSize: AppText.p4(context),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }
}
