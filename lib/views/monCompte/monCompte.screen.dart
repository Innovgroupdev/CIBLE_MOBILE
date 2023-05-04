import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/views/monCompte/monCompte.controller.dart';
import 'package:cible/views/monCompte/monCompte.widgets.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../database/parametreCategorieDBcontroller.dart';
import '../../database/parametreLieuDBController.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../../models/Event.dart';
import '../../models/gadget.dart';
import '../../models/ticket.dart';
import '../../widgets/eventsActifs.dart';

class MonCompte extends StatefulWidget {
  const MonCompte({Key? key}) : super(key: key);

  @override
  State<MonCompte> createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  double totalTickets = 0;
  double totalGadgets = 0;
  // int _controller.index = 0;
  final _tabKey = GlobalKey<State>();
  final oCcy = NumberFormat("#,##0.00", "fr_FR");
  var solde;
  List devises = [];
  List<Event1>? sondages;
  List<Event1>? suggestions;
  List<Event1>? eventsPassed;
  List<Event1>? eventsComing;
  List<Ticket>? eventsComingTickets;
  List<Gadget>? eventsComingGadgets;
  var countries;
  var allEventsPassed;
  var allGadgetsPassed;
  var allEventsArchived;
  var allEventsArchivedNumber;
  var allSurveyResponded;
  List parametreCategorie = [];
  List parametreLieu = [];

  @override
  void initState() {
    // _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    Provider.of<AppManagerProvider>(context, listen: false)
        .initprofilTabController(this);

    super.initState();
    getUserEventsSuggestionsFromAPI();
    getAllEventUserPassFromAPI();
    getAllGadgetsUserPassFromAPI();
    getPassedEventsFromAPI();
    getComingEventsFromAPI();
    getCountryAvailableOnAPi();
    getAllSurveyRespondedFromAPI();
    getAllEventsArchivedNumberFromAPI();
    getAllEventsArchivedUserFromAPI();
    getUserInfo();
    getActionsUser();
  }

  getAllEventUserPassFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/events/totalparticipated'),
      /*surveys/users/active*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        allEventsPassed = jsonDecode(response.body)['total'];
        print('allEventsPasseddddd' + allEventsPassed.toString());
      });
      return allEventsPassed;
    }
  }

  getAllSurveyRespondedFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/surveys/users/count'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        allSurveyResponded = jsonDecode(response.body)['data']['count'];
      });
      print('allSurveyRespondeddddddddd'+allSurveyResponded.toString());
      return allSurveyResponded;
    }
  }

  getAllEventsArchivedNumberFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/userpart/events/numberofarchivedEvents'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        allEventsArchivedNumber = jsonDecode(response.body)['data'];
      });
      return allEventsArchivedNumber;
    }
  }

  getAllGadgetsUserPassFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/gadgetspurchased'),
      /*surveys/users/active*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print('Amennnnnnnnnn' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        allGadgetsPassed = jsonDecode(response.body)['data'];
        print('allGadgetsPassedddddddd' + allGadgetsPassed.toString());
      });
      return allGadgetsPassed;
    }
  }

  getAllEventsArchivedUserFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/surveys/users/active'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {

        
            print('sondagessssssssss1' + jsonDecode(response.body)['data'].toString());
        sondages =
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
      });
      return sondages;
    }
  }

  getUserEventsSuggestionsFromAPI() async {
    await ParametreCategorieDBcontroller().liste().then((value) {
      
      if(value.isEmpty){
        suggestions = [];
        return suggestions;
      }
      print('zzzzzzzzzzzzz1'+value.toString());
      setState(() {
        value.forEach((element) {
          parametreCategorie.add(element['id_categorie']);
        });
      });
      print('zzzzzzzzzzzzz2'+parametreCategorie.toString());
    });

    await ParametreLieuDBcontroller().liste().then((value) {
      
      if(value.isEmpty){
        suggestions = [];
        return suggestions;
      }
      print('zzzzzzzzzzzzz3'+value.toString());
      setState(() {
        value.forEach((element) {
          parametreLieu.add(element['ville']);
        });
      });
      print('zzzzzzzzzzzzz4'+parametreLieu.toString());
    });

    //print('modellllllll1'+ parametreLieu.toString() + parametreCategorie.toString());
    var token = await SharedPreferencesHelper.getValue('token');
    Map<String, dynamic> data = {'categorie_ids': parametreCategorie, 'citie_names': parametreLieu};
    var response = await http.post(
      Uri.parse('$baseApiUrl/events/filter'), //$parametreCategorie/$parametreLieu
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data)
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      print('zzzzzzzzzzzzz5');
      setState(() {
        suggestions =
        jsonDecode(response.body)['data'] == []?
        []:
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
        print('modellllllll2' + suggestions.toString());
      });
      return suggestions;
    }
  }

  getPassedEventsFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/userpart/events/past'),
      /*surveys/users/active*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
            print('eventsPasseddddddddddd' + jsonDecode(response.body)['data'].toString());
        eventsPassed =
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
      });
      return eventsPassed;
    }
  }

  getComingEventsFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/userpart/events/upcomingevents'),
      //Uri.parse('$baseApiUrl/particular/eventfavoris'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        eventsComing =
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
            print('eventsCominggggggg' + eventsComing.toString());
      });
      return eventsComing;
    }
  }

  List<Event1> getEventFromMap(eventsListFromAPI, map) {
    var madDecode = jsonDecode(jsonEncode(eventsListFromAPI));

    final List<Event1> tagObjs = [];
    for (var element in madDecode) {
      var event = Event1.fromMap(
          element['event'] ?? element['evenement'] ?? element /*, map*/);
      for (var element1 in element['tickets'] as List) {
        if (element1['details'] != null) {
          var ticket = Ticket.fromMap(element1['details'],{});

          ticket.nombrePaye = element1['quantity'];
          event.ticketsPayes.add(ticket);
        }
      }
      if (element['gadgets'] != null) {
        for (var element1 in element['gadgets'] as List) {
          // if(element1['details'] != null){
          var gadget = Gadget.fromMap(/*element1['details']*/
              {
            'gadget': {
              'id': element1['gadget']['id'],
              'libelle': element1['gadget']['libelle']
            },
            'evenement': {'id': element['evenement']['id']},
            'models': element1['modelesData']
          });
          event.gadgetsPayes.add(gadget);
          //  }
        }
      }

      tagObjs.add(event);
    }
    return tagObjs;
  }

  Future getCountryAvailableOnAPi() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/pays'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      print('solddeeeeeeeeeee' +
          Provider.of<DefaultUserProvider>(context, listen: false)
              .paysId
              .toString());
      if (responseBody['data'] != null) {
        countries = responseBody['data'] as List;
      }
      for (var countrie in countries) {
        if (countrie['id'] ==
            Provider.of<DefaultUserProvider>(context, listen: false).paysId) {
          setState(() {
            devises = [countrie['devise']];
            print('devisessssss' + devises.toString());
          });
        }
      }
    }
  }

  getUserInfo() async {
    var response;
    var token = await SharedPreferencesHelper.getValue('token');
    response = await http.get(
      Uri.parse('$baseApiUrl/auth/particular/sold'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body) as Map;
      if (responseBody['user'] != null) {
        setState(() {
          solde = double.parse(responseBody['montant']);
          print('soldeeeeeee' + solde.toString());
        });

        return responseBody;
      }
    } else {
      return false;
    }
  }

  getActionsUser() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    // print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['actions'] != null) {
        setState(() {
          actions = remplieActionListe(responseBody['actions'] as List);
        });
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
          backgroundColor: appColorProvider.defaultBg,
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
              "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p2(context),
                  fontWeight: FontWeight.bold,
                  color: appColorProvider.black54),
            ),
          ),
          body: Container(
            color: appColorProvider.defaultBg,
            child: 
            
           sondages == null 
            ||
                   suggestions == null ||
                   solde == null ||
                    devises.isEmpty 
                    ||
                    eventsComing == null ||
                    eventsPassed == null ||
                    allEventsPassed == null ||
                    allGadgetsPassed == null ||
                    allEventsArchivedNumber == null ||
                    allSurveyResponded == null
                 ? const Center(child: CircularProgressIndicator())
                : 
                ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Device.getDiviseScreenWidth(context, 30),
                    ),
                    children: [
                      Card(
                        color: appColorProvider.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenHeight(context, 50)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Center(
                                    child: Hero(
                                      tag: 'Image_Profile',
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Badge(
                                          toAnimate: true,
                                          badgeColor:
                                              Color.fromARGB(255, 93, 255, 28),
                                          shape: BadgeShape.circle,
                                          position: BadgePosition(
                                              bottom: 15, end: 15),
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              height: 80,
                                              width: 80,
                                              child: photoProfil(
                                                  context,
                                                  appColorProvider
                                                      .primaryColor4,
                                                  100)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Provider.of<AppColorProvider>(
                                                        context,
                                                        listen: false)
                                                    .black54),
                                      ),
                                      // Text(
                                      //   "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                                      //   textAlign: TextAlign.center,
                                      //   style: GoogleFonts.poppins(
                                      //       textStyle: Theme.of(context).textTheme.bodyLarge,
                                      //       fontSize: AppText.p4(context),
                                      //       fontWeight: FontWeight.w400,
                                      //       color: Provider.of<AppColorProvider>(context,
                                      //               listen: false)
                                      //           .black38),
                                      // ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "solde | ",
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w400,
                                                  color: Provider.of<
                                                              AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black38),
                                            ),
                                            TextSpan(
                                              text: "$solde ${devises[0]}",
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.bold,
                                                  color: Provider.of<
                                                              AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .primary),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              //const Divider(thickness: 1,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "100 SANA",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .primary),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            // Navigator.pushNamed(
                                            //     context, '/modifiecompte');
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            side: BorderSide(
                                                width: 0.7,
                                                color:
                                                    appColorProvider.black26),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(LineIcons.pen,
                                                //     color: appColorProvider.black87,
                                                //     size: AppText.p5(context)),
                                                // SizedBox(width: 5),
                                                Text(
                                                  'Convertir',
                                                  //"Modifier mon compte",
                                                  style: GoogleFonts.poppins(
                                                      color: appColorProvider
                                                          .black87,
                                                      fontSize:
                                                          AppText.p5(context)),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "$solde ${devises[0]}",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .primary),
                                        ),
                                        RaisedButtonDecor(
                                          onPressed: () {
                                            //Navigator.pushNamed(context, "/wallet");
                                            Navigator.pushNamed(
                                                context, '/rechargercompte');
                                            //setState(() {});
                                          },
                                          elevation: 0,
                                          color: appColorProvider.primaryColor,
                                          shape: BorderRadius.circular(5),
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Recharger",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: AppText.p5(context)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: Device.getScreenHeight(context) / 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '$allEventsPassed',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p1(context),
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black54),
                                        ),
                                        Text(
                                          "Evènements",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black38),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '$allGadgetsPassed',
                                          // "04/23",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p1(context),
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black54),
                                        ),
                                        Text(
                                          "Gadgets",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black38),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "$allSurveyResponded/$allEventsArchivedNumber",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p1(context),
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black54),
                                        ),
                                        Text(
                                          "Sondages",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Provider.of<AppColorProvider>(
                                                          context,
                                                          listen: false)
                                                      .black38),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Device.getScreenHeight(context) / 100,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                Device.getDiviseScreenWidth(context, 50),
                            vertical:
                                Device.getDiviseScreenHeight(context, 200)),
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: appColorProvider.darkMode
                                ? appColorProvider.primaryColor2
                                : appColorProvider.primaryColor5,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/parametrage');
                          },
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.calendarWithDayFocus,
                                  size: AppText.titre2(context),
                                  color: appColorProvider.black54),
                            ],
                          ),
                          title: Text(
                            "Paramétrage",
                            //"${Provider.of<DefaultUserProvider>(context, listen: false).image}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontSize: AppText.p2(context),
                                fontWeight: FontWeight.w800,
                                color: appColorProvider.black54),
                          ),
                          subtitle: Text(
                            "Vous pouvez nous dire pour quel évènements vous voulez être informé",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontSize: AppText.p4(context),
                                fontWeight: FontWeight.w400,
                                color: appColorProvider.black38),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: AppText.p4(context),
                              color: appColorProvider.black54),
                        ),
                      ),
                      SizedBox(
                        height: Device.getScreenHeight(context) / 100,
                      ),
                      Consumer<AppManagerProvider>(
                          builder: (context, appManagerProvider, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    appManagerProvider.profilTabController
                                        .animateTo(0,
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  // height: 50,
                                  decoration: Provider.of<AppManagerProvider>(
                                                  context,
                                                  listen: true)
                                              .profilTabController
                                              .index ==
                                          0
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Container(
                                    child: Badge(
                                      badgeColor: appManagerProvider
                                                  .profilTabController.index ==
                                              0
                                          ? Colors.red
                                          : appColorProvider.black54,
                                      badgeContent:
                                          Consumer<DefaultUserProvider>(builder:
                                              (context, Panier, child) {
                                        return Text(
                                          '${eventsPassed!.length}',
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.white,
                                              fontSize: AppText.p6(context),
                                              fontWeight: FontWeight.w600),
                                        );
                                      }),
                                      toAnimate: true,
                                      shape: BadgeShape.circle,
                                      padding: EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Passés",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: appManagerProvider
                                                          .profilTabController
                                                          .index ==
                                                      0
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: appColorProvider.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // _tabKey.currentState.
                                  setState(() {
                                    appManagerProvider.profilTabController
                                        .animateTo(1,
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  decoration: appManagerProvider
                                              .profilTabController.index ==
                                          1
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Container(
                                    child: Badge(
                                      badgeColor: appManagerProvider
                                                  .profilTabController.index ==
                                              1
                                          ? Colors.red
                                          : appColorProvider.black54,
                                      badgeContent:
                                          Consumer<DefaultUserProvider>(builder:
                                              (context, Panier, child) {
                                        return Text(
                                          '${eventsComing!.length}',
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.white,
                                              fontSize: AppText.p6(context),
                                              fontWeight: FontWeight.w600),
                                        );
                                      }),
                                      toAnimate: true,
                                      shape: BadgeShape.circle,
                                      padding: EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "A Venir",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: appManagerProvider
                                                          .profilTabController
                                                          .index ==
                                                      1
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: appColorProvider.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    appManagerProvider.profilTabController
                                        .animateTo(2,
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  decoration: appManagerProvider
                                              .profilTabController.index ==
                                          2
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Container(
                                    child: Badge(
                                      badgeColor: appManagerProvider
                                                  .profilTabController.index ==
                                              2
                                          ? Colors.red
                                          : appColorProvider.black54,
                                      badgeContent:
                                          Consumer<DefaultUserProvider>(builder:
                                              (context, Panier, child) {
                                        return Text(
                                          '${suggestions!.length}',
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.white,
                                              fontSize: AppText.p6(context),
                                              fontWeight: FontWeight.w600),
                                        );
                                      }),
                                      toAnimate: true,
                                      shape: BadgeShape.circle,
                                      padding: EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Suggestions",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: appManagerProvider
                                                          .profilTabController
                                                          .index ==
                                                      2
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: appColorProvider.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    appManagerProvider.profilTabController
                                        .animateTo(3,
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  // height: 50,
                                  decoration: Provider.of<AppManagerProvider>(
                                                  context,
                                                  listen: true)
                                              .profilTabController
                                              .index ==
                                          3
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Container(
                                    child: Badge(
                                      badgeColor: appManagerProvider
                                                  .profilTabController.index ==
                                              3
                                          ? Colors.red
                                          : appColorProvider.black54,
                                      badgeContent:
                                          Consumer<DefaultUserProvider>(builder:
                                              (context, Panier, child) {
                                        return Text(
                                          '${sondages!.length}',
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.white,
                                              fontSize: AppText.p6(context),
                                              fontWeight: FontWeight.w600),
                                        );
                                      }),
                                      toAnimate: true,
                                      shape: BadgeShape.circle,
                                      padding: EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Sondages",
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: appManagerProvider
                                                          .profilTabController
                                                          .index ==
                                                      3
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: appColorProvider.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: Device.getDiviseScreenHeight(context, 1.5),
                        child: Listener(onPointerDown: (details) {
                          print("2 ++");

                          // onPointerMove: (details) {

                          if (details.delta.dx < 0 &&
                              Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .profilTabController
                                      .index <
                                  2) {
                            Provider.of<AppManagerProvider>(context,
                                    listen: false)
                                .tabControllerstateChangePlus();
                          }
                          if (details.delta.dx > 0 &&
                              Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .profilTabController
                                      .index >
                                  0) {
                            Provider.of<AppManagerProvider>(context,
                                    listen: false)
                                .tabControllerstateChangeMoins();
                          }

                          // setState(() {});
                        }, child: Consumer<AppManagerProvider>(
                            builder: (context, appManagerProvider, child) {
                          return TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: appManagerProvider.profilTabController,
                            key: _tabKey,
                            children: [
                              SizedBox(
                                child: eventsPassed == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : eventsPassed!.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.asset(
                                                      'assets/images/empty.png'),
                                                ),
                                                const Center(
                                                  child: Text(
                                                    'Pas d\'évènements passés',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : EventsActifs(
                                            type: 'Passés',
                                            eventList: eventsPassed!),
                                //child: Satistics(),
                              ),
                              SizedBox(
                                child: eventsComing == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : eventsComing!.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.asset(
                                                      'assets/images/empty.png'),
                                                ),
                                                const Center(
                                                  child: Text(
                                                    'Pas d\'évènements a venir',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : EventsActifs(
                                            type: 'Avenir',
                                            eventList: eventsComing!),
                                //     Center(
                                //   child: Text('vide2'),
                                // ),
                              ),
                              SizedBox(
                                child: suggestions == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : suggestions!.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.asset(
                                                      'assets/images/empty.png'),
                                                ),
                                                const Center(
                                                  child: Text(
                                                    'Pas de suggestion d\'évènements',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : EventsActifs(
                                            type: 'Suggestions',
                                            eventList: suggestions!),
                                // child: Center(
                                //   child: Text('vide3'),p
                                // ),
                              ),
                              SizedBox(
                                child: sondages == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : sondages!.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.asset(
                                                      'assets/images/empty.png'),
                                                ),
                                                const Center(
                                                  child: Text(
                                                    'Pas de sondages',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : EventsActifs(
                                            type: 'Sondages',
                                            eventList: sondages!),
                                //child: Satistics(),
                              ),
                            ],
                          );
                        })),
                      ),
                    ],
                  ),

            // ListView(
            //   physics: BouncingScrollPhysics(),
            //   padding: EdgeInsets.symmetric(
            //     horizontal: Device.getDiviseScreenWidth(context, 30),
            //   ),
            //   children: [
            //     Card(
            //       color: appColorProvider.white,
            //       child: Container(
            //         padding: EdgeInsets.symmetric(
            //             horizontal: Device.getDiviseScreenWidth(context, 30),
            //             vertical: Device.getDiviseScreenHeight(context, 50)),
            //         child: Column(
            //           children: [
            //             Center(
            //               child: Hero(
            //                 tag: 'Image_Profile',
            //                 child: Container(
            //                   padding:
            //                       const EdgeInsets.symmetric(horizontal: 10),
            //                   child: Badge(
            //                     toAnimate: true,
            //                     badgeColor: Color.fromARGB(255, 93, 255, 28),
            //                     shape: BadgeShape.circle,
            //                     position: BadgePosition(bottom: 15, end: 15),
            //                     padding: const EdgeInsets.all(5),
            //                     child: Container(
            //                         padding: EdgeInsets.all(10),
            //                         height: 100,
            //                         width: 100,
            //                         child: photoProfil(context,
            //                             appColorProvider.primaryColor4, 100)),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Text(
            //               "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
            //               textAlign: TextAlign.center,
            //               style: GoogleFonts.poppins(
            //                   textStyle: Theme.of(context).textTheme.bodyLarge,
            //                   fontSize: AppText.p1(context),
            //                   fontWeight: FontWeight.w800,
            //                   color: Provider.of<AppColorProvider>(context,
            //                           listen: false)
            //                       .black54),
            //             ),
            //             Text(
            //               "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
            //               textAlign: TextAlign.center,
            //               style: GoogleFonts.poppins(
            //                   textStyle: Theme.of(context).textTheme.bodyLarge,
            //                   fontSize: AppText.p4(context),
            //                   fontWeight: FontWeight.w400,
            //                   color: Provider.of<AppColorProvider>(context,
            //                           listen: false)
            //                       .black38),
            //             ),
            //             SizedBox(
            //               height: Device.getScreenHeight(context) / 50,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: [
            //                 // Column(
            //                 //   children: [
            //                 //     Text(
            //                 //       "0",
            //                 //       textAlign: TextAlign.center,
            //                 //       style: GoogleFonts.poppins(
            //                 //           textStyle:
            //                 //               Theme.of(context).textTheme.bodyLarge,
            //                 //           fontSize: AppText.p1(context),
            //                 //           fontWeight: FontWeight.w800,
            //                 //           color: Provider.of<AppColorProvider>(
            //                 //                   context,
            //                 //                   listen: false)
            //                 //               .black54),
            //                 //     ),
            //                 //     Text(
            //                 //       "Tickets",
            //                 //       textAlign: TextAlign.center,
            //                 //       style: GoogleFonts.poppins(
            //                 //           textStyle:
            //                 //               Theme.of(context).textTheme.bodyLarge,
            //                 //           fontSize: AppText.p4(context),
            //                 //           fontWeight: FontWeight.w400,
            //                 //           color: Provider.of<AppColorProvider>(
            //                 //                   context,
            //                 //                   listen: false)
            //                 //               .black38),
            //                 //     ),
            //                 //   ],
            //                 // ),
            //                 Column(
            //                   children: [
            //                     Text(
            //                       "0",
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p1(context),
            //                           fontWeight: FontWeight.w800,
            //                           color: Provider.of<AppColorProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .black54),
            //                     ),
            //                     Text(
            //                       "Notifications",
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p4(context),
            //                           fontWeight: FontWeight.w400,
            //                           color: Provider.of<AppColorProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .black38),
            //                     ),
            //                   ],
            //                 ),
            //                 Column(
            //                   children: [
            //                     devises.isEmpty || solde == null?
            //             SizedBox(
            //               height: 20,
            //               width: 20,
            //               child: CircularProgressIndicator(color: Provider.of<AppColorProvider>(context,
            //                           listen: false)
            //                       .primary,)):
            //                     Text(
            //                       '${solde} ${devises[0]}',
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p1(context),
            //                           fontWeight: FontWeight.w800,
            //                           color: Provider.of<AppColorProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .black54),
            //                     ),
            //                     Text(
            //                       "Solde",
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p4(context),
            //                           fontWeight: FontWeight.w400,
            //                           color: Provider.of<AppColorProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .black38),
            //                     ),
            //                   ],
            //                 )
            //               ],
            //             ),
            //             SizedBox(
            //               height: Device.getScreenHeight(context) / 50,
            //             ),
            //             Row(
            //               children: [
            //                 Expanded(
            //                   child: OutlinedButton(
            //                     onPressed: () {
            //                       Navigator.pushNamed(
            //                           context, '/modifiecompte');
            //                     },
            //                     style: OutlinedButton.styleFrom(
            //                       padding: EdgeInsets.all(10),
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(5),
            //                       ),
            //                       side: BorderSide(
            //                           width: 0.7,
            //                           color: appColorProvider.black26),
            //                     ),
            //                     child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Icon(LineIcons.pen,
            //                               color: appColorProvider.black87,
            //                               size: AppText.p5(context)),
            //                           SizedBox(width: 5),
            //                           Text(
            //                             "Modifier mon compte",
            //                             style: GoogleFonts.poppins(
            //                                 color: appColorProvider.black87,
            //                                 fontSize: AppText.p5(context)),
            //                           ),
            //                         ]),
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   width: 5,
            //                 ),
            //                 Expanded(
            //                   child: RaisedButtonDecor(
            //                     onPressed: () {
            //                       // setState(() {});
            //                       Navigator.pushNamed(context, "/wallet");
            //                     },
            //                     elevation: 0,
            //                     color: appColorProvider.primaryColor,
            //                     shape: BorderRadius.circular(5),
            //                     padding: const EdgeInsets.all(10),
            //                     child: Text(
            //                       "Recharger mon portefeuil",
            //                       style: GoogleFonts.poppins(
            //                           color: Colors.white,
            //                           fontSize: AppText.p5(context)),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: Device.getScreenHeight(context) / 100,
            //     ),
            //     // Container(
            //     //   padding: EdgeInsets.symmetric(
            //     //       horizontal: Device.getDiviseScreenWidth(context, 50),
            //     //       vertical: Device.getDiviseScreenHeight(context, 200)),
            //     //   margin: EdgeInsets.all(2),
            //     //   decoration: BoxDecoration(
            //     //       color: appColorProvider.darkMode
            //     //           ? appColorProvider.primaryColor2
            //     //           : appColorProvider.primaryColor5,
            //     //       borderRadius: BorderRadius.all(Radius.circular(5))),
            //     //   child: ListTile(
            //     //     onTap: () {},
            //     //     leading: Column(
            //     //       mainAxisAlignment: MainAxisAlignment.center,
            //     //       crossAxisAlignment: CrossAxisAlignment.center,
            //     //       children: [
            //     //         Icon(LineIcons.userCheck,
            //     //             size: AppText.titre2(context),
            //     //             color: appColorProvider.black54),
            //     //       ],
            //     //     ),
            //     //     title: Text(
            //     //       "Devenir un commercial de CIBLE",
            //     //       textAlign: TextAlign.start,
            //     //       overflow: TextOverflow.ellipsis,
            //     //       style: GoogleFonts.poppins(
            //     //           textStyle: Theme.of(context).textTheme.bodyLarge,
            //     //           fontSize: AppText.p2(context),
            //     //           fontWeight: FontWeight.w800,
            //     //           color: appColorProvider.black54),
            //     //     ),
            //     //     subtitle: Text(
            //     //       "Vous aurez la possibilité de gagner sur vos recommendation",
            //     //       textAlign: TextAlign.start,
            //     //       overflow: TextOverflow.ellipsis,
            //     //       style: GoogleFonts.poppins(
            //     //           textStyle: Theme.of(context).textTheme.bodyLarge,
            //     //           fontSize: AppText.p4(context),
            //     //           fontWeight: FontWeight.w400,
            //     //           color: appColorProvider.black38),
            //     //     ),
            //     //     trailing: Icon(Icons.arrow_forward_ios,
            //     //         size: AppText.p4(context),
            //     //         color: appColorProvider.black54),
            //     //   ),
            //     // ),
            //     SizedBox(
            //       height: Device.getScreenHeight(context) / 100,
            //     ),
            //     SingleChildScrollView(
            //       child: Consumer<AppManagerProvider>(
            //           builder: (context, appManagerProvider, child) {
            //         return Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 2),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     appManagerProvider.profilTabController
            //                         .animateTo(0,
            //                             duration: Duration(milliseconds: 250),
            //                             curve: Curves.ease);
            //                   });
            //                 },
            //                 child: Container(
            //                   // height: 50,
            //                   decoration: Provider.of<AppManagerProvider>(
            //                                   context,
            //                                   listen: true)
            //                               .profilTabController
            //                               .index ==
            //                           0
            //                       ? BoxDecoration(
            //                           color: appColorProvider.darkMode
            //                               ? appColorProvider.black12
            //                               : appColorProvider.white,
            //                           borderRadius:
            //                               BorderRadius.all(Radius.circular(5)))
            //                       : BoxDecoration(
            //                           color: appColorProvider.transparent,
            //                           borderRadius:
            //                               BorderRadius.all(Radius.circular(0))),

            //                   // ignore: prefer_const_constructors
            //                   padding: EdgeInsets.symmetric(
            //                       vertical: 10, horizontal: 20),
            //                   child: Text(
            //                     "Statistiques",
            //                     style: GoogleFonts.poppins(
            //                         textStyle:
            //                             Theme.of(context).textTheme.bodyLarge,
            //                         fontSize: AppText.p3(context),
            //                         fontWeight: appManagerProvider
            //                                     .profilTabController.index ==
            //                                 0
            //                             ? FontWeight.bold
            //                             : FontWeight.w400,
            //                         color: appColorProvider.black87),
            //                   ),
            //                 ),
            //               ),
            //               InkWell(
            //                 onTap: () {
            //                   // _tabKey.currentState.
            //                   setState(() {
            //                     appManagerProvider.profilTabController
            //                         .animateTo(1,
            //                             duration: Duration(milliseconds: 250),
            //                             curve: Curves.ease);
            //                   });
            //                 },
            //                 child: Container(
            //                     decoration: appManagerProvider
            //                                 .profilTabController.index ==
            //                             1
            //                         ? BoxDecoration(
            //                             color: appColorProvider.darkMode
            //                                 ? appColorProvider.black12
            //                                 : appColorProvider.white,
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(5)))
            //                         : BoxDecoration(
            //                             color: appColorProvider.transparent,
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(0))),

            //                     // ignore: prefer_const_constructors
            //                     padding: EdgeInsets.symmetric(
            //                         vertical: 10, horizontal: 20),
            //                     child: Text(
            //                       " Activités récentes",
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p3(context),
            //                           fontWeight: appManagerProvider
            //                                       .profilTabController.index ==
            //                                   1
            //                               ? FontWeight.bold
            //                               : FontWeight.w400,
            //                           color: appColorProvider.black87),
            //                     )),
            //               ),
            //               InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     appManagerProvider.profilTabController
            //                         .animateTo(2,
            //                             duration: Duration(milliseconds: 250),
            //                             curve: Curves.ease);
            //                   });
            //                 },
            //                 child: Container(
            //                     decoration: appManagerProvider
            //                                 .profilTabController.index ==
            //                             2
            //                         ? BoxDecoration(
            //                             color: appColorProvider.darkMode
            //                                 ? appColorProvider.black12
            //                                 : appColorProvider.white,
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(5)))
            //                         : BoxDecoration(
            //                             color: appColorProvider.transparent,
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(0))),

            //                     // ignore: prefer_const_constructors
            //                     padding: EdgeInsets.symmetric(
            //                         vertical: 10, horizontal: 20),
            //                     child: Text(
            //                       "Utilisation",
            //                       style: GoogleFonts.poppins(
            //                           textStyle:
            //                               Theme.of(context).textTheme.bodyLarge,
            //                           fontSize: AppText.p3(context),
            //                           fontWeight: appManagerProvider
            //                                       .profilTabController.index ==
            //                                   2
            //                               ? FontWeight.bold
            //                               : FontWeight.w400,
            //                           color: appColorProvider.black87),
            //                     )),
            //               ),
            //             ],
            //           ),
            //         );
            //       }),
            //     ),
            //     SizedBox(
            //       height: Device.getDiviseScreenHeight(context, 1.5),
            //       child: Listener(onPointerDown: (details) {
            //         print("2 ++");

            //         // onPointerMove: (details) {

            //         if (details.delta.dx < 0 &&
            //             Provider.of<AppManagerProvider>(context, listen: false)
            //                     .profilTabController
            //                     .index <
            //                 2) {
            //           Provider.of<AppManagerProvider>(context, listen: false)
            //               .tabControllerstateChangePlus();
            //         }
            //         if (details.delta.dx > 0 &&
            //             Provider.of<AppManagerProvider>(context, listen: false)
            //                     .profilTabController
            //                     .index >
            //                 0) {
            //           Provider.of<AppManagerProvider>(context, listen: false)
            //               .tabControllerstateChangeMoins();
            //         }

            //         setState(() {});
            //       }, child: Consumer<AppManagerProvider>(
            //           builder: (context, appManagerProvider, child) {
            //         return TabBarView(
            //           physics: const NeverScrollableScrollPhysics(),
            //           controller: appManagerProvider.profilTabController,
            //           key: _tabKey,
            //           children: const [
            //             SizedBox(
            //               child: Satistics(),
            //             ),
            //             SizedBox(
            //               child: ActiviteRecentes(),
            //               //     Center(
            //               //   child: Text('vide2'),
            //               // ),
            //             ),
            //             SizedBox(
            //               child: Center(
            //                 child: Text('vide3'),
            //               ),
            //             ),
            //           ],
            //         );
            //       })),
            //     ),
            //   ],
            // ),
          ));
    });
  }
}
