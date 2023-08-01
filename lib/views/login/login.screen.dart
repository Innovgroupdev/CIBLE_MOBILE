// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cible/constants/api.dart';
import 'package:cible/constants/localPath.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:cible/views/login/login.controller.dart';
import 'package:cible/views/login/login.widgets.dart';
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
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String nom = '';
  String prenom = '';
  String tel = '';
  String codeTel = '';
  String erreur = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  var etat = 0;
  String countryCode = '';
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var imageType;
  @override
  void initState() {
    super.initState();
    getUserLocation();
    Timer(const Duration(seconds: 2), () async {
      Provider.of<DefaultUserProvider>(context, listen: false).imageType =
          await SharedPreferencesHelper.getValue("ppType");
      // defaultAccount();
      // ignore: use_build_context_synchronously
      fToast.init(context);
    });
  }

  getUserLocation() async {
    // ignore: unrelated_type_equality_checks
    Provider.of<AppManagerProvider>(context, listen: false).typeAuth ==
                await SharedPreferencesHelper.getBoolValue("RegisterSMSType") &&
            await SharedPreferencesHelper.getBoolValue("RegisterSMSType") !=
                null
        ? 0
        : 1;
    var response = await http.get(
      Uri.parse('https://ipinfo.io/json'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        countryCode = getCountryDialCodeWithCountryCode(
            jsonDecode(response.body)['country']);
        Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
            countryCode;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  defaultAccount() {
    bool isloading1 = false;
    if (email != '' || tel != '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState1) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: Device.getDiviseScreenHeight(context, 2.7),
                  width: Device.getDiviseScreenWidth(context, 1.2),
                  color: Colors.white,
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
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
                                  Color.fromARGB(255, 212, 212, 212), 100)),
                          SizedBox(
                            width: Device.getDiviseScreenHeight(context, 60),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${prenom} ${nom}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p1(context),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: Text(
                                      email.isNotEmpty &&
                                              Provider.of<AppManagerProvider>(
                                                          context,
                                                          listen: false)
                                                      .typeAuth ==
                                                  1
                                          ? email
                                          : tel.contains('+') ||
                                                  tel.startsWith('00')
                                              ? 'tel : ' + tel
                                              : 'tel : ' +
                                                  countryCode +
                                                  ' ' +
                                                  tel,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p3(context),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
                                Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .email1 = email;
                                Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .tel1 = tel;
                                Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .codeTel1 = countryCode;
                                Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .password = password;
                                setState1(() {
                                  isloading1 = true;
                                });
                                if (await loginUser(
                                    context,
                                    Provider.of<DefaultUserProvider>(context,
                                            listen: false)
                                        .toDefaulUserModel)) {
                                  await updateFcmToken();
                                } else {
                                  setState(() {
                                    fToast.showToast(
                                        fadeDuration:
                                            const Duration(milliseconds: 500),
                                        child: toastError(context,
                                            "Une erreur est survenu , veuillez ressayer ! "));
                                  });
                                }
                                setState1(() {
                                  isloading1 = false;
                                });
                              },
                              elevation: 0,
                              color: AppColor.primaryColor,
                              shape: BorderRadius.circular(10),
                              padding: const EdgeInsets.all(15),
                              child: isloading1
                                  ? const Center(
                                      heightFactor: 0.38,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Continuer en tant que ${prenom} ${nom}",
                                      overflow: TextOverflow.ellipsis,
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
          });
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

            if (users.length > 0) {
              Provider.of<DefaultUserProvider>(context, listen: false)
                  .getDBImage(users[0]);
              if (email.trim().isEmpty) {
                email = users[0].email1;
              }

              if (password.trim().isEmpty) {
                password = users[0].password;
              }

              if (users[0].codeTel1.toString().trim().isNotEmpty) {
                countryCode = users[0].codeTel1;
              }

              if (users[0].tel1.toString().isNotEmpty) {
                tel = users[0].tel1;
              }

              nom = users[0].nom;
              prenom = users[0].prenom;
            }

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
                              fontSize: AppText.p2(context),
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
                              fontSize: AppText.titre2(context),
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
                                  countryCode.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TextFormField(
                                          initialValue:
                                              Provider.of<AppManagerProvider>(
                                                              context,
                                                              listen: false)
                                                          .typeAuth ==
                                                      1
                                                  ? email
                                                  : tel.trim().contains('+') ||
                                                          tel
                                                              .trim()
                                                              .startsWith('00')
                                                      ? tel
                                                      : countryCode + tel,
                                          decoration: inputDecorationPrelogged(
                                              context,
                                              "Email ou numéro de téléphone",
                                              Device.getScreenWidth(context)),
                                          validator: (val) {
                                            if (!emailRegex.hasMatch(
                                                val.toString().trim())) {
                                              etat = 1;
                                              if (telRegex(
                                                  val.toString().trim())) {
                                                etat = 2;
                                              } else {
                                                Provider.of<AppManagerProvider>(
                                                        context,
                                                        listen: false)
                                                    .typeAuth = 0;
                                                etat = 0;
                                                return null;
                                              }
                                            } else {
                                              Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: false)
                                                  .typeAuth = 1;
                                              etat = 0;
                                              return null;
                                            }

                                            if (etat != 0) {
                                              setState(() {
                                                _isloading = false;
                                                fToast.showToast(
                                                    fadeDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    child: toastError(context,
                                                        "Adresse email ou Numéro de téléphone invalide !"));
                                              });
                                            }
                                            return null;
                                          },
                                          onChanged: (val) {
                                            if (emailRegex.hasMatch(
                                                val.toString().trim())) {
                                              email = val;
                                              tel = '';
                                            } else {
                                              email = '';
                                              tel = val;
                                            }
                                          },
                                        ),
                                  SizedBox(
                                      height: Device.getScreenHeight(context) /
                                          100),
                                  TextFormField(
                                    initialValue: password,
                                    decoration: inputDecorationPrelogged(
                                        context,
                                        "Mot de passe",
                                        Device.getScreenWidth(context)),
                                    onChanged: (val) => password = val.trim(),
                                    validator: (val) => val.toString().length <
                                            8
                                        ? 'veuillez entrer au moins 8 caractères !'
                                        : null,
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/emailVerification');
                                        },
                                        child: Text(
                                          "Mot de passe oublié ?",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 40),
                                  RaisedButtonDecor(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_keyForm.currentState!.validate() &&
                                          etat == 0) {
                                        setState(() {
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .clearUserInfos();
                                          _isloading = true;
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .email1 = email;
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .password = password;
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .codeTel1 = countryCode;
                                          Provider.of<DefaultUserProvider>(
                                                  context,
                                                  listen: false)
                                              .tel1 = tel;
                                        });

                                        if (Provider.of<DefaultUserProvider>(
                                                        context,
                                                        listen: false)
                                                    .email1 ==
                                                email &&
                                            Provider.of<DefaultUserProvider>(
                                                        context,
                                                        listen: false)
                                                    .password ==
                                                password) {
                                          if (await loginUser(
                                              context,
                                              Provider.of<DefaultUserProvider>(
                                                      context,
                                                      listen: false)
                                                  .toDefaulUserModel)) {
                                            await updateFcmToken();
                                            setState(() {
                                              _isloading = false;
                                            });
                                          } else {
                                            setState(() {
                                              _isloading = false;
                                              Timer(const Duration(seconds: 4),
                                                  () async {
                                                defaultAccount();
                                              });
                                              fToast.showToast(
                                                  fadeDuration: const Duration(
                                                      milliseconds: 1000),
                                                  child: toastError(context,
                                                      "Identifiant ou mot de passe incorrecte !"));
                                            });
                                          }
                                        }
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
                                    erreur,
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          Device.getScreenHeight(context) / 50),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       height: 0.5,
                                  //       width: Device.getDiviseScreenWidth(
                                  //           context, 3.5),
                                  //       color: Colors.black54,
                                  //     ),
                                  //     SizedBox(width: 14),
                                  //     Text(
                                  //       'Ou',
                                  //       style: GoogleFonts.poppins(
                                  //           color: Colors.black54,
                                  //           fontWeight: FontWeight.w500,
                                  //           fontSize: AppText.p1(context)),
                                  //     ),
                                  //     SizedBox(width: 14),
                                  //     Container(
                                  //       height: 0.5,
                                  //       width: Device.getDiviseScreenWidth(
                                  //           context, 3.5),
                                  //       color: Colors.black54,
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //     height:
                                  //         Device.getScreenHeight(context) / 50),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.blue[900],
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //       ),
                                  //       child: IconButton(
                                  //         icon: const Icon(LineIcons.facebookF),
                                  //         onPressed: () async {
                                  //           showFacebookAuthDialog(context);
                                  //         },
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 14),
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         gradient: const LinearGradient(
                                  //           begin: Alignment.topRight,
                                  //           end: Alignment.bottomRight,
                                  //           colors: [
                                  //             Colors.purple,
                                  //             Colors.pink,
                                  //             Colors.orange,
                                  //           ],
                                  //         ),
                                  //         // color: Colors.blue[900],
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //       ),
                                  //       child: IconButton(
                                  //         icon: const Icon(LineIcons.instagram),
                                  //         onPressed: () async {
                                  //           await showInstagramAuthDialog(
                                  //               context);
                                  //         },
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 14),
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.blue[400],
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //       ),
                                  //       child: IconButton(
                                  //         icon:
                                  //             const Icon(LineIcons.linkedinIn),
                                  //         onPressed: () async {
                                  //           await showLinkedinAuthDialog(
                                  //               context);
                                  //         },
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //     height:
                                  //         Device.getScreenHeight(context) / 15),

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
