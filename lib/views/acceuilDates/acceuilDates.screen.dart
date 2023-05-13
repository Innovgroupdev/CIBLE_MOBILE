import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.controller.dart';
import 'package:cible/views/acceuilDates/acceuilDates.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../core/routes.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../../models/categorie.dart';
import '../accueilFavoris/acceuilFavoris.controller.dart';

class Dates extends StatefulWidget {
  Dates({required this.countryLibelle,Key? key}) : super(key: key);
  String countryLibelle;
  @override
  State<Dates> createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  var _selectedValue;
  DateTime currentDate = DateTime.now();
  List? eventsByDate;
  List<DateTime> allEventDate = [];
  List favorisId = [];
  List<Event1>? listFavoris;
  var token;
  bool? etat;

  @override
  void initState() {
    getEventsByDate();
    getFavorisFromAPI();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


   getEventsByDate() async {
    etat = await SharedPreferencesHelper.getBoolValue("logged") ;
    print('etaaaaaaaaaaaaaat'+etat.toString());
    token = await SharedPreferencesHelper.getValue('token');
    print('token'+token);
    var response = 
    etat! ?
    await http.get(
      Uri.parse('$baseApiUrl/eventsperdate'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ):
    await http.get(
      Uri.parse('$baseApiUrl/evenements/evenements_par_date/${widget.countryLibelle}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    )
    ;
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        eventsByDate =
            getDateFromMap(jsonDecode(response.body)['data'] as List);
      });
      return eventsByDate;
    }
  }

     getEventsforADate(date) async {
      etat = await SharedPreferencesHelper.getBoolValue("logged") ;
    print('etaaaaaaaaaaaaaat'+etat.toString());
    token = await SharedPreferencesHelper.getValue('token');
    print('token'+token);
    var response = 
    etat!?
    await http.get(
      Uri.parse('$baseApiUrl/events/getevtnsofdate/$date'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ):
    await http.get(
      Uri.parse('$baseApiUrl/events/${widget.countryLibelle}/$date'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    )
    ;
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        eventsByDate =
            getDateFromMap([jsonDecode(response.body)['data']]);
            currentDate = DateTime.parse(date);
      });
    print('wouuuuuu'+eventsByDate.toString());
      return eventsByDate;
    }
  }

    getFavorisFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    
    var response = 
    
