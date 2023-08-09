import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  TicketsPayes({required this.eventId, Key? key}) : super(key: key);
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
      print('toutaaaaaaaaaaa2' + element.toString());
      var ticket = TicketPaye.fromMap(element);

      tagObjs.add(ticket);
    }
    return tagObjs;
  }

  getTicketspayesFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    print('rffffffffffff' + widget.eventId.toString());
    var response = await http.get(
      Uri.parse('$baseApiUrl/evenement/${widget.eventId}/userTickets'),
      /*hashwithtickets*/
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print("ticketsPayes");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        if (jsonDecode(response.body)['message'] == "no data found") {
          ticketsPayes = [];
        } else {
          ticketsPayes =
              getTicketsPayesFromMap(jsonDecode(response.body)['data'] as List);
          // ticketsPayes!.sort((a, b) {
          //   return DateTime.parse(b.dateCreation)
          //       .compareTo(DateTime.parse(a.dateCreation));
          // });

          // print('toutaaaaaaaaaaa1' +
          //     ticketsPayes![0]
          //         .events
          //         .lieux[0]
          //         .creneauDates[0]
          //         .dateDebut
          //         .toString());
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
                    .white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            children: [
              ticketsPayes == null
                  ? Container(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : Container(
                      child: Column(
                        children: [
                          Row(
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
                              // InkWell(
                              //     onTap: () {}, child: const Icon(Icons.search))
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ticketsPayes == null
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ticketsPayes!.isEmpty
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 350,
                                                      width: 350,
                                                      child: Image.asset(
                                                          'assets/images/empty.png'),
                                                    ),
                                                    const Text(
                                                      'Pas de tickets payés',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: AppColor.primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  // scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      ticketsPayes!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/ticketpdfpage',
                                                          arguments:
                                                              ticketsPayes![
                                                                  index],
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.5,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10.0),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            1000),
                                                                child: Icon(Icons
                                                                    .picture_as_pdf)),
                                                            const Gap(10),
                                                            Text(
                                                              "Ticket ${ticketsPayes![index].libelle}.pdf ",
                                                              // 'Ticket VIP',
                                                              style: GoogleFonts.poppins(
                                                                  color: appColorProvider
                                                                      .primaryColor1,
                                                                  fontSize:
                                                                      AppText.p3(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                          ],
                                                        ),
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
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
