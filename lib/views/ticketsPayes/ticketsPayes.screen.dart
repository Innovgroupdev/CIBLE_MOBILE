import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:flutter/material.dart';

import '../../database/notificationDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../../helpers/textHelper.dart';
import '../../models/tiketPaye.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/formWidget.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

import '../../widgets/raisedButtonDecor.dart';

class TicketsPayes extends StatefulWidget {
  TicketsPayes({required this.eventId,Key? key}) : super(key: key);
  int eventId;

  @override
  State<TicketsPayes> createState() => _TicketsPayesState();
}

class _TicketsPayesState extends State<TicketsPayes> {
  dynamic notifs;
  List<dynamic> typeTicket = ['PREMIUM', 'VIP'];
  List<TicketPaye>? ticketsPayes;

  @override
  void initState() {
    // TODO: implement initState
    getTicketspayesFromAPI();

    super.initState();
  }

  var token;

  getTicketsPayesFromMap(List ticketFromApi) {
    final List<TicketPaye> tagObjs = [];
    for (var element in ticketFromApi) {
      var ticket = TicketPaye.fromMap(element);

      tagObjs.add(ticket);
    }
    return tagObjs;
  }

  getTicketspayesFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/evenement/${widget.eventId}/userTickets'),/*hashwithtickets*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        if (jsonDecode(response.body)['message'] == "no data found") {
          ticketsPayes = [];
        } else {
          
          print('toutaaaaaaaaaaa'+response.body.toString());
          ticketsPayes =
              getTicketsPayesFromMap(jsonDecode(response.body)['data'] as List);
          ticketsPayes!.sort((a, b) {
            return DateTime.parse(b.dateCreation)
                .compareTo(DateTime.parse(a.dateCreation));
          });
        }
      });
      return ticketsPayes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor:
              Provider.of<AppColorProvider>(context, listen: false).black54,
          title: Text(
            "Tickets payés",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p1(context),
                fontWeight: FontWeight.w800,
                color: Provider.of<AppColorProvider>(context, listen: false)
                    .black54),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ticketsPayes == null?Container(child:Center(child: CircularProgressIndicator(),)):
            Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: appColorProvider.primary),
                  ),
                  SizedBox(
                    height: Device.getScreenHeight(context) / 8,
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
                                text: 'TICKETS(',
                                style: GoogleFonts.poppins(
                                  color: appColorProvider.black38,
                                  fontSize: AppText.p4(context),
                                ),
                              ),
                              TextSpan(
                                text: '${ticketsPayes!.length}',
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
                              const SizedBox(
                                height: 20,
                              ),
                              ticketsPayes == null
                                  ? Center(child: CircularProgressIndicator())
                                  : 
                                  ticketsPayes!.isEmpty?
        Center(child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: 350,
              width: 350,
                      child: Image.asset('assets/images/empty.png'),
                    ),
             const Text(
                            'Pas de tickets payés',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.primary,
                            ),
                          ),
          ],
        ),):
                                  Container(
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        // scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: ticketsPayes!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: ticketsPayes!.isNotEmpty
                                                    ? index == 0 ||
                                                            DateTime.parse(ticketsPayes![
                                                                            index -
                                                                                1]
                                                                        .dateCreation)
                                                                    .compareTo(DateTime.parse(
                                                                        ticketsPayes![index]
                                                                            .dateCreation)) ==
                                                                0
                                                        ? Text(
                                                            "${ticketsPayes![index].dateCreation.substring(0, 10)}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.poppins(
                                                                color:
                                                                    appColorProvider
                                                                        .black38,
                                                                fontSize:
                                                                    AppText.p4(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          )
                                                        : const SizedBox()
                                                    : const SizedBox(),
                                              ),
                                              InkWell(
                                                onTap: (() {}),
                                                child: ExpansionPanelList(
                                                    elevation: 0,
                                                    expansionCallback:
                                                        (int index1,
                                                            bool isExpanded) {
                                                      setState(() {
                                                        ticketsPayes![index]
                                                                .isexp =
                                                            !ticketsPayes![
                                                                    index]
                                                                .isexp;
                                                      });
                                                    },
                                                    children: [
                                                      ExpansionPanel(
                                                        isExpanded:
                                                            ticketsPayes![index]
                                                                .isexp,
                                                        headerBuilder:
                                                            (BuildContext
                                                                    context,
                                                                bool
                                                                    isExpanded) {
                                                          return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Ticket ${ticketsPayes![index].libelle} ",
                                                                    // 'Ticket VIP',
                                                                    style: GoogleFonts.poppins(
                                                                        color: appColorProvider
                                                                            .primaryColor1,
                                                                        fontSize:
                                                                            AppText.p3(
                                                                                context),
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                  ListTile(
                                                                    leading:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(1000),
                                                                          child: Image.memory(
                                                                              height: Device.getDiviseScreenHeight(context, 15),
                                                                              width: Device.getDiviseScreenHeight(context, 15),
                                                                              //ticketsPayes![index].events.image,
                                                                              base64Decode(ticketsPayes![index].events.image),
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    title: Text(
                                                                      '${ticketsPayes![index].titre}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge,
                                                                          fontSize: AppText.p2(
                                                                              context),
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          color:
                                                                              appColorProvider.black54),
                                                                    ),
                                                                    subtitle:
                                                                        Text(
                                                                      "${ticketsPayes![index].description}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          3,
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge,
                                                                          fontSize: AppText.p4(
                                                                              context),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              appColorProvider.black38),
                                                                    ),
                                                                  ),
                                                                  !isExpanded
                                                                      ? Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Text(
                                                                                '${ticketsPayes![index].dateCreation.substring(11, 13)}h${ticketsPayes![index].dateCreation.substring(14, 16)}min',
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge, fontSize: AppText.p4(context), fontWeight: FontWeight.w600, color: appColorProvider.black38),
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
                                                                        )
                                                                      : SizedBox()
                                                                ],
                                                              ));
                                                        },
                                                        body: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  ticketsPayes![index].codeQr == "no code qr associated"?
RaisedButtonDecor(
                                                                    onPressed:
                                                                        (() async {
                                                                      Navigator.pushNamed(context, "/payment");
                                                                    }),
                                                                    elevation:
                                                                        0,
                                                                    color: appColorProvider
                                                                        .blue2,
                                                                    shape: BorderRadius
                                                                        .circular(
                                                                            7),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                          child: Text(
                                                                            "Passer au payement",
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              color:
                                                                                  appColorProvider.blue10,
                                                                              fontSize:
                                                                                  AppText.p3(context),
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ):
                                                                  
                                                                  RaisedButtonDecor(
                                                                    onPressed:
                                                                        (() async {
                                                                      // var listTickets =
                                                                      //     [];
                                                                      // for (var tickets
                                                                      //     in ticketsPayes!) {
                                                                      //   if (tickets.eventId == ticketsPayes![index].eventId &&
                                                                      //       tickets.libelle ==
                                                                      //           ticketsPayes![index].libelle) {
                                                                      //     listTickets
                                                                      //         .add(tickets);
                                                                      //   }
                                                                      // }
                                                                      // await showDialog<
                                                                      //     void>(
                                                                      //   context:
                                                                      //       context,
                                                                      //   barrierDismissible:
                                                                      //       true, // user must tap button!
                                                                      //   builder:
                                                                      //       (BuildContext
                                                                      //           context) {
                                                                      //     return AlertDialog(
                                                                      //       content:
                                                                      //           Container(
                                                                      //         height: Device.getDiviseScreenHeight(context, 1.6),
                                                                      //         width: Device.getDiviseScreenWidth(context, 1.2),
                                                                      //         decoration: BoxDecoration(
                                                                      //           borderRadius: BorderRadius.circular(15),
                                                                      //           color: Colors.white,
                                                                      //         ),
                                                                      //         child: Center(
                                                                      //           child: Column(
                                                                      //             children: [
                                                                      //               RichText(
                                                                      //                 overflow: TextOverflow.clip,
                                                                      //                 text: TextSpan(
                                                                      //                   children: [
                                                                      //                     TextSpan(
                                                                      //                       text: 'Ticket ${ticketsPayes![index].libelle} ',
                                                                      //                       style: GoogleFonts.poppins(color: appColorProvider.primaryColor1, fontSize: AppText.p2(context), fontWeight: FontWeight.w800),
                                                                      //                     ),
                                                                      //                     TextSpan(
                                                                      //                       text: 'x${listTickets.length}',
                                                                      //                       style: GoogleFonts.poppins(color: appColorProvider.black, fontSize: AppText.p2(context), fontWeight: FontWeight.w800),
                                                                      //                     ),
                                                                      //                   ],
                                                                      //                 ),
                                                                      //               ),
                                                                      //               SizedBox(
                                                                      //                 height: Device.getScreenHeight(context) / 100,
                                                                      //               ),
                                                                      //               Text(
                                                                      //                 "${ticketsPayes![index].titre}",
                                                                      //                 textAlign: TextAlign.center,
                                                                      //                 overflow: TextOverflow.ellipsis,
                                                                      //                 style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge, fontSize: AppText.p3(context), fontWeight: FontWeight.w800, color: appColorProvider.black54),
                                                                      //               ),
                                                                      //               SizedBox(
                                                                      //                 height: Device.getScreenHeight(context) / 100,
                                                                      //               ),
                                                                      //               Padding(
                                                                      //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      //                 child: Text(
                                                                      //                   "${ticketsPayes![index].description}",
                                                                      //                   textAlign: TextAlign.center,
                                                                      //                   maxLines: 3,
                                                                      //                   overflow: TextOverflow.ellipsis,
                                                                      //                   style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge, fontSize: AppText.p4(context), fontWeight: FontWeight.w400, color: appColorProvider.black38),
                                                                      //                 ),
                                                                      //               ),
                                                                      //               SizedBox(
                                                                      //                 height: Device.getScreenHeight(context) / 50,
                                                                      //               ),
                                                                      //               Container(
                                                                      //                 height: Device.getScreenHeight(context) / 2.6,
                                                                      //                 child: StatefulBuilder(
                                                                      //                     builder: ((context, setState2) => Container(
                                                                      //                           child: ListView.builder(
                                                                      //                             physics: const BouncingScrollPhysics(),
                                                                      //                             shrinkWrap: true,
                                                                      //                             itemCount: listTickets.length,
                                                                      //                             itemBuilder: (BuildContext context, int indexS) {
                                                                      //                               return InkWell(
                                                                      //                                 onTap: (() {}),
                                                                      //                                 child: Column(
                                                                      //                                   children: [
                                                                      //                                     Row(
                                                                      //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      //                                       children: [
                                                                      //                                         Row(
                                                                      //                                           children: [
                                                                      //                                             Row(
                                                                      //                                               children: [
                                                                      //                                                 Checkbox(
                                                                      //                                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                      //                                                     value: listTickets[indexS].isSelected,
                                                                      //                                                     onChanged: (value) {
                                                                      //                                                       setState2(() {
                                                                      //                                                         listTickets[indexS].isSelected = !listTickets[indexS].isSelected;
                                                                      //                                                       });
                                                                      //                                                     }),
                                                                      //                                                 Container(
                                                                      //                                                   height: 40,
                                                                      //                                                   width: 40,
                                                                      //                                                   decoration: BoxDecoration(
                                                                      //                                                     borderRadius: BorderRadius.circular(10),
                                                                      //                                                     color: Colors.green,
                                                                      //                                                   ),
                                                                      //                                                   child: Center(
                                                                      //                                                     child: Text(
                                                                      //                                                       'P',
                                                                      //                                                       style: GoogleFonts.poppins(
                                                                      //                                                         fontSize: AppText.p3(context),
                                                                      //                                                         fontWeight: FontWeight.w800,
                                                                      //                                                         color: appColorProvider.white,
                                                                      //                                                       ),
                                                                      //                                                     ),
                                                                      //                                                   ),
                                                                      //                                                 ),
                                                                      //                                               ],
                                                                      //                                             ),
                                                                      //                                             const SizedBox(
                                                                      //                                               width: 20,
                                                                      //                                             ),
                                                                      //                                             Column(
                                                                      //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                                      //                                               children: [
                                                                      //                                                 Text(
                                                                      //                                                   'Ticket ${listTickets[indexS].id}',
                                                                      //                                                   style: GoogleFonts.poppins(color: appColorProvider.black54, fontSize: AppText.p2(context), fontWeight: FontWeight.w800),
                                                                      //                                                 ),
                                                                      //                                                 Text(
                                                                      //                                                   'Ticket ${listTickets[indexS].libelle}',
                                                                      //                                                   style: GoogleFonts.poppins(color: appColorProvider.black54, fontSize: AppText.p3(context), fontWeight: FontWeight.w500),
                                                                      //                                                 ),
                                                                      //                                               ],
                                                                      //                                             ),
                                                                      //                                           ],
                                                                      //                                         ),
                                                                      //                                         Container(
                                                                      //                                             height: 20,
                                                                      //                                             width: 30,
                                                                      //                                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: appColorProvider.primaryColor3),
                                                                      //                                             child: const Icon(
                                                                      //                                               LineIcons.download,
                                                                      //                                               size: 20,
                                                                      //                                             ))
                                                                      //                                       ],
                                                                      //                                     ),
                                                                      //                                     const SizedBox(
                                                                      //                                       height: 10,
                                                                      //                                     ),
                                                                      //                                     Container(
                                                                      //                                       height: 2,
                                                                      //                                       color: appColorProvider.grey3,
                                                                      //                                     )
                                                                      //                                   ],
                                                                      //                                 ),
                                                                      //                               );
                                                                      //                             },
                                                                      //                           ),
                                                                      //                         ))),
                                                                      //               ),
                                                                      //               SizedBox(
                                                                      //                 height: Device.getScreenHeight(context) / 50,
                                                                      //               ),
                                                                      //               Row(
                                                                      //                 mainAxisAlignment: MainAxisAlignment.center,
                                                                      //                 children: [
                                                                      //                   RaisedButtonDecor(
                                                                      //                     onPressed: () {},
                                                                      //                     elevation: 0,
                                                                      //                     color: Colors.blueGrey[50],
                                                                      //                     shape: BorderRadius.circular(10),
                                                                      //                     padding: const EdgeInsets.symmetric(
                                                                      //                       horizontal: 30,
                                                                      //                     ),
                                                                      //                     child: Text(
                                                                      //                       "Télécharger",
                                                                      //                       style: GoogleFonts.poppins(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: AppText.p2(context)),
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


                                                                      //Navigator.pushNamed(context, "/payment");

                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          '/ticketpdfpage',arguments: {
                                                                            "idTicket": ticketsPayes![index].id,
                                                                            "titre": ticketsPayes![index].titre,
                                                                            "libelle": ticketsPayes![index].libelle,
                                                                            "prix": ticketsPayes![index].prix,
                                                                            "conditions": ticketsPayes![index].events.conditions,
                                                                            "lieux": ticketsPayes![index].events.lieux[0].valeur,
                                                                            "date": ticketsPayes![index].events.lieux[0].dates[0].valeur,
                                                                            "heure":ticketsPayes![index].events.lieux[0].dates[0].creneauHeures[0].heureDebut ,
                                                                            "code_qr": ticketsPayes![index].codeQr,
                                                                            "ticket_access_token":ticketsPayes![index].ticketAccessToken ,
                                                                          
                                                                          },);
                                                                      
                                                                    }),
                                                                    elevation:
                                                                        0,
                                                                    color: appColorProvider
                                                                        .blue2,
                                                                    shape: BorderRadius
                                                                        .circular(
                                                                            7),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                          child: Text(
                                                                            "Voir plus",
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              color:
                                                                                  appColorProvider.blue10,
                                                                              fontSize:
                                                                                  AppText.p3(context),
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  
                                                                  !ticketsPayes![index].isReported?
                                                                  const SizedBox():
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  !ticketsPayes![index].isReported?
                                                                  const SizedBox():
                                                                  RaisedButtonDecor(
                                                                    onPressed:
                                                                        (() async {
                                                                      await showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            true, // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            content:
                                                                                Container(
                                                                              height: Device.getDiviseScreenHeight(context, 3.5),
                                                                              width: Device.getDiviseScreenWidth(context, 1.2),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: SingleChildScrollView(
                                                                                physics: const BouncingScrollPhysics(),
                                                                                child: Column(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Center(
                                                                                      child: Icon(
                                                                                        Icons.warning_rounded,
                                                                                        size: Device.getDiviseScreenHeight(context, 20),
                                                                                        color: Provider.of<AppColorProvider>(context, listen: false).primary,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Device.getScreenHeight(context) / 100,
                                                                                    ),
                                                                                    Text(
                                                                                      'Demande de remboursement',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      textAlign: TextAlign.start,
                                                                                      style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge, fontSize: AppText.p2(context), fontWeight: FontWeight.w800, color: appColorProvider.primaryColor2),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Device.getScreenHeight(context) / 100,
                                                                                    ),
                                                                                    Text(
                                                                                      'Voulez vous confirmer votre demande de remborsement?',
                                                                                      textAlign: TextAlign.center,
                                                                                      // overflow: TextOverflow
                                                                                      //     .ellipsis,
                                                                                      style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge, fontSize: AppText.p4(context), fontWeight: FontWeight.w400, color: appColorProvider.black38),
                                                                                    ),
                                                                                   
                                                                                    SizedBox(
                                                                                      height: Device.getScreenHeight(context) / 13,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: OutlinedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            style: OutlinedButton.styleFrom(
                                                                                              padding: EdgeInsets.all(Device.getDiviseScreenHeight(context, 70)),
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                              ),
                                                                                              side: BorderSide(width: 0.7, color: Provider.of<AppColorProvider>(context, listen: false).primary),
                                                                                            ),
                                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                              Text(
                                                                                                "Annuler",
                                                                                                style: GoogleFonts.poppins(color: Provider.of<AppColorProvider>(context, listen: false).primary, fontSize: AppText.p2(context)),
                                                                                              ),
                                                                                            ]),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: RaisedButtonDecor(
                                                                                            onPressed: () async {
                                                                                              await userReclamation(ticketsPayes![index].eventId);
                                                                                            },
                                                                                            elevation: 0,
                                                                                            color: AppColor.primaryColor,
                                                                                            shape: BorderRadius.circular(10),
                                                                                            padding: const EdgeInsets.all(15),
                                                                                            child: Text(
                                                                                              "Envoyer",
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: AppText.p3(context)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }),
                                                                    elevation:
                                                                        0,
                                                                    color: appColorProvider
                                                                        .primaryColor4,
                                                                    shape: BorderRadius
                                                                        .circular(
                                                                            7),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Effectuer une réclamation",
                                                                          style: GoogleFonts.poppins(
                                                                              color: appColorProvider.primary,
                                                                              fontSize: AppText.p3(context)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  '${ticketsPayes![index].dateCreation.substring(11, 13)}h${ticketsPayes![index].dateCreation.substring(14, 16)}min',
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
                                                                      color: appColorProvider
                                                                          .black38),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: Device
                                                                        .getScreenHeight(
                                                                            context) /
                                                                    100,
                                                              ),
                                                              Container(
                                                                height: 2,
                                                                color:
                                                                    appColorProvider
                                                                        .grey3,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ],
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
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
