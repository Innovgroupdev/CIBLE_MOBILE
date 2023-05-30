import 'package:cible/views/notifications/notifications.controller.dart';
import 'package:flutter/material.dart';

import '../../database/notificationDBcontroller.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badge;

import '../../widgets/raisedButtonDecor.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  dynamic notifs;
  @override
  void initState() {
    // TODO: implement initState
    //insertNotification();
    NotificationDBcontroller().insert().then((value) {
      NotificationDBcontroller().liste().then((value) {
        setState(() {
          notifs = value as List;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.sort,
            size: 40,
            color: appColorProvider.black87,
          ),
          elevation: 0,
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(
                    //     context, "/moncompte");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: badge.Badge(
                      badgeContent: Consumer<DefaultUserProvider>(
                          builder: (context, Panier, child) {
                        return Text(
                          notifs.length.toString(),
                          //'3',
                          style: TextStyle(color: appColorProvider.white),
                        );
                      }),
                      toAnimate: true,
                      shape: badge.BadgeShape.circle,
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        LineIcons.bell,
                        size: AppText.titre1(context),
                        color: appColorProvider.black87,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: appColorProvider.primary),
                  ),
                  SizedBox(
                    height: Device.getScreenHeight(context) / 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'NOTIFICATIONS(',
                                style: GoogleFonts.poppins(
                                  color: appColorProvider.black38,
                                  fontSize: AppText.p4(context),
                                ),
                              ),
                              TextSpan(
                                text: '123',
                                style: GoogleFonts.poppins(
                                  color: appColorProvider.primary,
                                  fontSize: AppText.p4(context),
                                ),
                              ),
                              TextSpan(
                                text: ')',
                                style: GoogleFonts.poppins(
                                  color: appColorProvider.black38,
                                  fontSize: AppText.p4(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(onTap: () {}, child: const Icon(Icons.search))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Hier",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.black38,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: (() {}),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10000),
                                                    color:
                                                        appColorProvider.blue10,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'A',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: appColorProvider
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            title: Text(
                                              "Achat de tickets pour le concert de GIMS",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      appColorProvider.black54),
                                            ),
                                            subtitle: Text(
                                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      appColorProvider.black38),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '12h48mn',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p4(context),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: appColorProvider
                                                          .black38),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 2,
                                            color: appColorProvider.grey3,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "2022-03-01",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.black38,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: (() {}),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10000),
                                                    color: appColorProvider
                                                        .primary,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'R',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: appColorProvider
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            title: Text(
                                              "Vous avez rechargé votre compte",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      appColorProvider.black54),
                                            ),
                                            subtitle: Text(
                                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      appColorProvider.black38),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '12h48mn',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p4(context),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: appColorProvider
                                                          .black38),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 2,
                                            color: appColorProvider.grey3,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "2022-02-25",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: appColorProvider.black38,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: (() {}),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10000),
                                                    color: appColorProvider
                                                        .categoriesColor(0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'S',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: appColorProvider
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            title: Text(
                                              "Vous avez rechargé votre compte",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p2(context),
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      appColorProvider.black54),
                                            ),
                                            subtitle: Text(
                                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      appColorProvider.black38),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '12h48mn',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge,
                                                      fontSize:
                                                          AppText.p4(context),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: appColorProvider
                                                          .black38),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 2,
                                            color: appColorProvider.grey3,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: appColorProvider.white,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Device.getDiviseScreenWidth(context, 30),
                      vertical: Device.getDiviseScreenHeight(context, 50)),
                  child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Container(
                                height: 55,
                                width: 55,
                                child: photoProfil(context,
                                    appColorProvider.primaryColor4, 100)),
                          ),
                        ],
                      ),
                      title: Text(
                        "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                        style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontSize: AppText.p1(context),
                            fontWeight: FontWeight.w800,
                            color: Provider.of<AppColorProvider>(context,
                                    listen: false)
                                .black54),
                      ),
                      subtitle: Text(
                        "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                        style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontSize: AppText.p4(context),
                            fontWeight: FontWeight.w400,
                            color: Provider.of<AppColorProvider>(context,
                                    listen: false)
                                .black38),
                      ),
                      trailing: SizedBox()),
                  // ListTile(
                  //   leading:
                  // Hero(
                  //     tag: 'Image_Profile',
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10),
                  //       child: Container(
                  //           padding: EdgeInsets.all(10),
                  //           height: 100,
                  //           width: 100,
                  //           child: photoProfil(
                  //               context, appColorProvider.primaryColor4, 100)),
                  //     ),
                  //   ),
                  //   title:
                  // Text(
                  //     "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.poppins(
                  //         textStyle: Theme.of(context).textTheme.bodyLarge,
                  //         fontSize: AppText.p1(context),
                  //         fontWeight: FontWeight.w800,
                  //         color: Provider.of<AppColorProvider>(context,
                  //                 listen: false)
                  //             .black54),
                  //   ),
                  //   subtitle:
                  // Text(
                  //     "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.poppins(
                  //         textStyle: Theme.of(context).textTheme.bodyLarge,
                  //         fontSize: AppText.p4(context),
                  //         fontWeight: FontWeight.w400,
                  //         color: Provider.of<AppColorProvider>(context,
                  //                 listen: false)
                  //             .black38),
                  //   ),
                  //   trailing: SizedBox(),
                  // ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
