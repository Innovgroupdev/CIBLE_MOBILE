import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/verification/verification.controller.dart';
import 'package:cible/views/verification/verification.widgets.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cible/core/routes.dart';
import 'package:cible/helpers/regexHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Device.getDiviseScreenWidth(context, 12)),
        width: Device.getStaticScreenWidth(context),
        height: Device.getStaticScreenHeight(context),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Device.getScreenHeight(context) / 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo_blanc.png"),
                        fit: BoxFit.cover,
                      )),
                  height: Device.getDiviseScreenHeight(context, 8),
                  width: Device.getDiviseScreenHeight(context, 8),
                ),
                Text(
                  "Vérification de mail",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.titre1(context),
                      fontWeight: FontWeight.w800,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Text(
                  "Pour des raisons de sécurité nous devons nous assuré de la validité de votre adresse mail !",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p1(context),
                      fontWeight: FontWeight.w300,
                      color: Colors.black45),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 40,
                ),
                Form(
                  key: _keyForm,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: Device.getScreenHeight(context) / 50),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              inputOTP(context, 1, true, false),
                              inputOTP(context, 2, false, false),
                              inputOTP(context, 3, false, false),
                              inputOTP(context, 4, false, true),
                           
                            ],
                          ),
                          RaisedButtonDecor(
                            onPressed: () {
                              setState(() {
                                verify(context);
                                print(Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .otp);
                              });
                            },
                            elevation: 3,
                            color: AppColor.primaryColor,
                            shape: BorderRadius.circular(10),
                            padding: const EdgeInsets.all(15),
                            child: Consumer<DefaultUserProvider>(
                                builder: (context, defaultUserProvider, child) {
                              return defaultUserProvider.otp['loading']
                                  ? const Center(
                                      heightFactor: 0.38,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Vérifier",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: AppText.p2(context)),
                                    );
                            }),
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 50),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/auth");
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side:
                                  BorderSide(width: 0.7, color: Colors.black26),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Renvoyer un nouveau code",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: AppText.p2(context)),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
