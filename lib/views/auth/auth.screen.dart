import 'dart:async';
import 'dart:convert';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/register.dart';
import 'package:cible/views/auth/auth.controller.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: library_prefixes
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:line_icons/line_icons.dart';
import 'package:cible/core/routes.dart';
import 'package:cible/helpers/regexHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String email = '';
  String password = '';
  String erreur = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  // Linkedin auth

  @override
  void initState() {
    super.initState();
    clearProvider();
    fToast.init(context);
  }

  clearProvider() {
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(1);
    });
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
              image: AssetImage("assets/images/auth.jpg"),
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
                  "Ayez une longueur d'avance",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p1(context),
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Text(
                  "INSCRIPTION",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.titre1(context),
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
                          Consumer<DefaultUserProvider>(
                              builder: (context, defaultUserProvider, child) {
                            return TextFormField(
                              initialValue: defaultUserProvider.email1,
                              decoration: inputDecorationGrey(
                                  "Email", Device.getScreenWidth(context)),
                              validator: (val) => !emailRegex
                                      .hasMatch(val.toString().trim())
                                  ? 'veuillez entrer une adresse mail valide !'
                                  : null,
                              onChanged: (val) => email = val,
                            );
                          }),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Consumer<DefaultUserProvider>(
                              builder: (context, defaultUserProvider, child) {
                            return TextFormField(
                              initialValue: defaultUserProvider.password,
                              decoration: inputDecorationGrey("Mots de passe",
                                  Device.getScreenWidth(context)),
                              onChanged: (val) => this.password = val.trim(),
                              validator: (val) => val.toString().length < 8
                                  ? 'veuillez entrer au moins 8 caractères !'
                                  : null,
                              obscureText: true,
                            );
                          }),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 40),
                          RaisedButtonDecor(
                            onPressed: () async {
                              setState(() {
                                if (_keyForm.currentState!.validate()) {
                                  _isloading = true;
                                  Provider.of<DefaultUserProvider>(context,
                                          listen: false)
                                      .clear();
                                  print('email =' + email);
                                  Provider.of<DefaultUserProvider>(context,
                                          listen: false)
                                      .email1 = email;
                                  Provider.of<DefaultUserProvider>(context,
                                          listen: false)
                                      .password = password;
                                  print('email provider =' +
                                      Provider.of<DefaultUserProvider>(context,
                                              listen: false)
                                          .email1);
                                  verifieMail();
                                  // connexion(this.email, this.password);
                                } else {
                                  setState(() {
                                    _isloading = false;
                                  });
                                }
                              });
                              // Vérification email !
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
                                    "S'inscrire",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: AppText.p2(context)),
                                  ),
                          ),
                          Text(
                            this.erreur,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.5,
                                width:
                                    Device.getDiviseScreenWidth(context, 3.5),
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Ou',
                                style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppText.p1(context)),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                height: 0.5,
                                width:
                                    Device.getDiviseScreenWidth(context, 3.5),
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[900],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(LineIcons.facebookF),
                                  onPressed: () async {
                                    showFacebookAuthDialog(context);
                                  },
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.purple,
                                      Colors.pink,
                                      Colors.orange,
                                    ],
                                  ),
                                  // color: Colors.blue[900],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(LineIcons.instagram),
                                  onPressed: () async {
                                    await showInstagramAuthDialog(context);
                                  },
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(LineIcons.linkedinIn),
                                  onPressed: () async {
                                    await showLinkedinAuthDialog(context);
                                  },
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 15),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                  width: 0.7, color: Colors.black26),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "J'ai déjà un compte",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: AppText.p2(context)),
                                  ),
                                ]),
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 50),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                  width: 0.7, color: Colors.black26),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Plus tard",
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

  verifieMail() async {
    if (await verifieEmailInApi(
            Provider.of<DefaultUserProvider>(context, listen: false).email1) ==
        0) {
      setState(() {
        _isloading = false;
        fToast.showToast(
            fadeDuration: 1000,
            child: toastError(
                context, "Cette adresse email a déjà été utilisé !"));
      });
    } else if (await verifieEmailInApi(
            Provider.of<DefaultUserProvider>(context, listen: false).email1) ==
        1) {
      await SharedPreferencesHelper.setValue('password', password);
      Navigator.pushNamed(context, "/actions",
          arguments: {'email': email, 'password': password});
      _isloading = false;
    } else if (await verifieEmailInApi(
            Provider.of<DefaultUserProvider>(context, listen: false).email1) ==
        2) {
      setState(() {
        _isloading = false;
        fToast.showToast(
            fadeDuration: 500,
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }
}
