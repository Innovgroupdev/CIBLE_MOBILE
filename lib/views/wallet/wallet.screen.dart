import 'dart:convert';

import 'package:cible/helpers/colorsHelper.dart';
import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/sharePreferenceHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
      var solde;
      List devises = [];
  var countries;

   @override
  initState() {
    getCountryAvailableOnAPi();
    getUserInfo();
    super.initState();
  }

 getUserInfo() async {
    var response;
    var token = await SharedPreferencesHelper.getValue('token');
    response = await http.get(
      Uri.parse('$baseApiUrl/auth/particular/sold'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body) as Map;
      if (responseBody['user'] != null) {
        setState(() {
        solde = double.parse(responseBody['montant']);
      });
        return responseBody;
        }
    } else {
      return false;
    }
  }

        Future getCountryAvailableOnAPi() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/pays'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        countries = responseBody['data'] as List;
      }
      for (var countrie in countries) {
        if(countrie['id'] == Provider.of<DefaultUserProvider>(context, listen: false).paysId){
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
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(
                    //     context, "/moncompte");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 2,
                            color: Provider.of<AppColorProvider>(context,
                                    listen: false)
                                .white)),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Hero(
                          tag: "Image_Profile",
                          child: photoProfil(
                              context, appColorProvider.primaryColor4, 100)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(color: appColorProvider.primaryColor),
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Solde',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p1(context),
                              fontWeight: FontWeight.w500,
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .white),
                        ),
                        devises.isEmpty || solde == null?
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .white,)):
                        RichText(
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${solde}',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.titre2(context),
                                  color: Provider.of<AppColorProvider>(context,
                                          listen: false)
                                      .white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                  text: ' ${devises[0]}',
                                  style: TextStyle(
                                    color: Provider.of<AppColorProvider>(
                                            context,
                                            listen: false)
                                        .white,
                                    fontSize: AppText.titre2(context),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Vous pouvez utiliser votre portefeuille pour effectuer des transactions',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: AppText.p4(context),
                        color: appColorProvider.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/rechargercompte');
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(width: 0.7, color: Colors.white),
                      ),
                      child: Text(
                        "Recharger",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: AppText.p5(context)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "HISTORIQUES",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: appColorProvider.black38,
                      fontSize: AppText.p4(context),
                    ),
                  ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10000),
                                                color: appColorProvider.blue10,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'A',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppText.p3(context),
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        appColorProvider.white,
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
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p2(context),
                                              fontWeight: FontWeight.w800,
                                              color: appColorProvider.black54),
                                        ),
                                        subtitle: Text(
                                          "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w400,
                                              color: appColorProvider.black38),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '12h48mn',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      appColorProvider.black38),
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
                            height: 5,
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
                          Container(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10000),
                                                color: appColorProvider.primary,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'R',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        AppText.p3(context),
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        appColorProvider.white,
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
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p2(context),
                                              fontWeight: FontWeight.w800,
                                              color: appColorProvider.black54),
                                        ),
                                        subtitle: Text(
                                          "Achat de tickets pour le concert de GIMS qui se tiendra le 28 au palais...",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p4(context),
                                              fontWeight: FontWeight.w400,
                                              color: appColorProvider.black38),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '12h48mn',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  fontSize: AppText.p4(context),
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      appColorProvider.black38),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
