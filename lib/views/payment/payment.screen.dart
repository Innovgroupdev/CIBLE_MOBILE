import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Ticket> tickets = [];
  double total = 0;
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  @override
  void initState() {
    super.initState();
  }

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
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 30),
              vertical: Device.getDiviseScreenWidth(context, 30),
            ),
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
              onPressed: () {
                Navigator.pushNamed(context, "/ticket");
              },
              child: Text(
                "Effectuer l'achat",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p1(context),
                  color: appColorProvider.white,
                ),
              ),
            ),
          ),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Device.getDiviseScreenWidth(context, 30),
                    vertical: Device.getDiviseScreenWidth(context, 30),
                  ),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Nom du client :",
                      //       style: GoogleFonts.poppins(
                      //         textStyle: Theme.of(context).textTheme.bodyLarge,
                      //         fontSize: AppText.p2(context),
                      //         color: appColorProvider.black54,
                      //       ),
                      //     ),
                      //     Text(
                      //       '${Provider.of<DefaultUserProvider>(context).nom} ${Provider.of<DefaultUserProvider>(context).prenom}',
                      //       style: GoogleFonts.poppins(
                      //         textStyle: Theme.of(context).textTheme.bodyLarge,
                      //         fontSize: AppText.p2(context),
                      //         fontWeight: FontWeight.bold,
                      //         color: appColorProvider.black54,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Gap(10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Date de l'achat :",
                      //       style: GoogleFonts.poppins(
                      //         textStyle: Theme.of(context).textTheme.bodyLarge,
                      //         fontSize: AppText.p2(context),
                      //         color: appColorProvider.black54,
                      //       ),
                      //     ),
                      //     Text(
                      //       '${DateFormat.yMMMd('fr_FR').format(DateTime.now())} ${DateFormat.Hm().format(DateTime.now())}',
                      //       style: GoogleFonts.poppins(
                      //         textStyle: Theme.of(context).textTheme.bodyLarge,
                      //         fontSize: AppText.p2(context),
                      //         fontWeight: FontWeight.bold,
                      //         color: appColorProvider.black54,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Gap(10),
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
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  Device.getDiviseScreenHeight(context, 100),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: tickets[i].libelle,
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize:
                                                    AppText.titre3(context),
                                                fontWeight: FontWeight.bold,
                                                color: appColorProvider.black54,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' * ${tickets[i].nombrePlaces}',
                                              style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize:
                                                    AppText.titre3(context),
                                                fontWeight: FontWeight.bold,
                                                color: appColorProvider
                                                    .primaryColor1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(
                                          fontSize: AppText.p3(context),
                                        ),
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(
                                            color: appColorProvider.black54,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          text: tickets[i].description,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: oCcy.format(tickets[i].prix),
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
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      text: oCcy.format(tickets[i].prix *
                                          tickets[i].nombrePlaces),
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
                          );
                        },
                      ),
                      const Gap(20),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: appColorProvider.black54,
                      ),
                      const Gap(20),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Sous-total :',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Frais :',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'TOTAL :',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p2(context),
                                      fontWeight: FontWeight.bold,
                                      color: appColorProvider.primaryColor1,
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
                    ],
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
