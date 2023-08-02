import 'dart:convert';

import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../database/notificationDBcontroller.dart';
import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../models/notification.dart';
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

class RechargerCompte extends StatefulWidget {
  RechargerCompte({Key? key}) : super(key: key);

  @override
  State<RechargerCompte> createState() => _RechargerCompteState();
}

class _RechargerCompteState extends State<RechargerCompte> {
  dynamic notifs;
  final TextEditingController montantController = TextEditingController();
  double totalPaye = 0;
  List devises = [];
  var countries;
  List<Map<String, String>> finalCountries = [];
  dynamic currentDevise;
  dynamic currentMontant = 0;
  bool isLoading = false;
  final _keyForm = GlobalKey<FormState>();
  String? url;

  rechargeCompte(double amount, String channels) async {
    var users;
    users = await UserDBcontroller().liste() as List;
    int userId = int.parse(users[0].id);
    print('rrtttt ' + amount.toString());
    try {
      Map<String, dynamic> data1 = {
        "amount": amount,
        "channels": "MOBILE_MONEY",
        "description": "Payement de recharge compte",
        "lang": "fr",
        "user_id": userId,
        "identifiant": "part"
      };
      print(jsonEncode(data1));
      var response = await http.post(Uri.parse('$baseApiUrl/payment/form'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(data1));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body) as Map;
        url = responseBody['data']['payment_url'];
        print('yyyyyyyyyyyyyy ' + url.toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //insertNotification();
    getCountryAvailableOnAPi();
    NotificationDBcontroller()
        .insert(NotificationModel(
            4,
            'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
            'titre4',
            'description4',
            'type4',
            false))
        .then((value) {
      NotificationDBcontroller().liste().then((value) {
        setState(() {
          notifs = value as List;
        });
      });
    });

    super.initState();
  }

  Future getCountryAvailableOnAPi() async {
    var token = await SharedPreferencesHelper.getValue('token');

    int userCountryId = 0;

    var response1 = await http.get(
      Uri.parse('$baseApiUrl/user/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response1.statusCode == 200 || response1.statusCode == 201) {
      userCountryId = int.parse(jsonDecode(response1.body)['data']['pays_id']);
    }

    var response = await http.get(
      Uri.parse('$baseApiUrl/pays'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        countries = responseBody['data'] as List;
      }
      for (var countrie in countries) {
        if (countrie['id'] == userCountryId) {
          setState(() {
            devises = [countrie['devise']];
          });
        }
      }
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
        ),
        body: Stack(
          children: [
            devises.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: [
                        Container(
                          height: Device.getScreenHeight(context) / 20,
                          decoration:
                              BoxDecoration(color: appColorProvider.primary),
                        ),
                        SizedBox(height: Device.getScreenHeight(context) / 10),
                        Form(
                          key: _keyForm,
                          child: Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  30),
                                      Text(
                                        "Veuillez recharger votre compte pour continuer votre achat",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.w800,
                                            color: appColorProvider.black54),
                                      ),
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              // initialValue: defaultUserProvider.nom,
                                              controller: montantController,
                                              onChanged: ((value) {
                                                setState(() {
                                                  currentMontant = double.parse(
                                                      value.toString());
                                                });
                                              }),
                                              decoration: inputDecorationGrey(
                                                  "Montant à recharger",
                                                  Device.getScreenWidth(
                                                      context)),
                                              validator: (val) => double.parse(
                                                              val.toString()) <=
                                                          150 &&
                                                      val.toString().isNotEmpty
                                                  ? 'Veuillez entrer un montant >= 150'
                                                  : null,
                                              // onChanged: (val) =>
                                              //     defaultUserProvider.nom = val,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: 70,
                                              padding: EdgeInsets.only(
                                                  left: Device
                                                      .getDiviseScreenWidth(
                                                          context, 30)),
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 240, 240, 240),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: DropdownButton(
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                dropdownColor: Colors.white,
                                                focusColor: Colors.black,
                                                style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                ),
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                elevation: 25,
                                                hint: Text(
                                                  devises[0],
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          AppText.p2(context)),
                                                ),

                                                // Not necessary for Option 1
                                                value: currentDevise,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    currentDevise = newValue;
                                                  });
                                                },
                                                items: devises.map((devise) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                      devise,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  AppText.p2(
                                                                      context)),
                                                    ),
                                                    value: devise,
                                                  );
                                                }).toList(),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  40),
                                      TextFormField(
                                        // initialValue: defaultUserProvider.nom,
                                        decoration: printDecorationGrey(
                                            "Frais de rechargement = ${currentMontant * 0.04} ${devises[0]}",
                                            Device.getScreenWidth(context)),

                                        // onChanged: (val) =>
                                        //     defaultUserProvider.nom = val,
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  40),
                                      TextFormField(
                                        // initialValue: defaultUserProvider.nom,
                                        decoration: printDecorationGrey(
                                            "Total à payer = ${currentMontant + currentMontant * 0.04} ${devises[0]} ",
                                            Device.getScreenWidth(context)),

                                        // onChanged: (val) =>
                                        //     defaultUserProvider.nom = val,
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  15),
                                      Text(
                                        "*Frais de rechargement 4%",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            color: appColorProvider.primary),
                                      ),
                                      SizedBox(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  8),
                                      RaisedButtonDecor(
                                        onPressed: isLoading
                                            ? () {}
                                            : () async {
                                                if (_keyForm.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await rechargeCompte(
                                                      double.parse(
                                                          montantController
                                                              .text),
                                                      "MOBILE_MONEY");
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/cinetPayWebView',
                                                    arguments: url,
                                                  );
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              },
                                        elevation: 3,
                                        color: AppColor.primaryColor,
                                        shape: BorderRadius.circular(10),
                                        padding: const EdgeInsets.all(15),
                                        child: isLoading
                                            ? SizedBox(
                                                width:
                                                    Device.getScreenHeight(
                                                            context) /
                                                        40,
                                                height: Device.getScreenHeight(
                                                        context) /
                                                    40,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: appColorProvider.white,
                                                ))
                                            : Text(
                                                "Recharger",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppText.p2(context)),
                                              ),
                                      ),
                                    ],
                                  ),
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
