import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/marque.dart';
import 'package:cible/views/eventDetails/eventDetails.widgets.dart';
import 'package:cible/views/eventDetails/event_details_formation.dart';
import 'package:cible/views/eventDetails/event_details_gastro.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cible/models/Event.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/models/date.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/eventDetails/eventDetails.controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gap/gap.dart';
import 'package:cible/widgets/toast.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';

import '../../database/userDBcontroller.dart';
import '../../helpers/dateHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../accueilFavoris/acceuilFavoris.controller.dart';

class EventDetails extends StatefulWidget {
  Map data = {};
  EventDetails({super.key, required this.data});

  @override
  State<EventDetails> createState() => _EventDetailsState(data: data);
}

const String image =
    "https://musee-possen.lu/wp-content/uploads/2020/08/placeholder.png";

class _EventDetailsState extends State<EventDetails> {
  Map data = {};
  _EventDetailsState({required this.data});
  int activeRole = 0;
  bool? etat;
  int activeDate = 0;
  int activePartDate = 0;
  int activePartDateCreneuauIndex = 0;
  bool particularActive = false;
  bool _isloading = false;
  bool _isloading1 = false;
  bool _isloading2 = false;
  late int currentEventFavoris;
  late int currentEventNbShare;
  FToast fToast = FToast();
  List dateCollections = [];
  Event1 event = Event1(
      Categorie("", "", "", "", false, []), "", "", "", [], "", [], [], "", "");
  final favoriscontroller = GlobalKey<LikeButtonState>();
  final sharecontroller = GlobalKey<LikeButtonState>();
  late Future<List<Ticket>> ticketsList;
  List<Categorie> listCategories = [];
  String eventCategorie = '';
  var token;
  List<Event1>? listFavoris;
  List favorisId = [];
  int? visitDuration = 1;
  String daySelected = '';
  String creneauSelected = '';

