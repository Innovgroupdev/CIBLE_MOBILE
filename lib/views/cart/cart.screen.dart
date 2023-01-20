import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:intl/intl.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/views/cart/cart.controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0;
  List<TicketUser> tickets = [];
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  void fetchTotal() {
    for (var element in tickets) {
      total += element.ticket.prix * element.quantite;
    }
  }

  clearTotal() {
    total = 0;
  }

  @override
  void setState(VoidCallback fn) {
    Provider.of<TicketProvider>(context, listen: false).setTotal(total);
    // Provider.of<TicketProvider>(context, listen: false).setTicketsList(tickets);
    super.setState(fn);
  }

  @override
  void initState() {
    fetchTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tickets = Provider.of<TicketProvider>(context).ticketsList;
    bool isLoaded=false;
    clearTotal();
    fetchTotal();
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return WillPopScope(
        onWillPop: () {
          Provider.of<AppManagerProvider>(context, listen: false).userTemp = {};
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: appColorProvider.grey4,
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              top: Device.getDiviseScreenHeight(context, 90),
              left: Device.getDiviseScreenWidth(context, 20),
              right: Device.getDiviseScreenWidth(context, 20),
              bottom: Device.getDiviseScreenWidth(context, 90),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              height: Device.getDiviseScreenHeight(context, 10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            'Total :',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p1(context),
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
                                fontSize: AppText.p1(context),
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
                  ),
                  const Gap(3),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: Device.getDiviseScreenWidth(context, 1),
                            child: ElevatedButton(
                              onPressed: () => setState(() {
                                tickets.clear();
                                Provider.of<TicketProvider>(context,
                                        listen: false)
                                    .setTicketsList(tickets);
                                clearTotal();
                              }),
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColorProvider().primaryColor1,
                                  width: 2,
                                ),
                                backgroundColor: AppColorProvider().white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Vider le panier',
                                style: GoogleFonts.poppins(
                                  fontSize: AppText.p1(context),
                                  fontWeight: FontWeight.w400,
                                  color: AppColorProvider().primaryColor1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(3),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: Device.getDiviseScreenWidth(context, 1),
                            child: ElevatedButton(
                              onPressed: () {
                                print('here');
                                print(tickets[0].ticket.libelle);
                                Provider.of<TicketProvider>(context,
                                        listen: false)
                                    .setTicketsList(tickets);
                                Provider.of<TicketProvider>(context,
                                        listen: false)
                                    .setTotal(total);
                                    setState(() {
                                      isLoaded=true;
                                    });
                                passerAchat(
                                  total,
                                  DefaultUser(
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .id,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .birthday,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .codeTel1,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .codeTel2,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .email1,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .email2,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .image,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .logged,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .nom,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .password,
                                      Provider.of<DefaultUserProvider>(context, listen: false).pays,
                                      Provider.of<DefaultUserProvider>(context, listen: false).prenom,
                                      Provider.of<DefaultUserProvider>(context, listen: false).reseauCode,
                                      Provider.of<DefaultUserProvider>(context, listen: false).sexe,
                                      Provider.of<DefaultUserProvider>(context, listen: false).tel1,
                                      Provider.of<DefaultUserProvider>(context, listen: false).tel2,
                                      Provider.of<DefaultUserProvider>(context, listen: false).ville),
                                  tickets,
                                );
                                setState(() {
                                      isLoaded=false;
                                    });
                                Navigator.pushNamed(context, "/payment");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColorProvider().primaryColor1,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoaded
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Passer à l\'achat',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppText.p1(context),
                                        fontWeight: FontWeight.w400,
                                      ),
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
              "Panier",
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
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tickets.length,
                itemBuilder: (context, i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Device.getDiviseScreenWidth(context, 30),
                      vertical: Device.getDiviseScreenWidth(context, 30),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: Device.getDiviseScreenHeight(context, 100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tickets[i].ticket.libelle,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.titre3(context),
                                  fontWeight: FontWeight.bold,
                                  color: appColorProvider.black54,
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
                                  text: 'De : ${tickets[i].event.titre}',
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: oCcy.format(tickets[i].ticket.prix),
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
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   tickets[i].quantite = 0;
                                    // });
                                    // setState(() {
                                    //   tickets.removeWhere((element) =>
                                    //       element.ticket.libelle ==
                                    //       tickets[i].ticket.libelle);
                                    // });

                                    Provider.of<TicketProvider>(context,
                                            listen: false)
                                        .removeTicket(tickets[i]);

                                    clearTotal();
                                    fetchTotal();

                                    // Provider.of<TicketProvider>(context,
                                    //         listen: false)
                                    //     .setTicketsList(tickets);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    alignment: Alignment.centerRight,
                                    backgroundColor: appColorProvider.white,
                                    padding: const EdgeInsets.all(0),
                                    elevation: 0,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: AppText.titre3(context),
                                    color: appColorProvider.primaryColor1,
                                  ),
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: Device.getDiviseScreenWidth(context, 6),

                                //ajout et soustraction de quantite
                                child: Row(
                                  children: [
                                    //soustraction de quantite
                                    SizedBox(
                                      width: 20,
                                      child: ElevatedButton(
                                        // ignore: prefer_const_constructors
                                        style: ElevatedButton.styleFrom(
                                          alignment: Alignment.centerRight,
                                          backgroundColor:
                                              appColorProvider.white,
                                          padding: const EdgeInsets.all(0),
                                          elevation: 0,
                                        ),
                                        child: Icon(
                                          Icons.remove_circle,
                                          size: AppText.titre3(context),
                                          color: appColorProvider.black54,
                                        ),
                                        onPressed: () => setState(() {
                                          final newValue =
                                              tickets[i].quantite - 1;

                                          tickets[i].quantite =
                                              newValue.clamp(1, 5);

                                          tickets[i].montant =
                                              tickets[i].ticket.prix *
                                                  tickets[i].quantite;

                                          clearTotal();
                                          fetchTotal();

                                          Provider.of<TicketProvider>(context,
                                                  listen: false)
                                              .setTicketsList(tickets);
                                        }),
                                      ),
                                    ),
                                    //affichage de la quantite
                                    const Gap(5),
                                    Text(
                                      tickets[i].quantite.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.titre3(context),
                                        fontWeight: FontWeight.bold,
                                        color: appColorProvider.black54,
                                      ),
                                    ),
                                    const Gap(5),
                                    //ajout de quantite
                                    SizedBox(
                                      width: 20,
                                      child: ElevatedButton(
                                        // ignore: prefer_const_constructors
                                        style: ElevatedButton.styleFrom(
                                          alignment: Alignment.centerRight,
                                          backgroundColor:
                                              appColorProvider.white,
                                          padding: const EdgeInsets.all(0),
                                          elevation: 0,
                                        ),
                                        child: Icon(
                                          Icons.add_circle,
                                          size: AppText.titre3(context),
                                          color: appColorProvider.black54,
                                        ),
                                        onPressed: () => setState(() {
                                          final newValue =
                                              tickets[i].quantite + 1;

                                          tickets[i].quantite =
                                              newValue.clamp(1, 5);

                                          tickets[i].montant =
                                              tickets[i].ticket.prix *
                                                  tickets[i].quantite;

                                          clearTotal();
                                          fetchTotal();

                                          Provider.of<TicketProvider>(context,
                                                  listen: false)
                                              .setTicketsList(tickets);
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
      );
    });
  }
}
