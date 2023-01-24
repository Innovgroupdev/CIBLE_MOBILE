import 'package:flutter/material.dart';

import '../../database/notificationDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/formWidget.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';

import '../../widgets/raisedButtonDecor.dart';

class RechargerCompte extends StatefulWidget {
  RechargerCompte({Key? key}) : super(key: key);

  @override
  State<RechargerCompte> createState() => _RechargerCompteState();
}

class _RechargerCompteState extends State<RechargerCompte> {
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
          elevation: 0,
          foregroundColor:
              Provider.of<AppColorProvider>(context, listen: false).black54,
          title: Text(
            "Recharger mon compte",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p1(context),
                fontWeight: FontWeight.w800,
                color: Provider.of<AppColorProvider>(context, listen: false)
                    .black54),
          ),
          centerTitle: true,
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
                    child: Badge(
                      badgeContent: Consumer<DefaultUserProvider>(
                          builder: (context, Panier, child) {
                        return Text(
                          notifs.length.toString(),
                          //'3',
                          style: TextStyle(color: appColorProvider.white),
                        );
                      }),
                      toAnimate: true,
                      shape: BadgeShape.circle,
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
                    height: Device.getScreenHeight(context) / 20,
                    decoration: BoxDecoration(color: appColorProvider.primary),
                  ),
                  SizedBox(height: Device.getScreenHeight(context) / 10),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 30),
                              Text(
                                "Veuillez recharger votre compte pour continuer votre achat",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w800,
                                    color: appColorProvider.black54),
                              ),
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 15),
                              TextFormField(
                                // initialValue: defaultUserProvider.nom,
                                decoration: inputDecorationGrey(
                                    "Montant à recharger",
                                    Device.getScreenWidth(context)),
                                validator: (val) => val.toString().length < 3 &&
                                        val.toString().isNotEmpty
                                    ? 'veuillez entrer un montant valide !'
                                    : null,
                                // onChanged: (val) =>
                                //     defaultUserProvider.nom = val,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 40),
                              TextFormField(
                                // initialValue: defaultUserProvider.nom,
                                decoration: inputDecorationGrey(
                                    "Frais de rechargement(50 F par example)",
                                    Device.getScreenWidth(context)),
                                validator: (val) => val.toString().length < 3 &&
                                        val.toString().isNotEmpty
                                    ? 'veuillez entrer un montant valide !'
                                    : null,
                                // onChanged: (val) =>
                                //     defaultUserProvider.nom = val,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 40),
                              TextFormField(
                                // initialValue: defaultUserProvider.nom,
                                decoration: inputDecorationGrey(
                                    "Total", Device.getScreenWidth(context)),
                                validator: (val) => val.toString().length < 3 &&
                                        val.toString().isNotEmpty
                                    ? 'veuillez entrer un total valide !'
                                    : null,
                                // onChanged: (val) =>
                                //     defaultUserProvider.nom = val,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 15),
                              Text(
                                "*Frais de rechargement 4%",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    color: appColorProvider.primary),
                              ),
                              SizedBox(
                                  height: Device.getScreenHeight(context) / 8),
                              RaisedButtonDecor(
                                onPressed: () {},
                                elevation: 3,
                                color: AppColor.primaryColor,
                                shape: BorderRadius.circular(10),
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Recharger",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: AppText.p2(context)),
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
