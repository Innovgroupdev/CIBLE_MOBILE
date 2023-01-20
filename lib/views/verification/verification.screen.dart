import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/register.dart';
import 'package:cible/views/verification/verification.controller.dart';
import 'package:cible/views/verification/verification.widgets.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cible/core/routes.dart';
import 'package:cible/helpers/regexHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Verification extends StatefulWidget {
  Map data = {};
  Verification({Key? key, required Map data}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState(data: this.data);
}

class _VerificationState extends State<Verification> {
  Map data = {};
  _VerificationState({required Map this.data});
  bool _isloading = false;
  bool _isloading1 = false;
  FToast fToast = FToast();
  final _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    print(data);

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
        child: SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: Device.getDiviseScreenHeight(context, 10)),
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
                      fontSize: AppText.titre2(context),
                      fontWeight: FontWeight.w800,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Text(
                  "Un code de vérification vous été envoyé sur votre adresse mail merci de vérifier !",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Validité du code ",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45),
                              ),
                              Text(
                                "24 heures",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[900]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Device.getScreenHeight(context) / 40,
                          ),
                          RaisedButtonDecor(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                verify12(context);
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
                              renvoieMail();
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
                                  _isloading1
                                      ? const Center(
                                          heightFactor: 0.38,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.black45,
                                          ),
                                        )
                                      : Text(
                                          "Renvoyer un nouveau code",
                                          style: GoogleFonts.poppins(
                                              color: Colors.black87,
                                              fontSize: AppText.p2(context)),
                                        ),
                                ]),
                          ),
                          SizedBox(
                            height: Device.getScreenHeight(context) / 30,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "\nChanger mon adresse mail",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary),
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
        ),
      ),
    );
  }

  verify12(context) async {
    if (await verify(context)) {
      Provider.of<DefaultUserProvider>(context, listen: false).otpPurge();

      Navigator.pop(context);
      Navigator.pushNamed(context, "/pwdVerification");
      setState(() {
        Provider.of<DefaultUserProvider>(context, listen: false)
            .otp['loading'] = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastsuccess(context, "Code validé avec success ! "));
      });
      return true;
    } else {
      setState(() {
        Provider.of<DefaultUserProvider>(context, listen: false)
            .otp['loading'] = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu lors la vérification ! "));
      });
      return false;
    }
  }

  renvoieMail() async {
    setState(() {
      _isloading1 = true;
    });
    if (await verifieEmailInApiAndSendMail(
            Provider.of<AppManagerProvider>(context, listen: false)
                .forgetPasswd['email']) ==
        0) {
      setState(() {
        _isloading1 = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child:
                toastsuccess(context, "Un nouveau code vous a été envoyé !"));
      });
    } else if (await verifieEmailInApiAndSendMail(
            Provider.of<AppManagerProvider>(context, listen: false)
                .forgetPasswd['email']) ==
        1) {
      setState(() {
        _isloading1 = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(context,
                "Adresse email introuvable, Changer d'adresse email !"));
      });
    } else if (await verifieEmailInApiAndSendMail(
            Provider.of<AppManagerProvider>(context, listen: false)
                .forgetPasswd['email']) ==
        2) {
      setState(() {
        _isloading1 = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }
}
