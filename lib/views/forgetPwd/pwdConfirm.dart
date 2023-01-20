import 'dart:async';
import 'dart:math';

import 'package:cible/constants/localPath.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/forgetPwd/forgetPwdController.dart';
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

class PwdVerification extends StatefulWidget {
  const PwdVerification({Key? key}) : super(key: key);

  @override
  State<PwdVerification> createState() => _PwdVerificationState();
}

class _PwdVerificationState extends State<PwdVerification> {
  String password = '';
  String Confpassword = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var imageType;
  @override
  void initState() {
    super.initState();
    fToast.init(context);
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
                  "Récupération de mots de passe",
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
                                "Nouveau mots de passe",
                                Device.getScreenWidth(context)),
                            onChanged: (val) => password = val,
                            validator: (val) => val.toString().length < 8
                                ? 'veuillez entrer au moins 8 caractères'
                                : null,
                            obscureText: true,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 100),
                          TextFormField(
                            decoration: inputDecorationGrey(
                                "Confirmer le mots de passe",
                                Device.getScreenWidth(context)),
                            onChanged: (val) => this.Confpassword = val,
                            validator: (val) => val.toString().length < 8 &&
                                    this.Confpassword != this.password
                                ? 'Les mots de passe ne correspondent pas !'
                                : null,
                            obscureText: true,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 20),
                          RaisedButtonDecor(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_keyForm.currentState!.validate()) {
                                updatePassword();
                              }
                            },
                            elevation: 3,
                            color: AppColor.primaryColor,
                            shape: BorderRadius.circular(10),
                            padding: const EdgeInsets.all(15),
                            child: _isloading
                                ? const Center(
                                    heightFactor: 0.38,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Valider",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: AppText.p2(context)),
                                  ),
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

  updatePassword() async {
    setState(() {
      _isloading = true;
    });
    if (await updatePasswordFromAPI(context, password)) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/login');
      setState(() {
        _isloading = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastsuccess(context, "Mot de passe mis à jour  ! "));
      });
      return true;
    } else {
      setState(() {
        _isloading = false;
        fToast.showToast(const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu, veuillez ressayer ! "));
      });
      return false;
    }
  }
}
