import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/views/payment/payment.controller.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/modelGadgetUser.dart';
import '../../providers/gadgetProvider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool checkedValue = false;
  List<TicketUser> tickets = [];
  List<ModelGadgetUser> gadgets = [];
  double total = 0;
  bool isLoading1 = false;
  double portefeuilleSolde = 0;
  final oCcy = NumberFormat("#,##0.00", "fr_FR");
  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    setState(() {
      tickets = Provider.of<TicketProvider>(context).ticketsList;
      gadgets = Provider.of<ModelGadgetProvider>(context).gadgetsList;
      total = Provider.of<TicketProvider>(context).total +
          Provider.of<ModelGadgetProvider>(context).total;
      portefeuilleSolde = Provider.of<PortefeuilleProvider>(context).solde;
    });
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          Provider.of<AppManagerProvider>(context, listen: false).userTemp = {};
          return false;
        },
        child: Scaffold(
          backgroundColor: appColorProvider.grey2,
          appBar: AppBar(
            backgroundColor: appColorProvider.grey2,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: appColorProvider.black54,
              onPressed: () {
                Provider.of<AppManagerProvider>(context, listen: false)
                    .userTemp = {};
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Paiement",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54,
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                height: Device.getScreenHeight(context) * 0.66,
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: appColorProvider.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: appColorProvider.primaryColor5,
                            height: Device.getDiviseScreenWidth(context, 7),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'FACTURE',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.bold,
                                  color: appColorProvider.black54,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: appColorProvider.white,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Nom du client :",
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p2(context),
                                        color: appColorProvider.black54,
                                      ),
                                    ),
                                    Text(
                                      '${Provider.of<DefaultUserProvider>(context).nom} ${Provider.of<DefaultUserProvider>(context).prenom}',
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p2(context),
                                        fontWeight: FontWeight.bold,
                                        color: appColorProvider.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date de l'achat :",
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p2(context),
                                        color: appColorProvider.black54,
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat.yMMMd('fr_FR').format(DateTime.now())} ${DateFormat.Hm().format(DateTime.now())}',
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p2(context),
                                        fontWeight: FontWeight.bold,
                                        color: appColorProvider.black54,
                                      ),
                                    ),
                                  ],
                                ),

                                const Gap(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Ticket',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Prix Unitaire',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Quantité',
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            color: appColorProvider.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: appColorProvider.black54,
                                ),
                                const Gap(10),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       "Solde du portefeuille :",
                                //       style: GoogleFonts.poppins(
                                //         textStyle:
                                //             Theme.of(context).textTheme.bodyLarge,
                                //         fontSize: AppText.p2(context),
                                //         color: appColorProvider.black54,
                                //       ),
                                //     ),
                                //     Text(
                                //       oCcy.format(portefeuilleSolde),
                                //       style: GoogleFonts.poppins(
                                //         textStyle:
                                //             Theme.of(context).textTheme.bodyLarge,
                                //         fontSize: AppText.p2(context),
                                //         fontWeight: FontWeight.bold,
                                //         color: appColorProvider.black54,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                const Gap(10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: tickets.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: Device.getDiviseScreenHeight(
                                            context, 100),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tickets[i].ticket.libelle,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontSize:
                                                        AppText.p2(context),
                                                    fontWeight: FontWeight.bold,
                                                    color: appColorProvider
                                                        .black54,
                                                  ),
                                                ),
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
                                                          FontWeight.w400,
                                                    ),
                                                    text:
                                                        tickets[i].event.titre,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${oCcy.format(tickets[i].ticket.prix)} FCFA',
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize: AppText.p2(context),
                                                fontWeight: FontWeight.w400,
                                                color: appColorProvider.black54,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                ' * ${tickets[i].quantite}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontSize:
                                                        AppText.p2(context),
                                                    fontWeight: FontWeight.bold,
                                                    color: appColorProvider
                                                        .primaryColor1),
                                              ),
                                            ),
                                          ),
                                          // Column(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     RichText(
                                          //       text: TextSpan(
                                          //         children: <TextSpan>[
                                          //           TextSpan(
                                          //             text: tickets[i].ticket.libelle,
                                          //             style: GoogleFonts.poppins(
                                          //               textStyle: Theme.of(context)
                                          //                   .textTheme
                                          //                   .bodyLarge,
                                          //               fontSize:
                                          //                   AppText.titre3(context),
                                          //               fontWeight: FontWeight.bold,
                                          //               color: appColorProvider.black54,
                                          //             ),
                                          //           ),
                                          //           TextSpan(
                                          //             text: ' * ${tickets[i].quantite}',
                                          //             style: GoogleFonts.poppins(
                                          //               textStyle: Theme.of(context)
                                          //                   .textTheme
                                          //                   .bodyLarge,
                                          //               fontSize:
                                          //                   AppText.titre3(context),
                                          //               fontWeight: FontWeight.bold,
                                          //               color: appColorProvider
                                          //                   .primaryColor1,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     RichText(
                                          //       overflow: TextOverflow.ellipsis,
                                          //       strutStyle: StrutStyle(
                                          //         fontSize: AppText.p3(context),
                                          //       ),
                                          //       text: TextSpan(
                                          //         style: GoogleFonts.poppins(
                                          //           color: appColorProvider.black54,
                                          //           fontWeight: FontWeight.w400,
                                          //         ),
                                          //         text: tickets[i].event.titre,
                                          //       ),
                                          //     ),
                                          //     RichText(
                                          //       text: TextSpan(
                                          //         text: oCcy
                                          //             .format(tickets[i].ticket.prix),
                                          //         style: GoogleFonts.poppins(
                                          //           textStyle: Theme.of(context)
                                          //               .textTheme
                                          //               .bodyLarge,
                                          //           fontSize: AppText.p2(context),
                                          //           fontWeight: FontWeight.bold,
                                          //           color:
                                          //               appColorProvider.primaryColor1,
                                          //         ),
                                          //         children: const <TextSpan>[
                                          //           TextSpan(
                                          //             text: ' FCFA',
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // RichText(
                                          //   textAlign: TextAlign.end,
                                          //   text: TextSpan(
                                          //     text: oCcy.format(
                                          //         tickets[i].ticket.prix *
                                          //             tickets[i].quantite),
                                          //     style: GoogleFonts.poppins(
                                          //       textStyle: Theme.of(context)
                                          //           .textTheme
                                          //           .bodyLarge,
                                          //       fontSize: AppText.p2(context),
                                          //       fontWeight: FontWeight.bold,
                                          //       color: appColorProvider.black54,
                                          //     ),
                                          //     children: const <TextSpan>[
                                          //       TextSpan(
                                          //         text: ' FCFA',
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Gadget',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Prix Unitaire',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Quantité',
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            color: appColorProvider.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: appColorProvider.black54,
                                ),
                                const Gap(10),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       "Solde du portefeuille :",
                                //       style: GoogleFonts.poppins(
                                //         textStyle:
                                //             Theme.of(context).textTheme.bodyLarge,
                                //         fontSize: AppText.p2(context),
                                //         color: appColorProvider.black54,
                                //       ),
                                //     ),
                                //     Text(
                                //       oCcy.format(portefeuilleSolde),
                                //       style: GoogleFonts.poppins(
                                //         textStyle:
                                //             Theme.of(context).textTheme.bodyLarge,
                                //         fontSize: AppText.p2(context),
                                //         fontWeight: FontWeight.bold,
                                //         color: appColorProvider.black54,
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: gadgets.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: Device.getDiviseScreenHeight(
                                            context, 100),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  gadgets[i]
                                                      .modelGadget
                                                      .libelle,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontSize:
                                                        AppText.p2(context),
                                                    fontWeight: FontWeight.bold,
                                                    color: appColorProvider
                                                        .black54,
                                                  ),
                                                ),
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
                                                          FontWeight.w400,
                                                    ),
                                                    text: gadgets[i]
                                                        .tailleModel
                                                        .libelle,
                                                  ),
                                                ),
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
                                                          FontWeight.w400,
                                                    ),
                                                    text: gadgets[i]
                                                        .couleurModel
                                                        .libelle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${oCcy.format(gadgets[i].modelGadget.prixCible)} ${gadgets[i].modelGadget.deviseCible}',
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize: AppText.p2(context),
                                                fontWeight: FontWeight.w400,
                                                color: appColorProvider.black54,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                ' * ${gadgets[i].quantite}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    fontSize:
                                                        AppText.p2(context),
                                                    fontWeight: FontWeight.bold,
                                                    color: appColorProvider
                                                        .primaryColor1),
                                              ),
                                            ),
                                          ),
                                          // Column(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     RichText(
                                          //       text: TextSpan(
                                          //         children: <TextSpan>[
                                          //           TextSpan(
                                          //             text: tickets[i].ticket.libelle,
                                          //             style: GoogleFonts.poppins(
                                          //               textStyle: Theme.of(context)
                                          //                   .textTheme
                                          //                   .bodyLarge,
                                          //               fontSize:
                                          //                   AppText.titre3(context),
                                          //               fontWeight: FontWeight.bold,
                                          //               color: appColorProvider.black54,
                                          //             ),
                                          //           ),
                                          //           TextSpan(
                                          //             text: ' * ${tickets[i].quantite}',
                                          //             style: GoogleFonts.poppins(
                                          //               textStyle: Theme.of(context)
                                          //                   .textTheme
                                          //                   .bodyLarge,
                                          //               fontSize:
                                          //                   AppText.titre3(context),
                                          //               fontWeight: FontWeight.bold,
                                          //               color: appColorProvider
                                          //                   .primaryColor1,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     RichText(
                                          //       overflow: TextOverflow.ellipsis,
                                          //       strutStyle: StrutStyle(
                                          //         fontSize: AppText.p3(context),
                                          //       ),
                                          //       text: TextSpan(
                                          //         style: GoogleFonts.poppins(
                                          //           color: appColorProvider.black54,
                                          //           fontWeight: FontWeight.w400,
                                          //         ),
                                          //         text: tickets[i].event.titre,
                                          //       ),
                                          //     ),
                                          //     RichText(
                                          //       text: TextSpan(
                                          //         text: oCcy
                                          //             .format(tickets[i].ticket.prix),
                                          //         style: GoogleFonts.poppins(
                                          //           textStyle: Theme.of(context)
                                          //               .textTheme
                                          //               .bodyLarge,
                                          //           fontSize: AppText.p2(context),
                                          //           fontWeight: FontWeight.bold,
                                          //           color:
                                          //               appColorProvider.primaryColor1,
                                          //         ),
                                          //         children: const <TextSpan>[
                                          //           TextSpan(
                                          //             text: ' FCFA',
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // RichText(
                                          //   textAlign: TextAlign.end,
                                          //   text: TextSpan(
                                          //     text: oCcy.format(
                                          //         tickets[i].ticket.prix *
                                          //             tickets[i].quantite),
                                          //     style: GoogleFonts.poppins(
                                          //       textStyle: Theme.of(context)
                                          //           .textTheme
                                          //           .bodyLarge,
                                          //       fontSize: AppText.p2(context),
                                          //       fontWeight: FontWeight.bold,
                                          //       color: appColorProvider.black54,
                                          //     ),
                                          //     children: const <TextSpan>[
                                          //       TextSpan(
                                          //         text: ' FCFA',
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: appColorProvider.primaryColor5,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Sous-total :',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: oCcy.format(total),
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.bold,
                                            color: appColorProvider.black54,
                                          ),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text: ' FCFA',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Frais :',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: '4',
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.bold,
                                            color: appColorProvider.black54,
                                          ),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text: ' %',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'TOTAL :',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: oCcy.format(
                                              total + (total * 4 / 100)),
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.bold,
                                            color:
                                                appColorProvider.primaryColor1,
                                          ),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text: ' FCFA',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Remise :',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.bold,
                                          color: appColorProvider.black54,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: '0',
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.bold,
                                            color: appColorProvider.black54,
                                          ),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text: ' FCFA',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: appColorProvider.primaryColor5,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            child: Center(
                              child: Text(
                                'Merci à vous !❤️',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.bold,
                                  color: appColorProvider.black54,
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
              Container(
                // color: Colors.blue,
                height: Device.getScreenHeight(context) * 0.21,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // const Gap(20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 30),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(
                          //   width: 1,
                          //   color: appColorProvider.black54,
                          // ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Device.getDiviseScreenWidth(context, 30),
                        ),
                        child: Center(
                          child: CheckboxListTile(
                            title: Text(
                              "J'accepte les conditions des organisateurs",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontSize: AppText.p4(context),
                                fontWeight: FontWeight.bold,
                                color: appColorProvider.black54,
                              ),
                            ),
                            value: checkedValue,
                            onChanged: (newValue) {
                              setState(() {
                                checkedValue = !checkedValue;
                              });
                              print(checkedValue);
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                        ),
                      ),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                  width: 0.7,
                                  color: Provider.of<AppColorProvider>(context,
                                          listen: false)
                                      .black26),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Annuler",
                                    style: GoogleFonts.poppins(
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black87,
                                        fontSize: AppText.p2(context)),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColorProvider().primaryColor1,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: !checkedValue
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading1 = true;
                                    });
                                    await payement(context);
                                    setState(() {
                                      isLoading1 = false;
                                    });
                                  },
                            child: isLoading1
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Payer",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p1(context),
                                      color: appColorProvider.white,
                                    ),
                                  ),
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
      );
    });
  }
}
