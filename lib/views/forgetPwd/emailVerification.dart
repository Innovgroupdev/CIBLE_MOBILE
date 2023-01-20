import 'dart:async';
import 'dart:math';

import 'package:cible/constants/localPath.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/register.dart';
import 'package:cible/views/verification/verification.controller.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../core/routes.dart';
import '../../helpers/regexHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  String email = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var imageType;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          image: DecorationImage(
              image: AssetImage("assets/images/login.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.linearToSrgbGamma(),
              repeat: ImageRepeat.repeat),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo_blanc.png"),
                        fit: BoxFit.cover,
                      )),
                  height: Device.getDiviseScreenHeight(context, 10),
                  width: Device.getDiviseScreenHeight(context, 10),
                ),
                Text(
                  "Ayez une longueur d'avance",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p3(context),
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Text(
                  "Récupération de mot de passe",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.titre4(context),
                      fontWeight: FontWeight.w800,
                      color: Colors.black87),
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
                          TextFormField(
                            decoration: inputDecorationGrey(
                                "Email", Device.getScreenWidth(context)),
                            validator: (val) => !emailRegex
                                    .hasMatch(val.toString().trim())
                                ? 'veuillez entrer une adresse mail valide !'
                                : null,
                            onChanged: (val) => email = val,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButtonDecor(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                elevation: 0,
                                color: Colors.blueGrey[50],
                                shape: BorderRadius.circular(10),
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Retour",
                                  style: GoogleFonts.poppins(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppText.p2(context)),
                                ),
                              ),
                              RaisedButtonDecor(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_keyForm.currentState!.validate()) {
                                    verifieMail();
                                  }
                                },
                                elevation: 3,
                                color: AppColor.primaryColor1,
                                shape: BorderRadius.circular(10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: _isloading
                                          ? const Center(
                                              heightFactor: 0.38,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              ),
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Soumettre",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize:
                                                          AppText.p2(context)),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(
                                                  LineIcons.arrowRight,
                                                  size: AppText.p2(context),
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Device.getDiviseScreenHeight(context, 10),
                          )
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

  verifieMail() async {
    setState(() {
      _isloading = true;
    });
    if (await verifieEmailInApiAndSendMail(email) == 0) {
      Navigator.pushNamed(context, '/verification',
          arguments: {'email': email});
      Provider.of<AppManagerProvider>(context, listen: false)
          .forgetPasswd['email'] = email;
      setState(() {
        _isloading = false;
      });
    } else if (await verifieEmailInApiAndSendMail(email) == 1) {
      setState(() {
        _isloading = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(context, "Adresse email introuvable !"));
      });
    } else if (await verifieEmailInApiAndSendMail(email) == 2) {
      setState(() {
        _isloading = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }
}
