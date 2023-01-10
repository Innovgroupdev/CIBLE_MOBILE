import 'dart:convert';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:gap/gap.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketCart.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<TicketCart> tickets = [];
  double total = 0;
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  @override
  Widget build(BuildContext context) {
    setState(() {
      tickets = Provider.of<TicketProvider>(context).ticketsList;
      total = Provider.of<TicketProvider>(context).total;
    });
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return WillPopScope(
        onWillPop: () {
          Provider.of<AppManagerProvider>(context, listen: false).userTemp = {};
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: appColorProvider.grey2,
          appBar: AppBar(
            backgroundColor: appColorProvider.grey2,
            elevation: 0,
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back),
            //   color: appColorProvider.black54,
            //   onPressed: () {
            //     Provider.of<AppManagerProvider>(context, listen: false)
            //         .userTemp = {};
            //     Navigator.pop(context);
            //   },
            // ),
            centerTitle: true,
            title: Text(
              "Mes Tickets",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 30),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TICKETS (${tickets.length})',
                        style: TextStyle(
                          color: appColorProvider.black54,
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: AppText.p1(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tickets.length,
                    itemBuilder: (context, i) {
                      bool isShowed = false;
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: Device.getDiviseScreenHeight(context, 300),
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    Device.getDiviseScreenWidth(context, 30),
                                vertical:
                                    Device.getDiviseScreenWidth(context, 30),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // QrImage(
                                  //   data:
                                  //       '${tickets[i].ticket.libelle} ${tickets[i].event.titre}',
                                  //   size: 250,
                                  // ),
                                  // const Gap(20),
                                  Text(
                                    tickets[i].ticket.libelle,
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.titre4(context),
                                      fontWeight: FontWeight.bold,
                                      color: appColorProvider.primaryColor1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          child: Container(
                                            width: Device.getDiviseScreenWidth(
                                                context, 3.5),
                                            height:
                                                Device.getDiviseScreenHeight(
                                                    context, 10),
                                            color:
                                                appColorProvider.primaryColor3,
                                            child: Stack(
                                              children: [
                                                Image.memory(
                                                  width: Device
                                                      .getDiviseScreenWidth(
                                                          context, 3.5),
                                                  height: Device
                                                      .getDiviseScreenHeight(
                                                          context, 7),
                                                  fit: BoxFit.fill,
                                                  base64Decode(
                                                      tickets[i].event.image),
                                                ),
                                                ClipRect(
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 3.0,
                                                        sigmaY: 3.0),
                                                    child: Container(
                                                      width: Device
                                                          .getDiviseScreenWidth(
                                                              context, 3.5),
                                                      height: Device
                                                          .getDiviseScreenHeight(
                                                              context, 7),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black45
                                                              .withOpacity(.3)),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Image.memory(
                                                    base64Decode(
                                                      tickets[i].event.image,
                                                    ),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(7),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(
                                                    fontSize:
                                                        AppText.p3(context),
                                                  ),
                                                  text: TextSpan(
                                                    style: GoogleFonts.poppins(
                                                      color: appColorProvider
                                                          .black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    text:
                                                        tickets[i].event.titre,
                                                  ),
                                                ),
                                                if (!isShowed)
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isShowed = true;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 10,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (isShowed)
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isShowed = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_forward_ios,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const Gap(5),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: StrutStyle(),
                                              text: TextSpan(
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      appColorProvider.black54,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                text: tickets[i]
                                                    .event
                                                    .lieux[0]
                                                    .valeur,
                                              ),
                                            ),
                                            const Gap(5),
                                            RichText(
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: StrutStyle(),
                                              text: TextSpan(
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      appColorProvider.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: AppText.p4(context),
                                                ),
                                                text: tickets[i]
                                                    .event
                                                    .lieux[0]
                                                    .dates[0]
                                                    .valeur
                                                    .toString(),
                                              ),
                                            ),
                                            const Gap(5),
                                            // ignore: dead_code
                                            if (isShowed)
                                              // ignore: dead_code
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColorProvider()
                                                              .primaryColor5,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 3.0,
                                                        horizontal: 3.0,
                                                      ),
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Voir Plus',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColorProvider()
                                                                .primaryColor1,
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColorProvider()
                                                              .primaryColor5,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 3.0,
                                                        horizontal: 3.0,
                                                      ),
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Effectuer une reclamation',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColorProvider()
                                                                .primaryColor1,
                                                        fontSize:
                                                            AppText.p3(context),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Gap(20),
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
      );
    });
  }
}
