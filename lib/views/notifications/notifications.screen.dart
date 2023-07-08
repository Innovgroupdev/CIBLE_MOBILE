import 'package:cible/models/notification.dart';
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
    NotificationDBcontroller().liste().then((value) {
      setState(() {
        notifs = value as List;
        for(var i in notifs){
        }
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
          foregroundColor: appColorProvider.black54,
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
        body: 
              notifs != null?
                Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration:
                                BoxDecoration(color: appColorProvider.primary),
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
                                InkWell(
                                    onTap: () {},
                                    child: const Icon(Icons.search))
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          // scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: notifs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var etat = notifs[index].etat;
                                            var isExpanded = false;
                                            return InkWell(
                                              onTap: (() async {
                                                // showDialog<void>(
                                                //   context: context,
                                                //   barrierDismissible: true,
                                                //   builder:
                                                //       (BuildContext context) {
                                                //     return Center(
                                                //       child: ClipRRect(
                                                //         borderRadius: BorderRadius
                                                //             .circular(Device
                                                //                     .getScreenHeight(
                                                //                         context) /
                                                //                 70),
                                                //         child: Container(
                                                //           height: Device
                                                //               .getDiviseScreenHeight(
                                                //                   context, 3),
                                                //           width: Device
                                                //               .getDiviseScreenWidth(
                                                //                   context, 1.2),
                                                //           color: Provider.of<
                                                //                       AppColorProvider>(
                                                //                   context,
                                                //                   listen: false)
                                                //               .white,
                                                //           padding: EdgeInsets.symmetric(
                                                //               horizontal: Device
                                                //                       .getScreenWidth(
                                                //                           context) /
                                                //                   30,
                                                //               vertical: Device
                                                //                       .getScreenHeight(
                                                //                           context) /
                                                //                   50),
                                                //           child: Column(
                                                //             mainAxisAlignment:
                                                //                 MainAxisAlignment
                                                //                     .spaceEvenly,
                                                //             children: [
                                                //               SizedBox(
                                                //                 height: Device
                                                //                         .getScreenHeight(
                                                //                             context) /
                                                //                     60,
                                                //               ),
                                                //               Text(
                                                //                 '${notifs[index].titre}',
                                                //                 textAlign:
                                                //                     TextAlign
                                                //                         .center,
                                                //                 style: GoogleFonts.poppins(
                                                //                     textStyle: Theme.of(
                                                //                             context)
                                                //                         .textTheme
                                                //                         .bodyLarge,
                                                //                     fontSize:
                                                //                         AppText.p3(
                                                //                             context),
                                                //                     color: Provider.of<AppColorProvider>(
                                                //                             context,
                                                //                             listen:
                                                //                                 false)
                                                //                         .black38),
                                                //               ),
                                                //               SizedBox(
                                                //                 height: Device
                                                //                         .getScreenHeight(
                                                //                             context) /
                                                //                     40,
                                                //               ),
                                                //               Text(
                                                //                 '${notifs[index].description}',
                                                //                 textAlign:
                                                //                     TextAlign
                                                //                         .center,
                                                //                 style: GoogleFonts.poppins(
                                                //                     textStyle: Theme.of(
                                                //                             context)
                                                //                         .textTheme
                                                //                         .bodyLarge,
                                                //                     fontSize:
                                                //                         AppText.p3(
                                                //                             context),
                                                //                     color: Provider.of<AppColorProvider>(
                                                //                             context,
                                                //                             listen:
                                                //                                 false)
                                                //                         .black38),
                                                //               ),
                                                //               SizedBox(
                                                //                 height: Device
                                                //                         .getScreenHeight(
                                                //                             context) /
                                                //                     40,
                                                //               ),
                                                //               Row(
                                                //                 mainAxisAlignment:
                                                //                     MainAxisAlignment
                                                //                         .end,
                                                //                 children: [
                                                //                   Expanded(
                                                //                     child:
                                                //                         RaisedButtonDecor(
                                                //                       onPressed:
                                                //                           () async {
                                                //                         notifs[index].etat =
                                                //                             true;
                                                //                             var index1 = index;
                                                //                         // await NotificationDBcontroller()
                                                //                         //     .delete(notifs[index]);
                                                                        
                                                //                         await NotificationDBcontroller().update(notifs[index]);
                                                //                         // await NotificationDBcontroller().insert(NotificationModel(
                                                //                         //     notifs[index1].id+1,
                                                //                         //     'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
                                                //                         //     'titre${notifs[index1].id+1}',
                                                //                         //     'description${notifs[index1].id+1}',
                                                //                         //     'type${notifs[index1].id+1}',
                                                //                         //     false));
                                                //                         setState(
                                                //                             () {
                                                //                           etat =
                                                //                               true;
                                                //                           NotificationDBcontroller()
                                                //                               .liste()
                                                //                               .then((value) {
                                                //                             notifs =
                                                //                                 value as List;
                                                //                           });
                                                //                         });
                                                //                         Navigator.pop(
                                                //                             context);
                                                //                       },
                                                //                       elevation:
                                                //                           3,
                                                //                       color: Provider.of<AppColorProvider>(
                                                //                               context,
                                                //                               listen: false)
                                                //                           .primaryColor,
                                                //                       shape: BorderRadius
                                                //                           .circular(
                                                //                               10),
                                                //                       padding:
                                                //                           const EdgeInsets.all(
                                                //                               15),
                                                //                       child:
                                                //                           Text(
                                                //                         "Ok",
                                                //                         style: GoogleFonts.poppins(
                                                //                             color:
                                                //                                 Colors.white,
                                                //                             fontSize: AppText.p2(context)),
                                                //                       ),
                                                //                     ),
                                                //                   ),
                                                //                 ],
                                                //               )
                                                //             ],
                                                //           ),
                                                //         ),
                                                //       ),
                                                //     );
                                                //   },
                                                // );
                                              
                                              }),
                                              child: StatefulBuilder(
                                                builder: (context,setState1) {
                                                  return ExpansionPanelList(
                                                    expansionCallback:(index,expanded){
                                                      setState1(() {
                                                        isExpanded =! isExpanded;
                                                      });
                                                    },
                                                    children: [
                                                      ExpansionPanel(
                                                      isExpanded : isExpanded,
                                                      canTapOnHeader : false,
                                                        headerBuilder: (context,expanded){
                                                            return   Column(
                                                              children: [
                                                                Container(
                                                          decoration:
                                                                  !notifs[index].etat
                                                                      ? BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      10),
                                                                          color:
                                                                              appColorProvider
                                                                                  .blue2,
                                                                        )
                                                                      : null,
                                                          child: ListTile(
                                                                leading: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height: 40,
                                                                      width: 40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    10000),
                                                                        color:
                                                                            appColorProvider
                                                                                .blue10,
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          'A',
                                                                          style:
                                                                              GoogleFonts
                                                                                  .poppins(
                                                                            fontSize:
                                                                                AppText.p3(
                                                                                    context),
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w800,
                                                                            color:
                                                                                appColorProvider
                                                                                    .white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                title: Text(
                                                                  "${notifs[index].titre}",
                                                                  textAlign:
                                                                      TextAlign.start,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge,
                                                                      fontSize:
                                                                          AppText.p2(
                                                                              context),
                                                                      fontWeight:
                                                                          FontWeight.w800,
                                                                      color:
                                                                          appColorProvider
                                                                              .black54),
                                                                ),
                                                                subtitle: Text(
                                                                  "${notifs[index].description}",
                                                                  textAlign:
                                                                      TextAlign.start,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge,
                                                                      fontSize:
                                                                          AppText.p4(
                                                                              context),
                                                                      fontWeight:
                                                                          FontWeight.w400,
                                                                      color:
                                                                          appColorProvider
                                                                              .black38),
                                                                ),
                                                                trailing: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      '12h48mn',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: Theme.of(
                                                                                  context)
                                                                              .textTheme
                                                                              .bodyLarge,
                                                                          fontSize:
                                                                              AppText.p4(
                                                                                  context),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color:
                                                                              appColorProvider
                                                                                  .black38),
                                                                    ),
                                                                  ],
                                                                ),
                                                          ),
                                                        ),
                                                              const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 2,
                                                        color:
                                                            appColorProvider.grey3,
                                                      )
                                                              ],
                                                            );
                                                        },
                                                        body: Text('eeee')
                                                      ),
                                                      
                                                    ],
                                                  );
                                                }
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          // scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: notifs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: (() {}),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10000),
                                                            color:
                                                                appColorProvider
                                                                    .primary,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'R',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    AppText.p3(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    appColorProvider
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    title: Text(
                                                      "Vous avez rechargé votre compte",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                          fontSize: AppText.p2(
                                                              context),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              appColorProvider
                                                                  .black54),
                                                    ),
                                                    subtitle: Text(
                                                      "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                          fontSize: AppText.p4(
                                                              context),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              appColorProvider
                                                                  .black38),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '12h48mn',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                              fontSize:
                                                                  AppText.p4(
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  appColorProvider
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
                                                    color:
                                                        appColorProvider.grey3,
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          // scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: notifs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: (() {}),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10000),
                                                            color: appColorProvider
                                                                .categoriesColor(
                                                                    0),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'S',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    AppText.p3(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    appColorProvider
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    title: Text(
                                                      "Vous avez rechargé votre compte",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                          fontSize: AppText.p2(
                                                              context),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              appColorProvider
                                                                  .black54),
                                                    ),
                                                    subtitle: Text(
                                                      "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                          fontSize: AppText.p4(
                                                              context),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              appColorProvider
                                                                  .black38),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '12h48mn',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                              fontSize:
                                                                  AppText.p4(
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  appColorProvider
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
                                                    color:
                                                        appColorProvider.grey3,
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
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenHeight(context, 50)),
                          child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Container(
                                        height: 55,
                                        width: 55,
                                        child: photoProfil(
                                            context,
                                            appColorProvider.primaryColor4,
                                            100)),
                                  ),
                                ],
                              ),
                              title: Text(
                                "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p1(context),
                                    fontWeight: FontWeight.w800,
                                    color: Provider.of<AppColorProvider>(
                                            context,
                                            listen: false)
                                        .black54),
                              ),
                              subtitle: Text(
                                "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p4(context),
                                    fontWeight: FontWeight.w400,
                                    color: Provider.of<AppColorProvider>(
                                            context,
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
                )
              :
                Container(
                  color: appColorProvider.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
      );
    });
  }
}