  @override
  void initState() {
    // TODO: implement initState
    getEventFromAPI();
    //initEventData();
    getFavorisFromAPI();
    currentEventFavoris = event.favoris;
    currentEventNbShare = event.share;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getEventFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    event = data['event'];

    setState(() {
      Provider.of<AppManagerProvider>(context, listen: false).currentEvent =
          event;
    });

    // print(event.id);
    // var response = await http.get(
    //   Uri.parse('$baseApiUrl/evenement/${event.id}/detail'),
    //   headers: {
    //     "Accept": "application/json",
    //     "Content-Type": "application/json",
    //     'Authorization': 'Bearer $token',
    //   },
    // );
    // Provider.of<AppManagerProvider>(context, listen: false)
    //     .currentEvent
    //     .isLoading = false;
    // print('response.statusCode');
    // print(response.statusCode);
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   setState(() {
    //     event = Event1.fromMap(jsonDecode(response.body)['data'] as Map);
    //     Provider.of<AppManagerProvider>(context, listen: false).currentEvent =
    //         event;
    //   });
    // }
  }

  getFavorisFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');

    var response = await http.get(
      Uri.parse('$baseApiUrl/particular/eventsfavoris'),
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
            getEventFromMap(jsonDecode(response.body)['data'] as List, {});
        for (var favoris in listFavoris!) {
          favorisId.add(favoris.id);
        }
        if (favorisId.contains(event.id)) {
          event.isLike = true;
        }
        print('favoris id' + favorisId.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);

    return Container(
      decoration: BoxDecoration(
        color: Provider.of<AppColorProvider>(context, listen: true).grey5,
        // image: DecorationImage(
        //   image: NetworkImage(
        //     image,
        //   ),
        //   fit: BoxFit.fitHeight,
        // ),
      ),
      child: Provider.of<AppManagerProvider>(context, listen: false)
              .currentEvent
              .isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: Device.getDiviseScreenHeight(context, 2),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Provider.of<AppManagerProvider>(context,
                                    listen: true)
                                .currentEvent
                                .image
                                .isNotEmpty
                            ? Image.network(
                                // Provider.of<AppManagerProvider>(context,
                                //           listen: true)
                                //       .currentEvent
                                //       .image,
                                Provider.of<AppManagerProvider>(context,
                                        listen: true)
                                    .currentEvent
                                    .image,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover,
                                    )),
                                height:
                                    Device.getDiviseScreenHeight(context, 10),
                                width:
                                    Device.getDiviseScreenHeight(context, 10),
                              ),
                      ),
                    ),
                    Provider.of<AppManagerProvider>(context, listen: true)
                            .currentEvent
                            .image
                            .isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: Device.getDiviseScreenHeight(
                                          context, 10)),
                                  color: Colors.grey.shade300.withOpacity(0.5),
                                  child: SizedBox(
                                    height: Device.getDiviseScreenHeight(
                                            context, 2) -
                                        Device.getDiviseScreenHeight(
                                            context, 10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.network(
                                          // Provider.of<AppManagerProvider>(context,
                                          //         listen: true)
                                          //     .currentEvent
                                          //     .image,

                                          Provider.of<AppManagerProvider>(
                                                  context,
                                                  listen: true)
                                              .currentEvent
                                              .image,
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: AppColorProvider().white),
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                    ),
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.black.withAlpha(300),
                    foregroundColor:
                        Provider.of<AppColorProvider>(context, listen: true)
                                .darkMode
                            ? Colors.white
                            : Colors.black,
                    elevation: 0,
                    title: Text(
                      Provider.of<AppManagerProvider>(context, listen: true)
                          .currentEvent
                          .titre,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: AppText.p2(context),
                          color: Provider.of<AppColorProvider>(context,
                                  listen: true)
                              .white),
                    ),
                    // actions: [getPopupMenu(event)],
                    actions: [
                      Container(
                        padding: EdgeInsets.only(right: 10, top: 6),
                        margin: EdgeInsets.only(right: 10),
                        child: badge.Badge(
                          badgeContent: Consumer<TicketProvider>(
                            builder: (context, tickets, child) {
                              return Text(
                                tickets.ticketsList.length.toString(),
                                style:
                                    TextStyle(color: AppColorProvider().white),
                              );
                            },
                          ),
                          toAnimate: true,
                          shape: badge.BadgeShape.circle,
                          padding: EdgeInsets.all(7),
                          child: IconButton(
                            icon: Icon(
                              LineIcons.shoppingCart,
                              size: AppText.titre1(context),
                              color: AppColorProvider().white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/cart");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Consumer<AppColorProvider>(
                      builder: (context, appColorProvider, child) {
                    List dateDebutSplitted =
                        Provider.of<AppManagerProvider>(context, listen: true)
                            .currentEvent
                            .dateOneDay
                            .split(' ');
                    List dateFinSplitted =
                        Provider.of<AppManagerProvider>(context, listen: true)
                            .currentEvent
                            .dateFin
                            .split(' ');
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: Device.getDiviseScreenHeight(context, 2.7),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          ),
                          SafeArea(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Provider.of<AppColorProvider>(context,
                                        listen: true)
                                    .white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  top:
                                      Device.getDiviseScreenHeight(context, 90),
                                  left:
                                      Device.getDiviseScreenWidth(context, 20),
                                  right:
                                      Device.getDiviseScreenWidth(context, 20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(5),
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Provider.of<AppColorProvider>(
                                                    context,
                                                    listen: true)
                                                .darkMode
                                            ? Color.fromARGB(255, 58, 58, 58)
                                            : Color.fromARGB(
                                                255, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(20),
                                  Text(
                                    Provider.of<AppManagerProvider>(context,
                                            listen: true)
                                        .currentEvent
                                        .titre,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      fontSize: AppText.p1(context),
                                      fontWeight: FontWeight.w800,
                                      color: appColorProvider.black,
                                    ),
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .ville,
                                              style: GoogleFonts.poppins(
                                                color: appColorProvider.black87,
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .newLieu,
                                              style: GoogleFonts.poppins(
                                                color: appColorProvider.black87,
                                                fontSize: AppText.p3(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(10),
                                      Container(
                                        height: Device.getDiviseScreenHeight(
                                            context, 20),
                                        width: 1,
                                        color: appColorProvider.black87,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Device.getDiviseScreenHeight(
                                                      context, 100),
                                              vertical:
                                                  Device.getDiviseScreenHeight(
                                                      context, 50)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              etat == false || etat == null
                                                  ? Column(
                                                      children: [
                                                        LikeButton(
                                                          onTap:
                                                              (isLiked) async {},
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          size: Device
                                                              .getDiviseScreenWidth(
                                                                  context, 27),
                                                          // ignore: prefer_const_constructors
                                                          circleColor: CircleColor(
                                                              start: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  255,
                                                                  0,
                                                                  157),
                                                              end: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  204,
                                                                  0,
                                                                  61)),
                                                          bubblesColor:
                                                              const BubblesColor(
                                                            dotPrimaryColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    229,
                                                                    51,
                                                                    205),
                                                            dotSecondaryColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    204,
                                                                    0,
                                                                    95),
                                                          ),
                                                          isLiked: false,
                                                          likeBuilder:
                                                              (bool isLiked) {
                                                            return Center(
                                                              child: Icon(
                                                                LineIcons
                                                                    .heartAlt,
                                                                color:
                                                                    appColorProvider
                                                                        .black38,
                                                                size: 20,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        const Gap(5),
                                                        Text(
                                                          '$currentEventFavoris',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                AppText.p2(
                                                                    context),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                appColorProvider
                                                                    .black,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Favoris",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                AppText.p4(
                                                                    context),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                appColorProvider
                                                                    .black54,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : listFavoris == null &&
                                                              etat == true ||
                                                          etat == null
                                                      ? SizedBox(
                                                          height: Device
                                                              .getDiviseScreenHeight(
                                                                  context, 30),
                                                          width: Device
                                                              .getDiviseScreenHeight(
                                                                  context, 30),
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Column(
                                                          children: [
                                                            LikeButton(
                                                              onTap:
                                                                  (isLiked) async {
                                                                //favoriscontroller.currentState!.onTap();
                                                                var isLike;
                                                                print(event
                                                                    .favoris);
                                                                event.isLike =
                                                                    !event
                                                                        .isLike;
                                                                UserDBcontroller()
                                                                    .liste()
                                                                    .then(
                                                                        (value) async {
                                                                  if (event
                                                                      .isLike) {
                                                                    event.setFavoris(
                                                                        event.favoris +
                                                                            1);
                                                                    isLike =
                                                                        await addFavoris(
                                                                      event.id,
                                                                    );
                                                                    setState(
                                                                      () {
                                                                        currentEventFavoris++;
                                                                      },
                                                                    );
                                                                  } else {
                                                                    event.setFavoris(
                                                                        event.favoris -
                                                                            1);
                                                                    isLike =
                                                                        await removeFavoris(
                                                                            event.id);
                                                                    setState(
                                                                      () {
                                                                        currentEventFavoris--;
                                                                      },
                                                                    );
                                                                  }
                                                                });
                                                                return isLike;
                                                              },
                                                              key:
                                                                  favoriscontroller,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              size: Device
                                                                  .getDiviseScreenWidth(
                                                                      context,
                                                                      27),
                                                              // ignore: prefer_const_constructors
                                                              circleColor: CircleColor(
                                                                  start: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      0,
                                                                      157),
                                                                  end: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      204,
                                                                      0,
                                                                      61)),
                                                              bubblesColor:
                                                                  const BubblesColor(
                                                                dotPrimaryColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        229,
                                                                        51,
                                                                        205),
                                                                dotSecondaryColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            204,
                                                                            0,
                                                                            95),
                                                              ),
                                                              isLiked:
                                                                  event.isLike,
                                                              likeBuilder: (bool
                                                                  isLiked) {
                                                                event.isLike =
                                                                    isLiked;
                                                                return Center(
                                                                  child: Icon(
                                                                    LineIcons
                                                                        .heartAlt,
                                                                    color: event.isLike
                                                                        ? Colors
                                                                            .red
                                                                        : appColorProvider
                                                                            .black38,
                                                                    size: 20,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            const Gap(5),
                                                            Text(
                                                              '$currentEventFavoris',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    AppText.p2(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    appColorProvider
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Favoris",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    AppText.p4(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    appColorProvider
                                                                        .black54,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                              const Gap(10),
                                              InkWell(
                                                onTap: () async {
                                                  sharecontroller.currentState!
                                                      .onTap();

                                                  // addLike(event);
                                                  Share.share("""COUCOU… 😊
                                      Je viens de découvrir une application géniale et complète pour l’événementiel que tu peux télécharger via ce lien : https://www.cible-app.com
                                      -	Voir tous les événements en Afrique en temps réel
                                      -	Achetez ses tickets en groupe ou perso
                                      -	Louer du matériel pour ses événements…
                                      -	Trouver des sponsors et des investisseurs
                                      -	Trouver du job dans l’événementiel
                                      Waouh… Une fierté africaine à soutenir.
                                      Site web officiel  : https://cible-app.com
                                      *Avec CIBLE, Ayez une longueur d'avance !*""",
                                                      subject:
                                                          "CIBLE, Ayez une longueur d'avance !");
                                                  // Timer(const Duration(seconds: 2), () {
                                                  //   setState(() {
                                                  //     event.share++;
                                                  //   });
                                                  // });
                                                  print(event.share);
                                                  event.setShare(
                                                      event.share + 1);
                                                  await modifyNbShare(
                                                      event.id, event.share);
                                                  print(event.share);
                                                  setState(
                                                    () {
                                                      currentEventNbShare++;
                                                    },
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    LikeButton(
                                                      key: sharecontroller,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      size: Device
                                                          .getDiviseScreenWidth(
                                                              context, 27),
                                                      // ignore: prefer_const_constructors
                                                      circleColor: CircleColor(
                                                          start: Color.fromARGB(
                                                              255, 0, 255, 255),
                                                          end: Color.fromARGB(
                                                              255,
                                                              0,
                                                              204,
                                                              109)),
                                                      bubblesColor:
                                                          const BubblesColor(
                                                        dotPrimaryColor:
                                                            Color.fromARGB(255,
                                                                2, 172, 67),
                                                        dotSecondaryColor:
                                                            Color.fromARGB(255,
                                                                2, 116, 49),
                                                      ),
                                                      isLiked: event.isShare,
                                                      likeBuilder:
                                                          (bool isLiked) {
                                                        isLiked
                                                            ? event.isShare =
                                                                isLiked
                                                            : event.isShare =
                                                                event.isShare;
                                                        return Center(
                                                          child: Icon(
                                                            Icons.share,
                                                            color: event.isShare
                                                                ? Colors.green
                                                                : appColorProvider
                                                                    .black38,
                                                            size: 20,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const Gap(5),
                                                    Text(
                                                      '${currentEventNbShare}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            AppText.p2(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: appColorProvider
                                                            .black,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Partages",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            AppText.p4(context),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: appColorProvider
                                                            .black54,
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
                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .theme
                                          .isNotEmpty
                                      ? Visibility(
                                          visible:
                                              Provider.of<AppManagerProvider>(
                                                          context,
                                                          listen: true)
                                                      .currentEvent
                                                      .categorie
                                                      .code !=
                                                  'FORM',
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Thème',
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p3(context),
                                                  fontWeight: FontWeight.w800,
                                                  color: appColorProvider.black,
                                                ),
                                              ),
                                              Text(
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: true)
                                                    .currentEvent
                                                    .theme,
                                                style: GoogleFonts.poppins(
                                                  fontSize: AppText.p4(context),
                                                  color:
                                                      appColorProvider.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),

                                  const Gap(5),
                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .description
                                          .isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Description',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                                color: appColorProvider.black,
                                              ),
                                            ),
                                            Text(
                                              Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .description,
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p4(context),
                                                color: appColorProvider.black87,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),

                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .marques
                                          .isEmpty
                                      ? const SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Gap(10),
                                            Text(
                                              'Les marques qui défilent',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                                color: appColorProvider.black,
                                              ),
                                            ),
                                            const Gap(10),
                                            SizedBox(
                                              height:
                                                  Device.getDiviseScreenHeight(
                                                      context, 10),
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: Provider.of<
                                                            AppManagerProvider>(
                                                        context,
                                                        listen: true)
                                                    .currentEvent
                                                    .marques
                                                    .length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(
                                                  width: Device
                                                      .getDiviseScreenWidth(
                                                          context, 16),
                                                ),
                                                itemBuilder: (context, index) {
                                                  Marque marque = Provider.of<
                                                              AppManagerProvider>(
                                                          context,
                                                          listen: true)
                                                      .currentEvent
                                                      .marques[index];
                                                  return MarqueWidget(
                                                    libelle: marque.libelle,
                                                    description:
                                                        marque.description,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),

                                  // Type Gastronomie
                                  Visibility(
                                    visible: Provider.of<AppManagerProvider>(
                                                context,
                                                listen: false)
                                            .currentEvent
                                            .categorie
                                            .code ==
                                        'GAST',
                                    child: const EventDetailsGastro(),
                                  ),

                                  // Type Formation
                                  Visibility(
                                    visible: Provider.of<AppManagerProvider>(
                                                context,
                                                listen: false)
                                            .currentEvent
                                            .categorie
                                            .code ==
                                        'FORM',
                                    child: const EventDetailsFormation(),
                                  ),

                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .dateOneDay
                                                  .isEmpty
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Device
                                                        .getDiviseScreenWidth(
                                                            context, 20),
                                                    vertical: Device
                                                        .getDiviseScreenWidth(
                                                            context, 40),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: appColorProvider
                                                          .primary,
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      150)))),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${'${dateDebutSplitted[0]}'.substring(0, 3).toUpperCase()}.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    AppText.p6(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          '${dateDebutSplitted[1]}'
                                                              .toUpperCase(),
                                                          style: GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: AppText
                                                                  .titre4(
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${'${dateDebutSplitted[2]}'.substring(0, 3).toUpperCase()}.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    AppText.p6(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Provider.of<AppManagerProvider>(context,
                                                  listen: true)
                                              .currentEvent
                                              .dateFin
                                              .isEmpty
                                          ? const SizedBox()
                                          : Container(
                                              height: 1,
                                              width:
                                                  Device.getDiviseScreenWidth(
                                                      context, 3),
                                              color: appColorProvider.black87,
                                            ),
                                      Row(
                                        children: [
                                          Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .dateFin
                                                  .isEmpty
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Device
                                                        .getDiviseScreenWidth(
                                                            context, 20),
                                                    vertical: Device
                                                        .getDiviseScreenWidth(
                                                            context, 40),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: appColorProvider
                                                          .primary,
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      150)))),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${'${dateFinSplitted[0]}'.substring(0, 3).toUpperCase()}.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    AppText.p6(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          '${dateFinSplitted[1]}'
                                                              .toUpperCase(),
                                                          style: GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: AppText
                                                                  .titre4(
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800)),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${'${dateFinSplitted[2]}'.substring(0, 3).toUpperCase()}.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    AppText.p6(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Visibility(
                                            visible:
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: true)
                                                    .currentEvent
                                                    .heureDebut
                                                    .isNotEmpty,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Heure Début',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppText.p3(context),
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        appColorProvider.black,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Device
                                                        .getDiviseScreenWidth(
                                                            context, 20),
                                                    vertical: Device
                                                        .getDiviseScreenWidth(
                                                            context, 40),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              appColorProvider
                                                                  .primary),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      150)))),
                                                  child: Text(
                                                    Provider.of<AppManagerProvider>(
                                                            context,
                                                            listen: true)
                                                        .currentEvent
                                                        .heureDebut,
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          AppText.p3(context),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: appColorProvider
                                                          .black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Gap(10),
                                          Visibility(
                                            visible:
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: true)
                                                    .currentEvent
                                                    .heureFin
                                                    .isNotEmpty,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Heure Fin',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppText.p3(context),
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        appColorProvider.black,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Device
                                                        .getDiviseScreenWidth(
                                                            context, 20),
                                                    vertical: Device
                                                        .getDiviseScreenWidth(
                                                            context, 40),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              appColorProvider
                                                                  .primary),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              Device
                                                                  .getDiviseScreenHeight(
                                                                      context,
                                                                      150)))),
                                                  child: Text(
                                                    Provider.of<AppManagerProvider>(
                                                            context,
                                                            listen: true)
                                                        .currentEvent
                                                        .heureFin,
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          AppText.p3(context),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: appColorProvider
                                                          .black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const Gap(10),

                                  Visibility(
                                    visible: Provider.of<AppManagerProvider>(
                                            context,
                                            listen: true)
                                        .currentEvent
                                        .weekDaysInfo
                                        .isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Jours et horaires',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w800,
                                            color: appColorProvider.black,
                                          ),
                                        ),
                                        Text(
                                          Provider.of<AppManagerProvider>(
                                                  context,
                                                  listen: true)
                                              .currentEvent
                                              .weekDaysInfo,
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p4(context),
                                            color: appColorProvider.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Gap(10),
                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .program
                                          .isEmpty
                                      ? const SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Programme',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                                color: appColorProvider.black,
                                              ),
                                            ),
                                            Text(
                                              Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: true)
                                                  .currentEvent
                                                  .program,
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p4(context),
                                                color: appColorProvider.black87,
                                              ),
                                            ),
                                          ],
                                        ),

                                  const Gap(20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Tickets disponibles',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppText.p3(context),
                                          fontWeight: FontWeight.w800,
                                          color: appColorProvider.black,
                                        ),
                                      ),
                                      const Gap(10),
                                      ticketsWidget()
                                    ],
                                  ),

                                  const Gap(10),
                                  Visibility(
                                    visible: Provider.of<AppManagerProvider>(
                                            context,
                                            listen: true)
                                        .currentEvent
                                        .informationNote
                                        .isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Note d'information",
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w800,
                                            color: appColorProvider.black,
                                          ),
                                        ),
                                        Text(
                                          Provider.of<AppManagerProvider>(
                                                  context,
                                                  listen: true)
                                              .currentEvent
                                              .informationNote,
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p4(context),
                                            color: appColorProvider.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Gap(10),
                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .conditions
                                          .isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Conditions d'accès de l'évènement",
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                                color: appColorProvider.black,
                                              ),
                                            ),
                                            const Gap(5),
                                            Text(
                                              '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.conditions}',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p4(context),
                                                color: appColorProvider.black87,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  const Gap(15),
                                  Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .roles
                                          .isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Acteurs',
                                              style: GoogleFonts.poppins(
                                                fontSize: AppText.p3(context),
                                                fontWeight: FontWeight.w800,
                                                color: appColorProvider.black,
                                              ),
                                            ),
                                            const Gap(10),
                                            Container(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  child: getRoles()),
                                            ),
                                            const Gap(15),
                                            getArtiste(activeRole),
                                            const Gap(30),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const Gap(5),
                                  RichText(
                                    text: TextSpan(
                                      text: "Organisateur : ",
                                      style: GoogleFonts.poppins(
                                        color: appColorProvider.black87,
                                        fontSize: AppText.p4(context),
                                      ),
                                      children: [
                                        TextSpan(
                                            text:
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: true)
                                                    .currentEvent
                                                    .auteur
                                                    .raisonSociale,
                                            style: TextStyle(
                                                color: appColorProvider
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                                  const Gap(5),
                                  Row(
                                    children: [
                                      Text(
                                        Provider.of<AppManagerProvider>(context,
                                                listen: true)
                                            .currentEvent
                                            .auteur
                                            .tel1,
                                        style: GoogleFonts.poppins(
                                          color: appColorProvider.black87,
                                          fontSize: AppText.p4(context),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            Provider.of<AppManagerProvider>(
                                                    context,
                                                    listen: true)
                                                .currentEvent
                                                .auteur
                                                .email1
                                                .isNotEmpty,
                                        child: Text(
                                          " | ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.auteur.email1}",
                                          style: GoogleFonts.poppins(
                                            color: appColorProvider.black87,
                                            fontSize: AppText.p4(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(50),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                _isloading
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: Device.getDiviseScreenHeight(context, 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Positioned(
                                child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 17),
                                child: Row(
                                  children: [
                                    Container(
                                      height: AppText.p3(context),
                                      width: AppText.p3(context),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Gap(10),
                                    Text(
                                      'Désactivation ...',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    : const SizedBox(),
                _isloading2
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: Device.getDiviseScreenHeight(context, 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Positioned(
                                child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 17),
                                child: Row(
                                  children: [
                                    Container(
                                      height: AppText.p3(context),
                                      width: AppText.p3(context),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.red,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Gap(10),
                                    Text(
                                      'Suppression ...',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
    );
  }

  Future<List<Ticket>> getNewTickets() async {
    etat = await SharedPreferencesHelper.getBoolValue("logged");
    List<Ticket> tickets =
        Provider.of<AppManagerProvider>(context, listen: false)
            .currentEvent
            .tickets;
    return tickets;
  }

  ticketsWidget() {
    return FutureBuilder(
      future: getNewTickets(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var tickets = snapshot.data as List<Ticket>;
          return Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: tickets.length,
                itemBuilder: (context, i) {
                  var quantite;
                  bool isAdded = false;
                  return tickets[i].nombrePlaces == 0
                      ? const SizedBox()
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appColorProvider.black12),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                Device.getDiviseScreenHeight(context, 150),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(
                            Device.getDiviseScreenHeight(context, 100),
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: appColorProvider.primaryColor1,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //libelle ticket
                                    Expanded(
                                      child: Text(
                                        tickets[i].libelle,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p3(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: appColorProvider.white,
                                      height: 20,
                                      width: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${tickets[i].prix} FCFA',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p3(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: appColorProvider.white,
                                      height: 20,
                                      width: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${tickets[i].nombrePlaces} Tickets',
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p3(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(7),
                              tickets[i].description == ''
                                  ? const SizedBox()
                                  : Text(
                                      tickets[i].description,
                                      style: GoogleFonts.poppins(
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w400,
                                        color: appColorProvider.black87,
                                      ),
                                    ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: inputDecorationGrey(
                                        "Quantité",
                                        Device.getScreenWidth(context),
                                      ),
                                      onChanged: (val) {
                                        quantite = val;
                                        print(val);
                                        print(quantite);
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const Gap(5),
                                  Expanded(
                                    child: SizedBox(
                                      // height: Device.getScreenHeight(context),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print("quantite");
                                          print(quantite);
                                          Provider.of<TicketProvider>(context,
                                                  listen: false)
                                              .addTicket(
                                            TicketUser(
                                                tickets[i],
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: false)
                                                    .currentEvent,
                                                int.parse(quantite)
                                                    .clamp(1, 10),
                                                (tickets[i].prix) *
                                                    int.parse(quantite)
                                                        .clamp(1, 10)),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColorProvider().primaryColor5,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14.0,
                                            horizontal: 3.0,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                        child: Text(
                                          'Ajouter au panier',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: AppColorProvider()
                                                .primaryColor1,
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          fToast.showToast(
            fadeDuration: Duration(seconds: 1000),
            child: toastError(context, "Une erreur est survenue."),
          );
          return Text("Une erreur est survenue");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // getTickes() {
  //   List<Widget> listtickets = [];
  //   for (var i = 0;
  //       i <
  //           Provider.of<AppManagerProvider>(context, listen: true)
  //               .currentEvent
  //               .tickets
  //               .length;
  //       i++) {
  //     listtickets.add(Consumer<AppColorProvider>(
  //         builder: (context, appColorProvider, child) {
  //       return Column(
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //                 border: Border.all(color: appColorProvider.black12),
  //                 borderRadius: BorderRadius.all(Radius.circular(
  //                     Device.getDiviseScreenHeight(context, 150)))),
  //             padding:
  //                 EdgeInsets.all(Device.getDiviseScreenHeight(context, 100)),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //                   decoration: BoxDecoration(
  //                     color: appColorProvider.primaryColor5,
  //                     borderRadius: BorderRadius.all(Radius.circular(3)),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           Provider.of<AppManagerProvider>(context,
  //                                   listen: true)
  //                               .currentEvent
  //                               .tickets[i]
  //                               .libelle,
  //                           textAlign: TextAlign.start,
  //                           style: GoogleFonts.poppins(
  //                             color: appColorProvider.primaryColor2,
  //                             fontSize: AppText.p4(context),
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         color: appColorProvider.primaryColor3,
  //                         height: 20,
  //                         width: 1,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].prix} FCFA',
  //                           textAlign: TextAlign.center,
  //                           style: GoogleFonts.poppins(
  //                             fontSize: AppText.p4(context),
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         color: appColorProvider.primaryColor3,
  //                         height: 20,
  //                         width: 1,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].nombrePlaces} Tickets',
  //                           textAlign: TextAlign.end,
  //                           style: GoogleFonts.poppins(
  //                             fontSize: AppText.p4(context),
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const Gap(7),
  //                 Text(
  //                   Provider.of<AppManagerProvider>(context, listen: true)
  //                       .currentEvent
  //                       .tickets[i]
  //                       .description,
  //                   style: GoogleFonts.poppins(
  //                     fontSize: AppText.p4(context),
  //                     fontWeight: FontWeight.w400,
  //                     color: appColorProvider.black87,
  //                   ),
  //                 ),
  //                 const Gap(5),
  //                 getTicketParticular(i),
  //                 const Gap(5),
  //                 Provider.of<AppManagerProvider>(context, listen: true)
  //                             .currentEvent
  //                             .tickets[i]
  //                             .promo1["pourcentage"] !=
  //                         null
  //                     ? Text(
  //                         '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["pourcentage"]} % de reduction aux ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["nbreMax"]} premiers acheteurs',
  //                         style: GoogleFonts.poppins(
  //                           fontSize: AppText.p3(context),
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       )
  //                     : const SizedBox(),
  //                 const Gap(5),
  //                 Provider.of<AppManagerProvider>(context, listen: true)
  //                             .currentEvent
  //                             .tickets[i]
  //                             .promo2["pourcentage"] !=
  //                         null
  //                     ? Text(
  //                         '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo2["pourcentage"]} % de reduction pour ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["nbreMin"]} achetés',
  //                         style: GoogleFonts.poppins(
  //                           fontSize: AppText.p3(context),
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       )
  //                     : const SizedBox(),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: Device.getScreenHeight(context) / 100),
  //         ],
  //       );
  //     }));
  //   }
  //   return Column(children: listtickets);
  // }

  getRoles() {
    List<Widget> listRole = [];
    for (var i = 0;
        i <
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .roles
                .length;
        i++) {
      listRole.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  activeRole = i;
                  listRole.clear();
                  getRoles();
                });
              },
              child: Container(
                decoration: activeRole == i
                    ? BoxDecoration(
                        color: appColorProvider.primaryColor5,
                        // border: Border.all(
                        //     color:
                        //         appColorProvider.black12),
                        borderRadius: BorderRadius.all(Radius.circular(
                            Device.getDiviseScreenHeight(context, 150))))
                    : BoxDecoration(
                        color: appColorProvider.grey2,
                        borderRadius: BorderRadius.all(Radius.circular(
                            Device.getDiviseScreenHeight(context, 150)))),
                padding: EdgeInsets.symmetric(
                    vertical: Device.getDiviseScreenHeight(context, 100),
                    horizontal: Device.getDiviseScreenHeight(context, 50)),
                child: Text(
                  Provider.of<AppManagerProvider>(context, listen: false)
                      .currentEvent
                      .roles[i]
                      .libelle,
                  style: GoogleFonts.poppins(
                    fontSize: AppText.p4(context),
                    fontWeight: FontWeight.w600,
                    color: activeRole == i
                        ? appColorProvider.primaryColor1
                        : appColorProvider.black54,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      }));
    }
    return Row(children: listRole);
  }

  getArtiste(i) {
    List<Widget> listArtiste = [];
    for (var j = 0;
        j <
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .roles[i]
                .acteurs
                .length;
        j++) {
      listArtiste.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Container(
          margin: EdgeInsets.only(
              right: Device.getDiviseScreenHeight(context, 250),
              bottom: Device.getDiviseScreenHeight(context, 250)),
          decoration: BoxDecoration(
              color: appColorProvider.primary.withOpacity(0.6),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 99, 62, 168),
                  Color.fromARGB(255, 108, 10, 126),
                  Color.fromARGB(255, 155, 24, 144),
                ],
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(Device.getDiviseScreenHeight(context, 200)))),
          padding: EdgeInsets.symmetric(
              vertical: Device.getDiviseScreenHeight(context, 50),
              horizontal: Device.getDiviseScreenHeight(context, 25)),
          child: Column(
            children: [
              Text(
                Provider.of<AppManagerProvider>(context, listen: true)
                    .currentEvent
                    .roles[i]
                    .acteurs[j]
                    .nom,
                style: GoogleFonts.poppins(
                  fontSize: AppText.p4(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Visibility(
                visible: Provider.of<AppManagerProvider>(context, listen: true)
                    .currentEvent
                    .roles[i]
                    .acteurs[j]
                    .parcours
                    .isNotEmpty,
                child: Text(
                  Provider.of<AppManagerProvider>(context, listen: true)
                      .currentEvent
                      .roles[i]
                      .acteurs[j]
                      .parcours,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppText.p6(context),
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Visibility(
                visible: Provider.of<AppManagerProvider>(context, listen: true)
                    .currentEvent
                    .roles[i]
                    .acteurs[j]
                    .presentation
                    .isNotEmpty,
                child: Text(
                  Provider.of<AppManagerProvider>(context, listen: true)
                      .currentEvent
                      .roles[i]
                      .acteurs[j]
                      .presentation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppText.p6(context),
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }));
    }
    return Wrap(
      children: [
        Wrap(children: listArtiste),
      ],
    );
  }

  getDates() {
    print('rrgetDates ' +
        dateCollections[0]['date']
            .valeur
            .toString()); /*${dateCollections[0]['date'].creneauHeures[0].heureDebut}*/
    List<Widget> listDates = [];
    //print('date ${dateCollections[0]['date'].toMap()}');
    for (var i = 0; i < dateCollections.length; i++) {
      List date = dateCollections[i]['date'].valeur != null
          ? dateCollections[i]['date'].valeur.split(' ')
          : [];

      if (date.isNotEmpty && dateCollections[i]['date'].creneauHeures != null) {
        listDates.add(Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
          return GestureDetector(
            onTap: () {
              setState(() {
                activeDate = i;
                listDates.clear();
                getDates();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: EdgeInsets.symmetric(
                horizontal: Device.getDiviseScreenWidth(context, 20),
                vertical: Device.getDiviseScreenWidth(context, 40),
              ),
              decoration: activeDate == i
                  ? BoxDecoration(
                      color: appColorProvider.primary,
                      borderRadius: BorderRadius.all(Radius.circular(
                          Device.getDiviseScreenHeight(context, 150))))
                  : dateCollections[i]['date'].type == 0
                      ? const BoxDecoration()
                      : BoxDecoration(
                          border: Border.all(color: appColorProvider.primary),
                          borderRadius: BorderRadius.all(Radius.circular(
                              Device.getDiviseScreenHeight(context, 150)))),
              child: Column(
                children: [
                  Text(
                    '${date.isNotEmpty ? '${date[0]}'.substring(0, 3).toUpperCase() : ''}.',
                    style: GoogleFonts.poppins(
                        color: activeDate == i
                            ? Colors.white
                            : dateCollections[i]['date'].type == 0
                                ? appColorProvider.black
                                : appColorProvider.primary,
                        fontSize: AppText.p6(context),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${date.isNotEmpty ? '${date[1]}'.toUpperCase() : ''}.',
                      style: GoogleFonts.poppins(
                          color: activeDate == i
                              ? Colors.white
                              : dateCollections[i]['date'].type == 0
                                  ? appColorProvider.black
                                  : appColorProvider.primary,
                          fontSize: AppText.titre4(context),
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${date.isNotEmpty ? '${date[2]}'.substring(0, 3).toUpperCase() : ''}.',
                    style: GoogleFonts.poppins(
                        color: activeDate == i
                            ? Colors.white
                            : dateCollections[i]['date'].type == 0
                                ? appColorProvider.black
                                : appColorProvider.primary,
                        fontSize: AppText.p6(context),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }));
      }
    }
    return Row(children: listDates);
  }

  getDates2() {
    print(
        'rrgetDates2' /*+dateCollections[0]['date'].creneauHeures[0].heureDebut.toString()*/);
    List<Widget> listDates = [];
    List<Widget> listDatesPart = [];

    for (var i = 0; i < dateCollections.length; i++) {
      List date = [];
      //List date1 = dateCollections[i]['creneauDate'].dateFin.split(' ');
      for (var onDate in dateEvents) {
        print('rrrrrrrrrrrrr' + dateCollections.toString());
        date.add(DateConvertisseur().convertirDatePicker(onDate).split(' '));
      }
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Row(
          children: [
            for (var currentDate in date) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    particularActive = false;
                    activeDate = i;
                    if (daySelected == currentDate.toString()) {
                      daySelected = '';
                    } else {
                      daySelected = currentDate.toString();
                    }
                    listDates.clear();
                    getDates2();
                  });
                },
                child: Container(
                  height: 100,
                  width: 80,
                  margin: const EdgeInsets.only(right: 5),
                  padding: EdgeInsets.symmetric(
                    horizontal: Device.getDiviseScreenWidth(context, 50),
                    vertical: Device.getDiviseScreenWidth(context, 40),
                  ),
                  decoration: activeDate == i &&
                          !particularActive &&
                          daySelected == currentDate.toString()
                      ? BoxDecoration(
                          color: appColorProvider.primary,
                          borderRadius: BorderRadius.all(Radius.circular(
                              Device.getDiviseScreenHeight(context, 150))))
                      : BoxDecoration(
                          border: Border.all(
                            color: appColorProvider.primary,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              Device.getDiviseScreenHeight(context, 150)))),
                  child:
                      // Row(
                      //   children: [
                      Column(
                    children: [
                      Text(
                        '${'${currentDate[0]}'.substring(0, 3).toUpperCase()}.',
                        style: GoogleFonts.poppins(
                            color: activeDate == i &&
                                    !particularActive &&
                                    daySelected == currentDate.toString()
                                ? Colors.white
                                : appColorProvider.primary,
                            fontSize: AppText.p6(context),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('${currentDate[1]}'.toUpperCase(),
                          style: GoogleFonts.poppins(
                              color: activeDate == i &&
                                      !particularActive &&
                                      daySelected == currentDate.toString()
                                  ? Colors.white
                                  : appColorProvider.primary,
                              fontSize: AppText.titre4(context),
                              fontWeight: FontWeight.w800)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${'${currentDate[2]}'.substring(0, 3).toUpperCase()}.',
                        style: GoogleFonts.poppins(
                            color: activeDate == i &&
                                    !particularActive &&
                                    daySelected == currentDate.toString()
                                ? Colors.white
                                : appColorProvider.primary,
                            fontSize: AppText.p6(context),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 10),
                  //   width: 20,
                  //   height: 2,
                  //   decoration: activeDate == i && !particularActive
                  //       ? BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.all(Radius.circular(
                  //               Device.getDiviseScreenHeight(context, 150))))
                  //       : BoxDecoration(
                  //           color: appColorProvider.primary,
                  //         ),
                  // ),
                  // Column(
                  //   children: [
                  //     Text(
                  //       '${date1[0]}'.isNotEmpty
                  //           ? '${'${date1[0]}'.substring(0, 3).toUpperCase()}.'
                  //           : '',
                  //       style: GoogleFonts.poppins(
                  //           color: activeDate == i && !particularActive
                  //               ? Colors.white
                  //               : appColorProvider.primary,
                  //           fontSize: AppText.p6(context),
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //     const SizedBox(
                  //       height: 5,
                  //     ),
                  //     Text('${date1[1]}'.toUpperCase(),
                  //         style: GoogleFonts.poppins(
                  //             color: activeDate == i && !particularActive
                  //                 ? Colors.white
                  //                 : appColorProvider.primary,
                  //             fontSize: AppText.titre4(context),
                  //             fontWeight: FontWeight.w800)),
                  //     const SizedBox(
                  //       height: 5,
                  //     ),
                  //     Text(
                  //       '${'${date1[2]}'.substring(0, 3).toUpperCase()}.',
                  //       style: GoogleFonts.poppins(
                  //           color: activeDate == i && !particularActive
                  //               ? Colors.white
                  //               : appColorProvider.primary,
                  //           fontSize: AppText.p6(context),
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //   ],
                  // ),

                  //   ],
                  // ),
                ),
              ),
            ],
          ],
        );
      }));
      for (var j = 0;
          j < dateCollections[i]['creneauDate'].dateParticulieres.length;
          j++) {
        List date2 = dateCollections[i]['creneauDate']
            .dateParticulieres[j]
            .valeur
            .split(' ');
        listDatesPart.add(Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
          return GestureDetector(
            onTap: () {
              setState(() {
                particularActive = true;
                activePartDate = j;
                activePartDateCreneuauIndex = i;
                listDates.clear();
                getDates2();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: EdgeInsets.symmetric(
                horizontal: Device.getDiviseScreenWidth(context, 20),
                vertical: Device.getDiviseScreenWidth(context, 40),
              ),
              decoration: activePartDate == j && particularActive
                  ? BoxDecoration(
                      color: appColorProvider.primary,
                      borderRadius: BorderRadius.all(Radius.circular(
                          Device.getDiviseScreenHeight(context, 150))))
                  : BoxDecoration(
                      border: Border.all(color: appColorProvider.primary),
                      borderRadius: BorderRadius.all(Radius.circular(
                          Device.getDiviseScreenHeight(context, 150)))),
              child: Column(
                children: [
                  Text(
                    '${'${date2[0]}'.substring(0, 3).toUpperCase()}.',
                    style: GoogleFonts.poppins(
                        color: activePartDate == j && particularActive
                            ? Colors.white
                            : appColorProvider.primary,
                        fontSize: AppText.p6(context),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${date2[1]}'.toUpperCase(),
                      style: GoogleFonts.poppins(
                          color: activePartDate == j && particularActive
                              ? Colors.white
                              : appColorProvider.primary,
                          fontSize: AppText.titre4(context),
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${'${date2[2]}'.substring(0, 3).toUpperCase()}.',
                    style: GoogleFonts.poppins(
                        color: activePartDate == j && particularActive
                            ? Colors.white
                            : appColorProvider.primary,
                        fontSize: AppText.p6(context),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }));
      }
    }

    return Row(
      children: [
        Row(children: listDates),
        Row(children: listDatesPart),
      ],
    );
  }

  getCreneauxLieux() {
    print('rrgetCreneauxLieux');
    List<Widget> listDates = [];
    for (var i = 0;
        i < dateCollections[activeDate]['lieuxCreneaux'].length;
        i++) {
      for (var j = 0;
          j <
              dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures']
                  .length;
          j++) {
        listDates.add(Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle_outlined,
                    color: appColorProvider.primaryColor,
                    size: AppText.p5(context),
                  ),
                  Gap(7),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text:
                            '${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j].heureDebut} - ${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j].heureFin}',
                        style: GoogleFonts.poppins(
                          color: appColorProvider.black,
                          fontSize: AppText.p6(context),
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '\t\t\t${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}',
                              style: TextStyle(
                                  color: appColorProvider.primaryColor))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              "$i$j${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}" !=
                      "${dateCollections[activeDate]['lieuxCreneaux'].indexOf(dateCollections[activeDate]['lieuxCreneaux'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'].indexOf(dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}"
                  ? Container(
                      width: 1.5,
                      height: 15,
                      color: appColorProvider.primaryColor2,
                      margin: EdgeInsets.only(left: 5),
                    )
                  : const SizedBox(),
            ],
          );
        }));
      }
    }
    return Column(children: listDates);
  }

  getCreneauxLieuxPart() {
    print('rrgetCreneauxLieuxPart');
    List<Widget> listDates = [];
    Lieu lieu = dateCollections[activePartDateCreneuauIndex]['lieuxCreneaux'][0]
        ['lieu'];

    for (var j = 0;
        j <
            dateCollections[activePartDateCreneuauIndex]['creneauDate']
                .dateParticulieres[activePartDate]
                .creneauHeures
                .length;
        j++) {
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle_outlined,
                  color: appColorProvider.primaryColor,
                  size: AppText.p5(context),
                ),
                Gap(7),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text:
                          '${dateCollections[activePartDateCreneuauIndex]['creneauDate'].dateParticulieres[activePartDate].creneauHeures[j].heureDebut} - ${dateCollections[activePartDateCreneuauIndex]['creneauDate'].dateParticulieres[activePartDate].creneauHeures[j].heureFin}',
                      style: GoogleFonts.poppins(
                        color: appColorProvider.black,
                        fontSize: AppText.p5(context),
                      ),
                      children: [
                        TextSpan(
                            text: '\t\t\t${lieu.valeur}',
                            style:
                                TextStyle(color: appColorProvider.primaryColor))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            j !=
                    dateCollections[activePartDateCreneuauIndex]['creneauDate']
                            .dateParticulieres[activePartDate]
                            .creneauHeures
                            .length -
                        1
                ? Container(
                    width: 1.5,
                    height: 15,
                    color: appColorProvider.primaryColor2,
                    margin: EdgeInsets.only(left: 5),
                  )
                : const SizedBox(),
          ],
        );
      }));
    }
    return Column(children: listDates);
  }

  getCreneauxLieux2() {
    print('rrgetCreneauxLieux2');
    List<Widget> listDates = [];
    for (var i = 0;
        i < dateCollections[activeDate]['lieuxCreneaux'].length;
        i++) {
      print('date2 ${dateCollections[activeDate]['lieuxCreneaux'][i]}');
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text:
                    '${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}',
                style: GoogleFonts.poppins(
                  color: appColorProvider.primaryColor,
                  fontSize: AppText.p5(context),
                ),
                children: [
                  TextSpan(
                      text: '\t\t\t-- Jours ouvrables',
                      style: TextStyle(
                          color: appColorProvider.black,
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
            const SizedBox(height: 7),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: getCreneauxLieux2Simple(i),
            ),
            const SizedBox(height: 7),
            RichText(
              text: TextSpan(
                text:
                    '${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}',
                style: GoogleFonts.poppins(
                  color: appColorProvider.primaryColor,
                  fontSize: AppText.p5(context),
                ),
                children: [
                  TextSpan(
                      text: '\t\t\t-- Week-ends',
                      style: TextStyle(
                          color: appColorProvider.black,
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
            const SizedBox(height: 7),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: getCreneauxLieux2Week(i),
            ),
            const SizedBox(height: 7),
          ],
        );
      }));
    }
    return Column(children: listDates);
  }

  getCreneauxLieux2Simple(i) {
    List<Widget> listDates = [];
    for (var j = 0;
        j <
            dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures']
                .length;
        j++) {
      List intervalles = genererIntervalleHeures(
          dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j]
              .heureDebut,
          dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j]
              .heureFin,
          1);
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle_outlined,
                  color: appColorProvider.primaryColor,
                  size: AppText.p5(context),
                ),
                Gap(7),
                RichText(
                  text: TextSpan(
                    text:
                        '${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j].heureDebut} - ${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'][j].heureFin}',
                    style: GoogleFonts.poppins(
                      color: appColorProvider.black,
                      fontSize: AppText.p6(context),
                    ),
                  ),
                ),
              ],
            ),
            "$i$j${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}" !=
                    "${dateCollections[activeDate]['lieuxCreneaux'].indexOf(dateCollections[activeDate]['lieuxCreneaux'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'].indexOf(dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeures'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}"
                ? Container(
                    width: 1.5,
                    height: 15,
                    color: appColorProvider.primaryColor2,
                    margin: EdgeInsets.only(left: 5),
                  )
                : const SizedBox(),
            Gap(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var intervalle in intervalles) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (creneauSelected == intervalle.toString()) {
                            creneauSelected = '';
                          } else {
                            creneauSelected = intervalle.toString();
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        margin: const EdgeInsets.only(right: 5),
                        padding: EdgeInsets.symmetric(
                          horizontal: Device.getDiviseScreenWidth(context, 50),
                          vertical: Device.getDiviseScreenWidth(context, 40),
                        ),
                        decoration:
                            //activeDate == i && !particularActive &&
                            creneauSelected == intervalle.toString()
                                ? BoxDecoration(
                                    color: appColorProvider.primary,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Device.getDiviseScreenHeight(
                                                context, 150))))
                                : BoxDecoration(
                                    border: Border.all(
                                      color: appColorProvider.primary,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Device.getDiviseScreenHeight(
                                                context, 150)))),
                        child:
                            // Row(
                            //   children: [
                            Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$intervalle',
                              style: GoogleFonts.poppins(
                                  color:
                                      //  activeDate == i && !particularActive && daySelected == currentDate.toString()
                                      creneauSelected == intervalle.toString()
                                          ? Colors.white
                                          : appColorProvider.primary,
                                  fontSize: AppText.p6(context),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        );
      }));
    }
    return Column(children: listDates);
  }

  List genererIntervalleHeures(String heureDebut, String heureFin, int ecart) {
    List intervalles = [];

    DateTime heureDebutDateTime = DateTime.parse(
        "1970-01-01 ${heureDebut.split(' ')[0]}:${heureDebut.split(' ')[3]}");
    DateTime heureFinDateTime = DateTime.parse(
        "1970-01-01 ${heureFin.split(' ')[0]}:${heureFin.split(' ')[3]}");

    if (heureDebutDateTime.isBefore(heureFinDateTime)) {
      DateTime intervalleActuel = heureDebutDateTime;

      while (intervalleActuel.isBefore(heureFinDateTime)) {
        intervalles.add(
            '${intervalleActuel.toString().substring(11, 16)} - ${intervalleActuel.add(Duration(hours: ecart)).toString().substring(11, 16)}');
        intervalleActuel = intervalleActuel.add(Duration(hours: ecart));
      }
    } else {
      print("L'heure de début doit être inférieure à l'heure de fin.");
    }

    print("intervallesssssssssss" + intervalles.toString());
    return intervalles;
  }

  getCreneauxLieux2Week(i) {
    List<Widget> listDates = [];
    for (var j = 0;
        j <
            dateCollections[activeDate]['lieuxCreneaux'][i]
                    ['creneauHeuresWeekend']
                .length;
        j++) {
      List intervalles = genererIntervalleHeures(
          dateCollections[activeDate]['lieuxCreneaux'][i]
                  ['creneauHeuresWeekend'][j]
              .heureDebut,
          dateCollections[activeDate]['lieuxCreneaux'][i]
                  ['creneauHeuresWeekend'][j]
              .heureFin,
          1);
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle_outlined,
                  color: appColorProvider.primaryColor,
                  size: AppText.p5(context),
                ),
                Gap(7),
                RichText(
                  text: TextSpan(
                    text:
                        '${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeuresWeekend'][j].heureDebut} - ${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeuresWeekend'][j].heureFin}',
                    style: GoogleFonts.poppins(
                      color: appColorProvider.black,
                      fontSize: AppText.p6(context),
                    ),
                  ),
                ),
              ],
            ),
            "$i$j${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}" !=
                    "${dateCollections[activeDate]['lieuxCreneaux'].indexOf(dateCollections[activeDate]['lieuxCreneaux'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeuresWeekend'].indexOf(dateCollections[activeDate]['lieuxCreneaux'][i]['creneauHeuresWeekend'].last)}${dateCollections[activeDate]['lieuxCreneaux'][i]['lieu'].valeur}"
                ? Container(
                    width: 1.5,
                    height: 15,
                    color: appColorProvider.primaryColor2,
                    margin: EdgeInsets.only(left: 5),
                  )
                : const SizedBox(),
            Gap(7),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var intervalle in intervalles) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (creneauSelected == intervalle.toString()) {
                            creneauSelected = '';
                          } else {
                            creneauSelected = intervalle.toString();
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        margin: const EdgeInsets.only(right: 5),
                        padding: EdgeInsets.symmetric(
                          horizontal: Device.getDiviseScreenWidth(context, 50),
                          vertical: Device.getDiviseScreenWidth(context, 40),
                        ),
                        decoration:
                            //activeDate == i && !particularActive &&
                            creneauSelected == intervalle.toString()
                                ? BoxDecoration(
                                    color: appColorProvider.primary,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Device.getDiviseScreenHeight(
                                                context, 150))))
                                : BoxDecoration(
                                    border: Border.all(
                                      color: appColorProvider.primary,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Device.getDiviseScreenHeight(
                                                context, 150)))),
                        child:
                            // Row(
                            //   children: [
                            Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$intervalle',
                              style: GoogleFonts.poppins(
                                  color:
                                      //  activeDate == i && !particularActive && daySelected == currentDate.toString()
                                      creneauSelected == intervalle.toString()
                                          ? Colors.white
                                          : appColorProvider.primary,
                                  fontSize: AppText.p6(context),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        );
      }));
    }
    return Column(children: listDates);
  }

  getTicketParticular(i) {
    List<Widget> listtickets = [];

    for (var j = 0;
        j <
            Provider.of<AppManagerProvider>(context, listen: true)
                .currentEvent
                .tickets[i]
                .datesMontant
                .length;
        j++) {
      listtickets.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: appColorProvider.primaryColor,
              size: AppText.p4(context),
            ),
            const SizedBox(width: 5),
            Column(
              children: [
                Container(
                  width: Device.getDiviseScreenWidth(context, 1.3),
                  margin: EdgeInsets.only(bottom: 5),
                  child: RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      text: 'Ce ticket coûte ',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: AppText.p6(context),
                      ),
                      children: [
                        TextSpan(
                          text: 'Ce ticket coûte ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: AppText.p6(context),
                          ),
                        ),
                        TextSpan(
                            text:
                                '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].datesMontant[j].montant} FCFA ',
                            style: TextStyle(
                              color: appColorProvider.primaryColor,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                                'Le${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].datesMontant[j].date.length > 1 ? "s" : ''} ${getDateFormparticularTicket(i, j)}',
                            style: TextStyle(
                              color: appColorProvider.black,
                              fontWeight: FontWeight.w800,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }));
    }
    return Column(children: listtickets);
  }

  getDateFormparticularTicket(i, j) {
    String dates = "";
    for (var k = 0;
        k <
            Provider.of<AppManagerProvider>(context, listen: true)
                .currentEvent
                .tickets[i]
                .datesMontant[j]
                .date
                .length;
        k++) {
      dates +=
          '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].datesMontant[j].date[k].valeur}, ';
    }
    return dates;
  }
}