    await http.get(
      
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
      setState(() {
        listFavoris =
            getEventFromMap(jsonDecode(response.body)['data'] as List,{});
            for(var favoris in listFavoris!){
              favorisId.add(favoris.id);
            }
            print('favoris id'+favorisId.toString());
            
      });
    }
  }

    getDateFromMap(List dateListFromAPI) {
    final List tagObjs = [];
    for (var element in dateListFromAPI) {
      if(element['libelle'] != null){
      allEventDate.add(DateTime.parse(element['libelle']));
      }
     
      var date = 
      {
        'libelle':element['libelle']??element['date'],
        'events':getEventFromMap(element['events'] ?? [], {}),
      };
      List<Event1> events = date['events'];
      if (events.isNotEmpty ) {
        
      
        tagObjs.add(date);
      }
    }
    
  print('zsssssssssssssssssssss'+allEventDate.toString());
    return tagObjs;
  }

  // getEventsByDate(date) async {
  //   token = await SharedPreferencesHelper.getValue('token');
  //   print('the date for tri'+date.toString());
  //   var response = await http.get(
  //     Uri.parse('$baseApiUrl/events/eventsfordate/$date'),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   print(response.statusCode);
  //   //print(jsonDecode(response.body));
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     // eventsList = jsonDecode(response.body)['events'];
  //     setState(() {
  //       eventsByDate = jsonDecode(response.body)['data'] as List;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return  Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
            return eventsByDate == null
        ? const Center(child: CircularProgressIndicator()):
            ListView(
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
                        Expanded(
                          child: DatePicker(
                            DateTime.now(),
                            initialSelectedDate: currentDate,
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
                            activeDates:
                              allEventDate,
                            // inactiveDates: 
                             //[
                              //allEventDate,
                            //   DateTime.now().add(Duration(days: 3)),
                            //   DateTime.now().add(Duration(days: 4)),
                            //   DateTime.now().add(Duration(days: 7))
                            // ],
                            onDateChange: (date){
                              // New date selected
                              eventsByDate = null;
                              var finalDate = date.toString().split(' ');
                               getEventsforADate(finalDate[0]);
                              setState(() {
                                _selectedValue = date;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                    eventsByDate == null
        ? const Center(child: CircularProgressIndicator())
        : eventsByDate!.isEmpty?
        Center(child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: 350,
              width: 350,
                      child: Image.asset('assets/images/empty.png'),
                    ),
             const Text(
                            'Pas d\'évènements',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.primary,
                            ),
                          ),
          ],
        ),)
        :
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventsByDate!.length,
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
                                  eventsByDate![index]['libelle'],
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.black,
                                      fontSize: AppText.p2(context),
                                      fontWeight: FontWeight.w700),
                                ),
                                // Text(
                                //   "AFFICHER PLUS",
                                //   style: GoogleFonts.poppins(
                                //       color: appColorProvider.primaryColor1,
                                //       fontSize: AppText.p4(context),
                                //       fontWeight: FontWeight.w500),
                                // ),
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
                                    top: Device.getDiviseScreenHeight(
                                        context, 90),
                                    left: Device.getDiviseScreenWidth(
                                        context, 30),
                                    right: Device.getDiviseScreenWidth(
                                        context, 30)),
                                shrinkWrap: true,
                                // scrollDirection: Axis.horizontal,
                                itemCount: eventsByDate![index]['events'].length,
                                // itemExtent: Device.getDiviseScreenWidth(context, 3),
                                itemBuilder: (context, index1) {
                                  int lent = eventsByDate![index]
                                      ['events'][index1]
                                      .titre
                                      .length;
                                  // int lentAuteur = eventsByDate![index]
                                  //     ['events'][index1]
                                  //     .auteur
                                  //     .nom
                                  //     .length;
                                  final Likecontroller =
                                      GlobalKey<LikeButtonState>();

                                  // print(categories[index]
                                  //     .events[index1]
                                  //     .getEventFirstDate());
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<AppManagerProvider>(context,
                                              listen: false)
                                          .currentEventIndex = index1;
                                      Navigator.pushNamed(
                                          context, '/eventDetails', arguments: {
                                        "event":
                                            eventsByDate![index]['events'][index1]
                                      });
                                    },
                                    child: ClipRRect(
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
                                            children: [
                                              Hero(
                                                tag: "Image_Event$index$index1",
                                                child:
                                                    eventsByDate![index]
                                                            ['events'][index1]
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
                                                                    context, 7),
                                                          )
                                                        : InkWell(
                                                            onDoubleTap: (() {
                                                              Likecontroller
                                                                  .currentState!
                                                                  .onTap();
                                                            }),
                                                            onTap: () {
                                                              Provider.of<AppManagerProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .currentEventIndex = index1;
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/eventDetails',
                                                                  arguments: {
                                                                    "event": eventsByDate![
                                                                            index]
                                                                        ['events'][index1]
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
                                                                              // categories![index]
                                                                              // .events[index1]
                                                                              // .image,
                                                                          eventsByDate![index]
                                                                              ['events'][index1]
                                                                              .image,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                              
                                                                          width: Device.getDiviseScreenWidth(
                                                                              context,
                                                                              3.5),
                                                                          height: Device.getDiviseScreenHeight(
                                                                              context,
                                                                              7),
                                                                        ),
                                                                        ClipRect(
                                                                          child:
                                                                              BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                                                            child:
                                                                                Container(
                                                                              width: Device.getDiviseScreenWidth(context, 3.5),
                                                                              height: Device.getDiviseScreenHeight(context, 7),
                                                                              decoration: BoxDecoration(color: Colors.black45.withOpacity(.3)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child: Image.network(
                                                                            //categories![index].events[index1].image,
                                                                            eventsByDate![index]['events'][index1].image,
                                                                              fit: BoxFit.fitWidth),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                !etat!?
                                                              const SizedBox():
                                                                Positioned(
                                                                    right: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            100),
                                                                    top: Device
                                                                        .getDiviseScreenWidth(
                                                                            context,
                                                                            100),
                                                                    child:
                                                                        Container(
                                                                      height: Device.getDiviseScreenWidth(
                                                                          context,
                                                                          20),
                                                                      width: Device.getDiviseScreenWidth(
                                                                          context,
                                                                          20),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              100)),
                                                                          color:
                                                                              Colors.white),
                                                                      // ignore: prefer_const_constructors
                                                                      child:
                                                                          Center(
                                                                        // ignore: prefer_const_constructors
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            LikeButton(
onTap: (isLiked) async{

                                                            var isLike;
                                                            print('dddddddddddddd1'+eventsByDate![index]['events'][index1]
                                                                    .isLike.toString());
                                                            
                                                            eventsByDate![index]['events'][index1]
                                                                    .isLike =
                                                                !eventsByDate![index]['events'][index1]
                                                                    .isLike;
                                                                    print('dddddddddddddd2'+eventsByDate![index]['events'][index1]
                                                                    .isLike.toString());
                                                            UserDBcontroller()
                                                                .liste()
                                                                .then(
                                                                    (value) async {
                                                              if (eventsByDate![index]['events'][index1]
                                                                  .isLike) {
                                                                print(eventsByDate![index]['events'][index1]
                                                                    .favoris);
                                                                eventsByDate![index]['events'][index1]
                                                                    .setFavoris(
                                                                        eventsByDate![index]['events'][index1].favoris +
                                                                            1);
                                                                print(eventsByDate![index]['events'][index1]
                                                                    .favoris);

                                                                       isLike =  await addFavoris(eventsByDate![index]['events'][index1].id);
                                                                        setState(() {
                                                                          favorisId.add(eventsByDate![index]['events'][index1].id);
                                                                        });
                                                              } else {
                                                                print(eventsByDate![index]['events'][index1]
                                                                    .favoris);
                                                                eventsByDate![index]['events'][index1]
                                                                    .setFavoris(
                                                                        eventsByDate![index]['events'][index1].favoris -
                                                                            1);
                                                                print(eventsByDate![index]['events'][index1]
                                                                    .favoris);
                                                                isLike = await removeFavoris(eventsByDate![index]['events'][index1].id);
                                                                        setState(() {
                                                                          favorisId.remove(eventsByDate![index]['events'][index1].id);
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
                                                                              isLiked: eventsByDate![index]['events'][index1].isLike,
                                                                              likeBuilder: (bool isLiked) {
                                                                                eventsByDate![index]['events'][index1].isLike = isLiked;
                                                                                if(favorisId.contains(eventsByDate![index]['events'][index1].id)){
                                                              eventsByDate![index]['events'][index1]
                                                                    .isLike = true;
                                                            }
                                                                                return Center(
                                                                                  child: Icon(
                                                                                    LineIcons.heartAlt,
                                                                                    color: favorisId.contains(eventsByDate![index]['events'][index1].id) || eventsByDate![index]['events'][index1].isLike
                                                                                    ?
                                                                                     appColorProvider.primary : Colors.black12,
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
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: Device
                                                        .getDiviseScreenHeight(
                                                            context, 90),
                                                    left: Device
                                                        .getDiviseScreenWidth(
                                                            context, 50)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            eventsByDate![index]
                                                                ['events'][index1]
                                                                .titre,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.poppins(
                                                                color:
                                                                    appColorProvider
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
                                                              eventsByDate![index]
                                                                  ['events'][
                                                                      index1]
                                                                  .description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
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
                                                          SizedBox(
                                                            height: Device
                                                                .getDiviseScreenHeight(
                                                                    context,
                                                                    200),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 3.5,
                                                    // ),
                                                    Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.end,
                                                      children: [
                                                        Hero(
                                                          tag:
                                                              "Image_auteur$index$index1",
                                                          child: 
                                                          eventsByDate![index]
                                                                              ['events'][index1]
                                                                      .auteur
                                                                      .image == null ||
                                                          eventsByDate![index]
                                                                              ['events'][index1]
                                                                      .auteur
                                                                      .image ==
                                                                  ''
                                                              ? Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              100)),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/logo_blanc.png"),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                  height: Device
                                                                      .getDiviseScreenHeight(
                                                                          context,
                                                                          50),
                                                                  width: 25,
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image.network(
                                                                    eventsByDate![index]
                                                                              ['events'][index1]
                                                                      .auteur
                                                                      .image,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height: Device.getDiviseScreenHeight(
                                                                          context,
                                                                          35),
                                                                      width: Device.getDiviseScreenHeight(
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
                                                                      context,
                                                                      100)),
                                                          child: Text(
                                                            // eventsByDate![index]
                                                            //     ['events'][index1]
                                                            //     .auteur
                                                            //     .nom
                                                            eventsByDate![index]
                                                                              ['events'][index1]
                                                                  .auteur.raisonSociale
                                                                .toUpperCase(),
                                                            style: GoogleFonts.poppins(
                                                                color:
                                                                    appColorProvider
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
                                            ],
                                          ),
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
