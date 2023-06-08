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

import '../../helpers/colorsHelper.dart';
import '../../helpers/dateHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';

class Favoris extends StatefulWidget {
  const Favoris({Key? key}) : super(key: key);

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  List<Event1>? listFavoris;
  @override
  void initState() {
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
      Uri.parse('$baseApiUrl/particular/eventfavoris'),
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
      if (mounted) {
        setState(() {
          listFavoris =
              getEventFromMap(jsonDecode(response.body)['data'] as List, {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return listFavoris == null
        ? Center(child: CircularProgressIndicator())
        : listFavoris!.isEmpty
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
                        'Pas de Favoris',
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
                  shrinkWrap: true,
                  children: [
                    listFavoris!.isEmpty
                        ? Column(
                            children: [
                              Container(
                                height:
                                    Device.getDiviseScreenHeight(context, 2),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: Device.getDiviseScreenHeight(
                                            context, 90),
                                        left: Device.getDiviseScreenWidth(
                                            context, 30),
                                        right: Device.getDiviseScreenWidth(
                                            context, 200)),
                                    shrinkWrap: true,
                                    // scrollDirection: Axis.horizontal,
                                    itemCount: listFavoris!.length,
                                    // itemExtent: Device.getDiviseScreenWidth(context, 3),
                                    itemBuilder: (context, index1) {
                                      return index1 % 2 == 0
                                          ? InkWell(
                                              onTap: () {
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: false)
                                                    .currentEventIndex = index1;
                                                Navigator.pushNamed(
                                                    context, '/eventDetails',
                                                    arguments: {
                                                      "event":
                                                          listFavoris![index1]
                                                    });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Card(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Hero(
                                                        tag:
                                                            "Image_Event$index1",
                                                        child:
                                                            listFavoris![index1]
                                                                    .image
                                                                    .isEmpty
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                              image: DecorationImage(
                                                                                image: AssetImage("assets/images/logo_blanc.png"),
                                                                                fit: BoxFit.cover,
                                                                              )),
                                                                          width: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              3.5),
                                                                          height: Device.getDiviseScreenHeight(
                                                                              context,
                                                                              6),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              appColorProvider.primaryColor3,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.network(
                                                                                //listFavoris![index1].image,
                                                                                listFavoris![index1].image,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              ClipRect(
                                                                                child: BackdropFilter(
                                                                                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: Colors.grey.shade300.withOpacity(0.5)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: Image.network(
                                                                                  //listFavoris![index1].image,
                                                                                  listFavoris![index1].image,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: Device
                                                                    .getDiviseScreenWidth(
                                                                        context,
                                                                        50)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
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
                                                                      listFavoris![
                                                                              index1]
                                                                          .titre,
                                                                      style: GoogleFonts.poppins(
                                                                          color: appColorProvider
                                                                              .black87,
                                                                          fontSize: AppText.p3(
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          200),
                                                                ),
                                                                SingleChildScrollView(
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(left: Device.getDiviseScreenWidth(context, 100)),
                                                                        child:
                                                                            Text(
                                                                          "Publié le ${DateConvertisseur().convertirDateFromApI(listFavoris![index1].created_at)}",
                                                                          style: GoogleFonts.poppins(
                                                                              color: appColorProvider.black45,
                                                                              fontSize: AppText.p4(context),
                                                                              fontWeight: FontWeight.w400),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                    }),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: Device.getDiviseScreenHeight(
                                            context, 90),
                                        right: Device.getDiviseScreenWidth(
                                            context, 30),
                                        left: Device.getDiviseScreenWidth(
                                            context, 200)),
                                    shrinkWrap: true,
                                    // scrollDirection: Axis.horizontal,
                                    itemCount: listFavoris!.length,
                                    // itemExtent: Device.getDiviseScreenWidth(context, 3),
                                    itemBuilder: (context, index1) {
                                      return index1 % 2 != 0
                                          ? InkWell(
                                              onTap: () {
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: false)
                                                    .currentEventIndex = index1;
                                                Navigator.pushNamed(
                                                    context, '/eventDetails',
                                                    arguments: {
                                                      "event":
                                                          listFavoris![index1]
                                                    });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Card(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Hero(
                                                        tag:
                                                            "Image_Event$index1",
                                                        child:
                                                            listFavoris![index1]
                                                                    .image
                                                                    .isEmpty
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                              image: DecorationImage(
                                                                                image: AssetImage("assets/images/logo_blanc.png"),
                                                                                fit: BoxFit.cover,
                                                                              )),
                                                                          width: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              3.5),
                                                                          height: Device.getDiviseScreenHeight(
                                                                              context,
                                                                              6),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              appColorProvider.primaryColor3,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.network(
                                                                                //listFavoris![index1].image,
                                                                                listFavoris![index1].image,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              ClipRect(
                                                                                child: BackdropFilter(
                                                                                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: Colors.grey.shade300.withOpacity(0.5)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: Image.network(
                                                                                  //listFavoris![index1].image,
                                                                                  listFavoris![index1].image,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: Device
                                                                    .getDiviseScreenWidth(
                                                                        context,
                                                                        50)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
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
                                                                      listFavoris![
                                                                              index1]
                                                                          .titre,
                                                                      style: GoogleFonts.poppins(
                                                                          color: appColorProvider
                                                                              .black87,
                                                                          fontSize: AppText.p3(
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          200),
                                                                ),
                                                                SingleChildScrollView(
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(left: Device.getDiviseScreenWidth(context, 100)),
                                                                        child:
                                                                            Text(
                                                                          "Publié le ${DateConvertisseur().convertirDateFromApI(listFavoris![index1].created_at)}",
                                                                          style: GoogleFonts.poppins(
                                                                              color: appColorProvider.black45,
                                                                              fontSize: AppText.p4(context),
                                                                              fontWeight: FontWeight.w400),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                    }),
                              ),
                            ],
                          ),
                  ],
                );
              });
  }
}
