import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/views/monCompte/monCompte.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';

class Satistics extends StatefulWidget {
  const Satistics({super.key});

  @override
  State<Satistics> createState() => _SatisticsState();
}

class _SatisticsState extends State<Satistics> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Device.getDiviseScreenWidth(context, 50),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Device.getScreenHeight(context) / 50,
            ),
            Text(
              "GENERAL",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                color: appColorProvider.black38,
                fontSize: AppText.p4(context),
              ),
            ),
            SizedBox(
              height: Device.getScreenHeight(context) / 90,
            ),
            Row(children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/modifiecompte');
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                      child: Card(
                          elevation: 3,
                          shadowColor: appColorProvider.black12,
                          color: appColorProvider.white,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              Device.getScreenHeight(context) /
                                                  40,
                                          height:
                                              Device.getScreenHeight(context) /
                                                  40,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageUrl:
                                                "https://cdn-icons-png.flaticon.com/512/829/829452.png",
                                          ),
                                        ),
                                        Text(
                                          "25",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p1(context),
                                              fontWeight: FontWeight.w700,
                                              color: appColorProvider.black87),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Notifications",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: FontWeight.w600,
                                              color: appColorProvider.black87),
                                        ),
                                        Icon(Icons.arrow_forward_ios,
                                            size: AppText.p6(context),
                                            color: appColorProvider.black45),
                                      ],
                                    ),
                                  ]))),
                    )),
              ),
              Expanded(
                child: GestureDetector(
                    child: Card(
                        elevation: 3,
                        shadowColor: appColorProvider.black12,
                        color: appColorProvider.white,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Device.getScreenHeight(context) /
                                            40,
                                        height:
                                            Device.getScreenHeight(context) /
                                                40,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl:
                                              "https://cdn-icons-png.flaticon.com/512/1672/1672241.png",
                                        ),
                                      ),
                                      Text(
                                        "15",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w700,
                                            color: appColorProvider.black87),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        Device.getScreenHeight(context) / 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Recommandations",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w600,
                                            color: appColorProvider.black87),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: AppText.p6(context),
                                          color: appColorProvider.black45),
                                    ],
                                  ),
                                ])))),
              )
            ]),
            SizedBox(
              height: Device.getScreenHeight(context) / 50,
            ),
            Text(
              "EVENNEMENTS & TICKETS",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                color: appColorProvider.black38,
                fontSize: AppText.p4(context),
              ),
            ),
            SizedBox(
              height: Device.getScreenHeight(context) / 90,
            ),
            Row(children: [
              Expanded(
                child: GestureDetector(
                    child: Card(
                        elevation: 3,
                        shadowColor: appColorProvider.black12,
                        color: appColorProvider.white,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Device.getScreenHeight(context) /
                                            40,
                                        height:
                                            Device.getScreenHeight(context) /
                                                40,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl:
                                              "https://cdn-icons-png.flaticon.com/512/432/432312.png",
                                        ),
                                      ),
                                      Text(
                                        "02",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w700,
                                            color: appColorProvider.black87),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        Device.getScreenHeight(context) / 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tickets payés",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w600,
                                            color: appColorProvider.black87),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: AppText.p6(context),
                                          color: appColorProvider.black45),
                                    ],
                                  ),
                                ])))),
              ),
              Expanded(
                child: GestureDetector(
                    child: Card(
                        elevation: 3,
                        shadowColor: appColorProvider.black12,
                        color: appColorProvider.white,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Device.getScreenHeight(context) /
                                            40,
                                        height:
                                            Device.getScreenHeight(context) /
                                                40,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl:
                                              "https://cdn-icons-png.flaticon.com/512/432/432312.png",
                                        ),
                                      ),
                                      Text(
                                        "01",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w700,
                                            color: appColorProvider.black87),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        Device.getScreenHeight(context) / 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tickets expirés",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p3(context),
                                            fontWeight: FontWeight.w600,
                                            color: appColorProvider.black87),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: AppText.p6(context),
                                          color: appColorProvider.black45),
                                    ],
                                  ),
                                ])))),
              )
            ]),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Device.getDiviseScreenHeight(context, 50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ajouter d'autres fonctionnalités",
                    style: GoogleFonts.poppins(
                        color: appColorProvider.black,
                        fontSize: AppText.p2(context),
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "AFFICHER PLUS",
                    style: GoogleFonts.poppins(
                        color: appColorProvider.primaryColor1,
                        fontSize: AppText.p4(context),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              child: actions == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: Device.getDiviseScreenHeight(context, 5),
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: Device.getDiviseScreenWidth(context, 50)),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: actions.length,
                        itemExtent: Device.getDiviseScreenWidth(context, 2.5),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                actions[index].changeEtat();
                                if (actions[index].etat) {
                                } else {
                                  if (actions[index] != null) {}
                                }
                              });
                            }),
                            child: Card(
                              elevation: 3,
                              shadowColor: appColorProvider.black12,
                              color: appColorProvider.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: actions[index].etat
                                                      ? appColorProvider
                                                          .primaryColor1
                                                      : const Color.fromARGB(
                                                          31, 151, 151, 151)),
                                              color: actions[index].etat
                                                  ? appColorProvider
                                                      .primaryColor1
                                                  : appColorProvider.grey2,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100))),
                                          child: Icon(
                                            LineIcons.check,
                                            size: 7,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 100,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width:
                                              Device.getScreenHeight(context) /
                                                  22,
                                          height:
                                              Device.getScreenHeight(context) /
                                                  22,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageUrl: actions[index].image,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  50,
                                        ),
                                        Text(
                                          actions[index].titre,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w600,
                                              color: appColorProvider.black54),
                                        ),
                                      ], //just for testing, will fill with image later
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class ActiviteRecentes extends StatefulWidget {
  const ActiviteRecentes({Key? key}) : super(key: key);

  @override
  State<ActiviteRecentes> createState() => _ActiviteRecentesState();
}

class _ActiviteRecentesState extends State<ActiviteRecentes> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (() {}),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10000),
                                    color: appColorProvider.blue10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'A',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppText.p3(context),
                                        fontWeight: FontWeight.w800,
                                        color: appColorProvider.white,
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
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.w800,
                                  color: appColorProvider.black54),
                            ),
                            subtitle: Text(
                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p4(context),
                                  fontWeight: FontWeight.w400,
                                  color: appColorProvider.black38),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '12h48mn',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w600,
                                      color: appColorProvider.black38),
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
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (() {}),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10000),
                                    color: appColorProvider.primary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'R',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppText.p3(context),
                                        fontWeight: FontWeight.w800,
                                        color: appColorProvider.white,
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
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.w800,
                                  color: appColorProvider.black54),
                            ),
                            subtitle: Text(
                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p4(context),
                                  fontWeight: FontWeight.w400,
                                  color: appColorProvider.black38),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '12h48mn',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w600,
                                      color: appColorProvider.black38),
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
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (() {}),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10000),
                                    color: appColorProvider.categoriesColor(0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'S',
                                      style: GoogleFonts.poppins(
                                        fontSize: AppText.p3(context),
                                        fontWeight: FontWeight.w800,
                                        color: appColorProvider.white,
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
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.w800,
                                  color: appColorProvider.black54),
                            ),
                            subtitle: Text(
                              "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p4(context),
                                  fontWeight: FontWeight.w400,
                                  color: appColorProvider.black38),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '12h48mn',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p4(context),
                                      fontWeight: FontWeight.w600,
                                      color: appColorProvider.black38),
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
      );
    });
  }
}
