import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/categorie.dart';
import 'package:cible/models/date.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/eventDetails/eventDetails.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gap/gap.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:like_button/like_button.dart';

import '../../database/userDBcontroller.dart';
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
  int activeDate = 0;
  int activePartDate = 0;
  int activePartDateCreneuauIndex = 0;
  bool particularActive = false;
  bool _isloading = false;
  bool _isloading1 = false;
  bool _isloading2 = false;
  late int currentEventFavoris;
  FToast fToast = FToast();
  List dateCollections = [];
  Event1 event = Event1(new Categorie("", "", "", "", false, []), "", "", "",
      [], "", [], [], "", "");
  // Event1 event = Event1(0, new Categorie("", "", "", "", false, []), "", "", "",
  //     [], "", [], [], "", "");
  final Likecontroller = GlobalKey<LikeButtonState>();
  final disLikecontroller = GlobalKey<LikeButtonState>();
  final favoriscontroller = GlobalKey<LikeButtonState>();
  final sharecontroller = GlobalKey<LikeButtonState>();

  @override
  void initState() {
    // TODO: implement initState
    initEventData();
    print('iiiiiiiiii' + event.id.toString());
    currentEventFavoris = event.favoris;
    super.initState();
    print(Provider.of<AppManagerProvider>(context, listen: false)
        .currentEvent
        .categorie
        .titre);
  }

  @override
  void dispose() {
    super.dispose();
  }

  initEventData() {
    Provider.of<AppManagerProvider>(context, listen: false).currentEvent =
        data['event'];
    print('ouuuuuuuuuuu' + data['event'].toString());
    event =
        Provider.of<AppManagerProvider>(context, listen: false).currentEvent;

    getCategorieIsMultiple(
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .categorie
                .code)
        ? initDate2()
        : initDate();
  }

  initDate() {
    for (var i = 0;
        i <
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux
                .length;
        i++) {
      for (var j = 0;
          j <
              Provider.of<AppManagerProvider>(context, listen: false)
                  .currentEvent
                  .lieux[i]
                  .dates
                  .length;
          j++) {
        if (!dateCollectionsVerifie(
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux[i]
                .dates[j],
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux[i])) {
          dateCollections.add({
            "date": Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux[i]
                .dates[j],
            "lieuxCreneaux": getDatelieuxCreneaux(
                Provider.of<AppManagerProvider>(context, listen: false)
                    .currentEvent
                    .lieux[i]
                    .dates[j],
                Provider.of<AppManagerProvider>(context, listen: false)
                    .currentEvent
                    .lieux[i])
          });
        }
      }
    }
  }

  initDate2() {
    for (var i = 0;
        i <
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux
                .length;
        i++) {
      for (var j = 0;
          j <
              Provider.of<AppManagerProvider>(context, listen: false)
                  .currentEvent
                  .lieux[i]
                  .creneauDates
                  .length;
          j++) {
        if (!dateCollectionsVerifie2(
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux[i]
                .creneauDates[j],
            Provider.of<AppManagerProvider>(context, listen: false)
                .currentEvent
                .lieux[i])) {
          dateCollections.add({
            "creneauDate":
                Provider.of<AppManagerProvider>(context, listen: false)
                    .currentEvent
                    .lieux[i]
                    .creneauDates[j],
            "lieuxCreneaux": getDatelieuxCreneaux2(
                Provider.of<AppManagerProvider>(context, listen: false)
                    .currentEvent
                    .lieux[i]
                    .creneauDates[j],
                Provider.of<AppManagerProvider>(context, listen: false)
                    .currentEvent
                    .lieux[i])
          });
        }
      }
    }
  }

  dateCollectionsVerifie(Date date, Lieu lieu) {
    for (int i = 0; i < dateCollections.length; i++) {
      if (dateCollections[i]["date"].valeur == date.valeur) {
        dateCollections[i]
            ["lieuxCreneaux"] = List.from(dateCollections[i]["lieuxCreneaux"])
          ..addAll(getDatelieuxCreneaux(date, lieu));
        return true;
      }
    }
    return false;
  }

  dateCollectionsVerifie2(CreneauDate date, Lieu lieu) {
    for (int i = 0; i < dateCollections.length; i++) {
      if (dateCollections[i]["creneauDate"].dateDebut == date.dateDebut &&
          dateCollections[i]["creneauDate"].dateFin == date.dateFin) {
        dateCollections[i]
            ["lieuxCreneaux"] = List.from(dateCollections[i]["lieuxCreneaux"])
          ..addAll(getDatelieuxCreneaux2(date, lieu));
        return true;
      }
    }
    return false;
  }

  getDatelieuxCreneaux(Date date, Lieu lieu) {
    List lieuxCreneaux = [];

    if (!lieuxCreneaux
        .contains({"creneauHeures": date.creneauHeures, "lieu": lieu})) {
      lieuxCreneaux.add({"creneauHeures": date.creneauHeures, "lieu": lieu});
    }

    return lieuxCreneaux;
  }

  getDatelieuxCreneaux2(CreneauDate date, Lieu lieu) {
    List lieuxCreneaux = [];

    if (!lieuxCreneaux.contains({
      "creneauHeures": date.creneauHeures,
      "creneauHeuresWeekend": date.creneauHeuresWeek,
      "lieu": lieu
    })) {
      lieuxCreneaux.add({
        "creneauHeures": date.creneauHeures,
        "creneauHeuresWeekend": date.creneauHeuresWeek,
        "lieu": lieu
      });
    }

    return lieuxCreneaux;
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
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: Device.getDiviseScreenHeight(context, 2),
                width: Device.getDiviseScreenWidth(context, 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Provider.of<AppManagerProvider>(context, listen: true)
                          .currentEvent
                          .image
                          .isNotEmpty
                      ? Image.memory(
                          base64Decode(Provider.of<AppManagerProvider>(context,
                                  listen: true)
                              .currentEvent
                              .image),
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
                          height: Device.getDiviseScreenHeight(context, 10),
                          width: Device.getDiviseScreenHeight(context, 10),
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
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Device.getDiviseScreenHeight(context, 10)),
                            color: Colors.grey.shade300.withOpacity(0.5),
                            child: SizedBox(
                              height: Device.getDiviseScreenHeight(context, 2) -
                                  Device.getDiviseScreenHeight(context, 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.memory(
                                    base64Decode(
                                        Provider.of<AppManagerProvider>(context,
                                                listen: true)
                                            .currentEvent
                                            .image),
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
                icon: Icon(Icons.arrow_back, color: AppColorProvider().white),
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
                  Provider.of<AppColorProvider>(context, listen: true).darkMode
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
                    color: Provider.of<AppColorProvider>(context, listen: true)
                        .white),
              ),
              // actions: [getPopupMenu(event)],
            ),
            body: Consumer<AppColorProvider>(
                builder: (context, appColorProvider, child) {
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
                            top: Device.getDiviseScreenHeight(context, 90),
                            left: Device.getDiviseScreenWidth(context, 20),
                            right: Device.getDiviseScreenWidth(context, 20)),
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
                                  color: Provider.of<AppColorProvider>(context,
                                              listen: true)
                                          .darkMode
                                      ? Color.fromARGB(255, 58, 58, 58)
                                      : Color.fromARGB(255, 224, 224, 224),
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
                            RichText(
                              text: TextSpan(
                                text: 'Organisateur  ',
                                style: GoogleFonts.poppins(
                                  color: appColorProvider.black87,
                                  fontSize: AppText.p6(context),
                                ),
                                children: [
                                  // TextSpan(
                                  //     text: Provider.of<AppManagerProvider>(
                                  //             context,
                                  //             listen: true)
                                  //         .currentEvent
                                  //         .auteur
                                  //         .nom,
                                  //     style: TextStyle(
                                  //         color: appColorProvider.primaryColor))
                                ],
                              ),
                            ),
                            const Gap(10),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10000)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: MemoryImage(base64Decode(
                                        Provider.of<AppManagerProvider>(context,
                                                listen: true)
                                            .currentEvent
                                            .image)),
                                    fit: BoxFit.cover,
                                  )),
                                  height:
                                      Device.getDiviseScreenHeight(context, 15),
                                  width:
                                      Device.getDiviseScreenHeight(context, 15),
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
                                  color: appColorProvider.black45,
                                ),
                              ),
                              trailing: Icon(
                                Icons.check_circle,
                                color: appColorProvider.primary,
                              ),
                            ),
                            const Gap(5),
                            const Divider(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Device.getDiviseScreenHeight(
                                      context, 100),
                                  vertical: Device.getDiviseScreenHeight(
                                      context, 50)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // InkWell(
                                  //   onTap: () {
                                  //     Likecontroller.currentState!.onTap();
                                  //     event.isLike = !event.isLike;
                                  //     event.isDislike = !event.isDislike;
                                  //     addLike(event);
                                  //     Timer(const Duration(seconds: 1), () {
                                  //       setState(() {});
                                  //     });
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       LikeButton(
                                  //         key: Likecontroller,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.end,
                                  //         size: Device.getDiviseScreenWidth(
                                  //             context, 27),
                                  //         // ignore: prefer_const_constructors
                                  //         circleColor: CircleColor(
                                  //             start: const Color.fromARGB(
                                  //                 255, 255, 0, 157),
                                  //             end: const Color.fromARGB(
                                  //                 255, 204, 0, 61)),
                                  //         bubblesColor: const BubblesColor(
                                  //           dotPrimaryColor: Color.fromARGB(
                                  //               255, 229, 51, 205),
                                  //           dotSecondaryColor:
                                  //               Color.fromARGB(255, 204, 0, 95),
                                  //         ),
                                  //         isLiked: event.isLike,

                                  //         likeBuilder: (bool isLiked) {
                                  //           return Center(
                                  //             child: Icon(
                                  //               LineIcons.thumbsUp,
                                  //               color: event.isLike
                                  //                   ? appColorProvider.primary
                                  //                   : appColorProvider.black38,
                                  //               size: 20,
                                  //             ),
                                  //           );
                                  //         },
                                  //       ),
                                  //       const Gap(5),
                                  //       Text(
                                  //         '${event.like}',
                                  //         style: GoogleFonts.poppins(
                                  //           fontSize: AppText.p2(context),
                                  //           fontWeight: FontWeight.w800,
                                  //           color: appColorProvider.black87,
                                  //         ),
                                  //       ),
                                  //       Text(
                                  //         "J'aimes",
                                  //         style: GoogleFonts.poppins(
                                  //           fontSize: AppText.p4(context),
                                  //           fontWeight: FontWeight.w400,
                                  //           color: appColorProvider.black54,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     disLikecontroller.currentState!.onTap();
                                  //     event.isDislike = !event.isDislike;
                                  //     event.isLike = !event.isLike;
                                  //     addDisLike(event);
                                  //     Timer(const Duration(seconds: 1), () {
                                  //       setState(() {});
                                  //     });
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       LikeButton(
                                  //         key: disLikecontroller,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.end,
                                  //         size: Device.getDiviseScreenWidth(
                                  //             context, 27),
                                  //         // ignore: prefer_const_constructors
                                  //         circleColor: CircleColor(
                                  //             start: Color.fromARGB(
                                  //                 255, 0, 119, 255),
                                  //             end: Color.fromARGB(
                                  //                 255, 0, 37, 204)),
                                  //         bubblesColor: const BubblesColor(
                                  //           dotPrimaryColor: Color.fromARGB(
                                  //               255, 51, 84, 229),
                                  //           dotSecondaryColor: Color.fromARGB(
                                  //               255, 0, 129, 204),
                                  //         ),
                                  //         isLiked: event.isDislike,
                                  //         likeBuilder: (bool isLiked) {
                                  //           return Center(
                                  //             child: Icon(
                                  //               LineIcons.thumbsDown,
                                  //               color: event.isDislike
                                  //                   ? Colors.blue
                                  //                   : appColorProvider.black38,
                                  //               size: 20,
                                  //             ),
                                  //           );
                                  //         },
                                  //       ),
                                  //       const Gap(5),
                                  //       Text(
                                  //         '${event.dislike}',
                                  //         style: GoogleFonts.poppins(
                                  //           fontSize: AppText.p2(context),
                                  //           fontWeight: FontWeight.w800,
                                  //           color: appColorProvider.black,
                                  //         ),
                                  //       ),
                                  //       Text(
                                  //         "Je n'aimes pas",
                                  //         style: GoogleFonts.poppins(
                                  //           fontSize: AppText.p4(context),
                                  //           fontWeight: FontWeight.w400,
                                  //           color: appColorProvider.black54,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      favoriscontroller.currentState!.onTap();
                                      print(event.favoris);
                                      event.isLike = !event.isLike;
                                      UserDBcontroller()
                                          .liste()
                                          .then((value) async {
                                        if (event.isLike) {
                                          event.setFavoris(event.favoris + 1);

                                          await modifyFavoris(
                                              event.id, event.favoris);
                                          setState(
                                            () {
                                              currentEventFavoris++;
                                            },
                                          );
                                        } else {
                                          event.setFavoris(event.favoris - 1);
                                          await modifyFavoris(
                                              event.id, event.favoris);
                                          setState(
                                            () {
                                              currentEventFavoris--;
                                            },
                                          );
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        LikeButton(
                                          key: favoriscontroller,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          size: Device.getDiviseScreenWidth(
                                              context, 27),
                                          // ignore: prefer_const_constructors
                                          circleColor: CircleColor(
                                              start: const Color.fromARGB(
                                                  255, 255, 0, 157),
                                              end: const Color.fromARGB(
                                                  255, 204, 0, 61)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color.fromARGB(
                                                255, 229, 51, 205),
                                            dotSecondaryColor:
                                                Color.fromARGB(255, 204, 0, 95),
                                          ),
                                          isLiked: event.isLike,
                                          likeBuilder: (bool isLiked) {
                                            event.isLike = isLiked;
                                            return Center(
                                              child: Icon(
                                                LineIcons.heart,
                                                color: event.isLike
                                                    ? Colors.red
                                                    : appColorProvider.black38,
                                                size: 20,
                                              ),
                                            );
                                          },
                                        ),
                                        const Gap(5),
                                        Text(
                                          '$currentEventFavoris',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.w800,
                                            color: appColorProvider.black,
                                          ),
                                        ),
                                        Text(
                                          "Favoris",
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p4(context),
                                            fontWeight: FontWeight.w400,
                                            color: appColorProvider.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      sharecontroller.currentState!.onTap();
                                      // addLike(event);
                                      Share.share(
                                        """COUCOU… 😊
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
                                            "CIBLE, Ayez une longueur d'avance !",
                                      );
                                      Timer(
                                        const Duration(seconds: 2),
                                        () {
                                          setState(
                                            () {
                                              event.share++;
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        LikeButton(
                                          key: sharecontroller,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          size: Device.getDiviseScreenWidth(
                                              context, 27),
                                          // ignore: prefer_const_constructors
                                          circleColor: CircleColor(
                                              start: Color.fromARGB(
                                                  255, 0, 255, 255),
                                              end: Color.fromARGB(
                                                  255, 0, 204, 109)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor:
                                                Color.fromARGB(255, 2, 172, 67),
                                            dotSecondaryColor:
                                                Color.fromARGB(255, 2, 116, 49),
                                          ),
                                          isLiked: event.isShare,
                                          likeBuilder: (bool isLiked) {
                                            event.isShare = isLiked;
                                            return Center(
                                              child: Icon(
                                                Icons.share,
                                                color: event.isShare
                                                    ? Colors.green
                                                    : appColorProvider.black38,
                                                size: 20,
                                              ),
                                            );
                                          },
                                        ),
                                        const Gap(5),
                                        Text(
                                          '${event.share}',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.w800,
                                            color: appColorProvider.black,
                                          ),
                                        ),
                                        Text(
                                          "Partages",
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p4(context),
                                            fontWeight: FontWeight.w400,
                                            color: appColorProvider.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Gap(Provider.of<AppManagerProvider>(context,
                                            listen: true)
                                        .currentEvent
                                        .isActive ==
                                    1
                                ? 10
                                : 0),
                            Text(
                              '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.pays} | ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.ville}',
                              style: GoogleFonts.poppins(
                                fontSize: AppText.p4(context),
                                color: appColorProvider.black87,
                              ),
                            ),
                            const Gap(10),
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
                                      const Gap(5),
                                      Text(
                                        '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.description}',
                                        style: GoogleFonts.poppins(
                                          fontSize: AppText.p4(context),
                                          color: appColorProvider.black87,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            const Gap(20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: getCategorieIsMultiple(
                                      Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .categorie
                                          .code)
                                  ? getDates2()
                                  : getDates(),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: Device.getDiviseScreenWidth(context, 30),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: getCategorieIsMultiple(
                                      Provider.of<AppManagerProvider>(context,
                                              listen: true)
                                          .currentEvent
                                          .categorie
                                          .code)
                                  ? particularActive
                                      ? getCreneauxLieuxPart()
                                      : getCreneauxLieux2()
                                  : getCreneauxLieux(),
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tickets',
                                  style: GoogleFonts.poppins(
                                    fontSize: AppText.p3(context),
                                    fontWeight: FontWeight.w800,
                                    color: appColorProvider.black,
                                  ),
                                ),
                                const Gap(10),
                                getTickes(event.id)
                              ],
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
                                        "Conditions de l'évènnement",
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
                                    .roles[0]
                                    .acteurs[0]
                                    .nom
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
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: getRoles()),
                                      ),
                                      const Gap(15),
                                      getArtiste(activeRole),
                                      const Gap(30),
                                    ],
                                  )
                                : SizedBox(),
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

  getTickes(int eventId) {
    // getTickes(int eventId) async {
    // List tickets = await getTicketsList(eventId);

    // print('tickets');
    // print(tickets);

    List<Widget> listtickets = [];
    for (var i = 0;
        i <
            Provider.of<AppManagerProvider>(context, listen: true)
                .currentEvent
                .tickets
                .length;
        i++) {
      listtickets.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: appColorProvider.black12),
                  borderRadius: BorderRadius.all(Radius.circular(
                      Device.getDiviseScreenHeight(context, 150)))),
              padding:
                  EdgeInsets.all(Device.getDiviseScreenHeight(context, 100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: appColorProvider.primaryColor5,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            Provider.of<AppManagerProvider>(context,
                                    listen: true)
                                .currentEvent
                                .tickets[i]
                                .libelle,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: appColorProvider.primaryColor2,
                              fontSize: AppText.p4(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          color: appColorProvider.primaryColor3,
                          height: 20,
                          width: 1,
                        ),
                        Expanded(
                          child: Text(
                            '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].prix} FCFA',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: AppText.p4(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          color: appColorProvider.primaryColor3,
                          height: 20,
                          width: 1,
                        ),
                        Expanded(
                          child: Text(
                            '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].nombrePlaces} Tickets',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              fontSize: AppText.p4(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(7),
                  Text(
                    Provider.of<AppManagerProvider>(context, listen: true)
                        .currentEvent
                        .tickets[i]
                        .description,
                    style: GoogleFonts.poppins(
                      fontSize: AppText.p4(context),
                      fontWeight: FontWeight.w400,
                      color: appColorProvider.black87,
                    ),
                  ),
                  const Gap(5),
                  getTicketParticular(i),
                  const Gap(5),
                  Provider.of<AppManagerProvider>(context, listen: true)
                              .currentEvent
                              .tickets[i]
                              .promo1["pourcentage"] !=
                          null
                      ? Text(
                          '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["pourcentage"]} % de reduction aux ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["nbreMax"]} premiers acheteurs',
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p3(context),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                  const Gap(5),
                  Provider.of<AppManagerProvider>(context, listen: true)
                              .currentEvent
                              .tickets[i]
                              .promo2["pourcentage"] !=
                          null
                      ? Text(
                          '${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo2["pourcentage"]} % de reduction pour ${Provider.of<AppManagerProvider>(context, listen: true).currentEvent.tickets[i].promo1["nbreMin"]} achetés',
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p3(context),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            SizedBox(height: Device.getScreenHeight(context) / 100),
          ],
        );
      }));
    }
    return Column(children: listtickets);
  }

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
          child: Text(
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
    List<Widget> listDates = [];
    print('date ${dateCollections[0]['date'].toMap()}');
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
    List<Widget> listDates = [];
    List<Widget> listDatesPart = [];

    for (var i = 0; i < dateCollections.length; i++) {
      List date = dateCollections[i]['creneauDate'].dateDebut.split(' ');
      List date1 = dateCollections[i]['creneauDate'].dateFin.split(' ');
      listDates.add(Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              particularActive = false;
              activeDate = i;
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
            decoration: activeDate == i && !particularActive
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
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${'${date[0]}'.substring(0, 3).toUpperCase()}.',
                      style: GoogleFonts.poppins(
                          color: activeDate == i && !particularActive
                              ? Colors.white
                              : appColorProvider.primary,
                          fontSize: AppText.p6(context),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${date[1]}'.toUpperCase(),
                        style: GoogleFonts.poppins(
                            color: activeDate == i && !particularActive
                                ? Colors.white
                                : appColorProvider.primary,
                            fontSize: AppText.titre4(context),
                            fontWeight: FontWeight.w800)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${'${date[2]}'.substring(0, 3).toUpperCase()}.',
                      style: GoogleFonts.poppins(
                          color: activeDate == i && !particularActive
                              ? Colors.white
                              : appColorProvider.primary,
                          fontSize: AppText.p6(context),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 2,
                  decoration: activeDate == i && !particularActive
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(
                              Device.getDiviseScreenHeight(context, 150))))
                      : BoxDecoration(
                          color: appColorProvider.primary,
                        ),
                ),
                Column(
                  children: [
                    Text(
                      '${date1[0]}'.isNotEmpty
                          ? '${'${date1[0]}'.substring(0, 3).toUpperCase()}.'
                          : '',
                      style: GoogleFonts.poppins(
                          color: activeDate == i && !particularActive
                              ? Colors.white
                              : appColorProvider.primary,
                          fontSize: AppText.p6(context),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${date1[1]}'.toUpperCase(),
                        style: GoogleFonts.poppins(
                            color: activeDate == i && !particularActive
                                ? Colors.white
                                : appColorProvider.primary,
                            fontSize: AppText.titre4(context),
                            fontWeight: FontWeight.w800)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${'${date1[2]}'.substring(0, 3).toUpperCase()}.',
                      style: GoogleFonts.poppins(
                          color: activeDate == i && !particularActive
                              ? Colors.white
                              : appColorProvider.primary,
                          fontSize: AppText.p6(context),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                        fontSize: AppText.p6(context),
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
    List<Widget> listDates = [];
    for (var i = 0;
        i < dateCollections[activeDate]['lieuxCreneaux'].length;
        i++) {
      print(dateCollections[activeDate]['lieuxCreneaux'][i]);
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
                  fontSize: AppText.p6(context),
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
                  fontSize: AppText.p6(context),
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
          ],
        );
      }));
    }
    return Column(children: listDates);
  }

  getCreneauxLieux2Week(i) {
    List<Widget> listDates = [];
    for (var j = 0;
        j <
            dateCollections[activeDate]['lieuxCreneaux'][i]
                    ['creneauHeuresWeekend']
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
