import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/gadgetProvider.dart';
import 'package:intl/intl.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/views/cart/cart.controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../models/modelGadgetUser.dart';

class GadgetCartScreen extends StatefulWidget {
  const GadgetCartScreen({Key? key}) : super(key: key);

  @override
  _GadgetCartScreenState createState() => _GadgetCartScreenState();
}

class _GadgetCartScreenState extends State<GadgetCartScreen> {
  double total = 0;
  bool isLoading = false;
  List<ModelGadgetUser> gadgets = [];
  List<TicketUser> tickets = [];
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  void fetchTotal() {
    for (var element in gadgets) {
      total += element.modelGadget.prixCible * element.quantite;
    }
  }

  clearTotal() {
    total = 0;
  }

  @override
  void setState(VoidCallback fn) {
    Provider.of<ModelGadgetProvider>(context, listen: false).setTotal(total);
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
    gadgets = Provider.of<ModelGadgetProvider>(context).gadgetsList;
    tickets = Provider.of<TicketProvider>(context).ticketsList;

    print('GADGETSLISTE'+gadgets.toString());
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
          backgroundColor: appColorProvider.defaultBg,
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
                                gadgets.clear();
                                Provider.of<ModelGadgetProvider>(context,
                                        listen: false)
                                    .setGadgetsList(gadgets);
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
                                print('batttttttttttttt'+tickets.toString());
                                print(gadgets[0].modelGadget.libelle);
                                Provider.of<ModelGadgetProvider>(context,
                                        listen: false)
                                    .setGadgetsList(gadgets);
                                Provider.of<ModelGadgetProvider>(context,
                                        listen: false)
                                    .setTotal(total);

                                setState(() {
                                  isLoading = true;
                                });
                                print('rrrrrrrr'+isLoading.toString());
                                passerAchat(
                                  context,
                                  total,
                                  DefaultUser(
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .id,
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .ageRangeId,
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .codeTel1,
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .codeTel2,
                                      Provider.of<DefaultUserProvider>(context, listen: false)
                                          .email1,
                                      Provider.of<DefaultUserProvider>(context, listen: false)
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
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .paysId,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .prenom,
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .reseauCode,
                                      Provider.of<DefaultUserProvider>(context, listen: false).sexe,
                                      Provider.of<DefaultUserProvider>(context, listen: false).tel1,
                                      Provider.of<DefaultUserProvider>(context, listen: false).tel2,
                                      Provider.of<DefaultUserProvider>(context, listen: false).ville,
                                      Provider.of<DefaultUserProvider>(context, listen: false).portefeuilId),
                                  Provider.of<TicketProvider>(context, listen: false).ticketsList,
                                  gadgets
                                );
                                
                                setState(() {
                                  isLoading = false;
                                });
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
                              child: 
                              isLoading
                                  ? Container(
                                    height: 20,
                                    width: 20,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                  )
                                  : Text(
                                      'Valider mes choix',
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
              "Panier de gadgets",
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
                itemCount: gadgets.length,
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
                                gadgets[i].modelGadget.libelle,
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
                                  text: 'Couleur : ${gadgets[i].couleurModel.libelle}',
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
                                  text: 'Taille : ${gadgets[i].tailleModel.libelle}',
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: oCcy.format(gadgets[i].modelGadget.prixCible),
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.bold,
                                    color: appColorProvider.primaryColor1,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ${gadgets[i].modelGadget.deviseCible}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
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

                                    Provider.of<ModelGadgetProvider>(context,
                                            listen: false)
                                        .removeGadget(gadgets[i]);

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
                                              gadgets[i].quantite - 1;

                                          gadgets[i].quantite =
                                              newValue.clamp(1, 10);

                                          gadgets[i].montant =
                                              gadgets[i].modelGadget.prixCible *
                                                  gadgets[i].quantite;

                                          clearTotal();
                                          fetchTotal();

                                          Provider.of<ModelGadgetProvider>(context,
                                                  listen: false)
                                              .setGadgetsList(gadgets);
                                        }),
                                      ),
                                    ),
                                    //affichage de la quantite
                                    const Gap(5),
                                    Text(
                                      gadgets[i].quantite.toString(),
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
                                              gadgets[i].quantite + 1;

                                          gadgets[i].quantite =
                                              newValue.clamp(1, 10);

                                          gadgets[i].montant =
                                              gadgets[i].modelGadget.prixCible *
                                                  gadgets[i].quantite;

                                          clearTotal();
                                          fetchTotal();

                                          Provider.of<ModelGadgetProvider>(context,
                                                  listen: false)
                                              .setGadgetsList(gadgets);
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
