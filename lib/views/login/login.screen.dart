import 'dart:async';
import 'dart:math';

import 'package:cible/constants/localPath.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:cible/views/login/login.controller.dart';
import 'package:cible/views/login/login.widgets.dart';
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String erreur = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var imageType;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      Provider.of<DefaultUserProvider>(context, listen: false).imageType =
          await SharedPreferencesHelper.getValue("ppType");
      defaultAccount();
    });
  }

  defaultAccount() {
    int lent =
        "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}"
            .length;
    if (email != '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: Device.getDiviseScreenHeight(context, 2.9),
                width: Device.getDiviseScreenWidth(context, 1.2),
                color: Colors.white,
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo_blanc.png"),
                            fit: BoxFit.cover,
                          )),
                      height: Device.getDiviseScreenHeight(context, 11),
                      width: Device.getDiviseScreenHeight(context, 11),
                    ),
                    SizedBox(
                      height: Device.getScreenHeight(context) / 100,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: Device.getDiviseScreenHeight(context, 15),
                            width: Device.getDiviseScreenHeight(context, 15),
                            child: photoProfil(context,
                                const Color.fromARGB(255, 212, 212, 212), 100)),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lent > 26
                                  ? "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}"
                                          .substring(0, 26) +
                                      '...'
                                  : '${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p1(context),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87),
                            ),
                            Text(
                              "$email",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p3(context),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: Device.getScreenHeight(context) / 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RaisedButtonDecor(
                            onPressed: () async {
                              // Navigator.pop(context);
                              if (await loginUser(
                                  context,
                                  Provider.of<DefaultUserProvider>(context,
                                          listen: false)
                                      .toDefaulUserModel)) {
                                setState(() {
                                  _isloading = true;
                                });
                              } else {
                                setState(() {
                                  _isloading = false;
                                  fToast.showToast(
                                      fadeDuration: 500,
                                      child: toastError(context,
                                          "Une erreur est survenu , veuillez ressayer ! "));
                                });
                              }
                            },
                            elevation: 0,
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
                                    lent > 23
                                        ? "Continuer en tant que ${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}"
                                                .substring(0, 43) +
                                            '...'
                                        : "Continuer en tant que ${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: AppText.p3(context)),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserDBcontroller().liste(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List users = snapshot.data as List;
            Provider.of<DefaultUserProvider>(context, listen: false)
                .fromDefaultUser(users[0]);
            email =
                Provider.of<DefaultUserProvider>(context, listen: false).email1;
            password = Provider.of<DefaultUserProvider>(context, listen: false)
                .password;
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
                        SizedBox(
                          height: Device.getScreenHeight(context) / 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_blanc.png"),
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
                          "CONNEXION",
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
                                  vertical:
                                      Device.getScreenHeight(context) / 50),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue:
                                        Provider.of<DefaultUserProvider>(
                                                context,
                                                listen: false)
                                            .email1,
                                    decoration: inputDecoration("Email",
                                        Device.getScreenWidth(context)),
                                    validator: (val) => !emailRegex
                                            .hasMatch(val.toString())
                                        ? 'veuillez entrer une adresse mail valide !'
                                        : null,
                                    onChanged: (val) => this.email = val,
                                  ),
                                  SizedBox(
                                      height: Device.getScreenHeight(context) /
                                          100),
                                  TextFormField(
                                    initialValue:
                                        Provider.of<DefaultUserProvider>(
                                                context,
                                                listen: false)
                                            .password,
                                    decoration: inputDecoration("Mots de passe",
                                        Device.getScreenWidth(context)),
                                    onChanged: (val) => this.password = val,
                                    validator: (val) => val.toString().length <
                                            6
                                        ? 'veuillez entrer au moins 6 caractères'
                                        : null,
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 40),
                                  RaisedButtonDecor(
                                    onPressed: () async {
                                      if (await loginUser(
                                          context,
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .toDefaulUserModel)) {
                                        setState(() {
                                          _isloading = true;
                                        });
                                      } else {
                                        setState(() {
                                          _isloading = false;
                                          fToast.showToast(
                                              fadeDuration: 500,
                                              child: toastError(context,
                                                  "Email ou mots de pass incorrecte ! "));
                                        });
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
                                            "Se connecter",
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
                                      height:
                                          Device.getScreenHeight(context) / 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 0.5,
                                        width: Device.getDiviseScreenWidth(
                                            context, 3.5),
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 14),
                                      Text(
                                        'Ou',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            fontSize: AppText.p1(context)),
                                      ),
                                      SizedBox(width: 14),
                                      Container(
                                        height: 0.5,
                                        width: Device.getDiviseScreenWidth(
                                            context, 3.5),
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[900],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          icon: Icon(LineIcons.facebookF),
                                          onPressed: () {
                                            logFacebook();
                                          },
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.purple,
                                              Colors.pink,
                                              Colors.orange,
                                            ],
                                          ),
                                          // color: Colors.blue[900],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          icon: Icon(LineIcons.instagram),
                                          onPressed: () {},
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: IconButton(
                                          icon: Icon(LineIcons.linkedinIn),
                                          onPressed: () {},
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 15),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/auth");
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                          width: 0.7, color: Colors.black26),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Créer un compte",
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
          } else {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
