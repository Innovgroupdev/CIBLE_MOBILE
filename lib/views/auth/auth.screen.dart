import 'dart:async';
import 'dart:convert';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/register.dart';
import 'package:cible/views/auth/auth.controller.dart';
import 'package:cible/widgets/counter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';

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
import 'package:country_code_picker/country_code_picker.dart';

import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/api.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String email = '';
  String password = '';
  String erreur = '';
  String tel = '';
  String countryCode = '';
  Map navigation = {};
  bool _isloading = false;
  Map data = {};
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var countries;
  List<Map<String, String>> finalCountries = [];

  // Linkedin auth

  @override
  void initState() {
    super.initState();
    clearProvider();
    getCountryAvailableOnAPi().then((value) {
      setState(() {
        finalCountries = value;
        print('whatttt' + finalCountries.toString());
      });
    });
    getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  clearProvider() {
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
  }

  Future getCountryAvailableOnAPi() async {
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
        finalCountries.add(
          {
            "name": countrie['libelle'],
            "code": countrie['code_pays'],
            "dial_code": countrie['dial_code']
          },
        );
      }
      return finalCountries;
    } else {
      return null;
    }
  }

  getUserLocation() async {
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
            getCountryDialCodeWithCountryCode(countryCode);
        print('iddddddddddddddddd22222 ' + countryCode.toString());
        // Provider.of<DefaultUserProvider>(context, listen: false).pays =
        //     getCountryNameWithCodeCountry(countryCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    Timer(const Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(1);
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            child:
                // countryCode.isEmpty?
                // CircularProgressIndicator():
                SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Device.getScreenHeight(context) / 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/CIBLE 2_1.png"),
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
                        fontSize: AppText.p2(context),
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
                        fontSize: AppText.titre2(context),
                        fontWeight: FontWeight.w800,
                        color: Colors.black87),
                  ),
                  SizedBox(
                    height: Device.getScreenHeight(context) / 50,
                  ),
                  Form(
                    key: _keyForm,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: Device.getScreenHeight(context) / 50),
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: AppColor.primary,
                              unselectedLabelColor: Colors.black54,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelStyle: GoogleFonts.poppins(
                                fontSize: AppText.p3(context),
                                fontWeight: FontWeight.bold,
                              ),
                              tabs: const [
                                Tab(text: 'Numéro de téléphone'),
                                Tab(text: 'Adresse email'),
                              ],
                            ),
                            SizedBox(
                              height: Device.getScreenHeight(context) / 40,
                            ),
                            SizedBox(
                              height: Device.getDiviseScreenHeight(context, 15),
                              child: TabBarView(
                                physics: const BouncingScrollPhysics(),
                                // controller: authController(),
                                children: [
                                  Consumer<DefaultUserProvider>(builder:
                                      (context, defaultUserProvider, child) {
                                    return Row(
                                      children: [
                                        finalCountries.isEmpty
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator())
                                            : Expanded(
                                                flex: 4,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: CountryCodePicker(
                                                    onChanged: (value) {
                                                      print(value);
                                                      countryCode =
                                                          value.toString();
                                                    },
                                                    initialSelection:
                                                        countryCode,
                                                    countryList: finalCountries,
                                                    favorite: [countryCode],
                                                    dialogSize: Size(
                                                        Device
                                                            .getDiviseScreenWidth(
                                                                context, 1.2),
                                                        Device
                                                            .getDiviseScreenHeight(
                                                                context, 1.5)),

                                                    // optional. Shows only country name and flag
                                                    showCountryOnly: false,

                                                    // optional. Shows only country name and flag when popup is closed.
                                                    showOnlyCountryWhenClosed:
                                                        false,

                                                    // optional. aligns the flag and the Text left
                                                    alignLeft: false,
                                                  ),
                                                ),
                                              ),
                                        Expanded(
                                          flex: 9,
                                          child: TextFormField(
                                            initialValue:
                                                defaultUserProvider.tel1,
                                            decoration: inputDecorationGrey(
                                              "Numéro de téléphone",
                                              Device.getScreenWidth(context),
                                            ),
                                            validator: (val) {
                                              telRegex(val.toString().trim())
                                                  ? setState(() {
                                                      _isloading = false;
                                                      fToast.showToast(
                                                          fadeDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          child: toastError(
                                                              context,
                                                              "Numéro de téléphone invalide !"));
                                                    })
                                                  : null;
                                            },
                                            onChanged: (val) => tel = val,
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  Consumer<DefaultUserProvider>(builder:
                                      (context, defaultUserProvider, child) {
                                    return TextFormField(
                                      initialValue: defaultUserProvider.email1,
                                      decoration: inputDecorationGrey("Email",
                                          Device.getScreenWidth(context)),
                                      validator: (val) {
                                        !emailRegex
                                                .hasMatch(val.toString().trim())
                                            ? setState(() {
                                                _isloading = false;
                                                fToast.showToast(
                                                    fadeDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    child: toastError(context,
                                                        "Veuillez entrer une adresse mail valide !"));
                                              })
                                            : null;
                                      },
                                      onChanged: (val) => email = val,
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: Device.getScreenHeight(context) / 90),
                            Consumer<DefaultUserProvider>(
                                builder: (context, defaultUserProvider, child) {
                              return TextFormField(
                                initialValue: defaultUserProvider.password,
                                decoration: inputDecorationGrey("Mot de passe",
                                    Device.getScreenWidth(context)),
                                onChanged: (val) => this.password = val.trim(),
                                validator: (val) {
                                  !passwordRegex.hasMatch(
                                              val.toString().trim()) ||
                                          val.toString().isEmpty
                                      ? setState(() {
                                          _isloading = false;
                                          fToast.showToast(
                                              fadeDuration: const Duration(
                                                  milliseconds: 500),
                                              child: toastError(context,
                                                  "Veuillez inclure au moins une lettre minuscule, une lettre majuscule et un chiffre!"));
                                        })
                                      : null;
                                },
                                obscureText: true,
                              );
                            }),
                            SizedBox(
                                height: Device.getScreenHeight(context) / 40),
                            RaisedButtonDecor(
                              onPressed: () async {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  if (_keyForm.currentState!.validate()) {
                                    if ((emailRegex.hasMatch(
                                                email.toString().trim()) ||
                                            !telRegex(tel.toString().trim())) &&
                                        passwordRegex.hasMatch(
                                            password.toString().trim())) {
                                      _isloading = true;
                                      startRegister();
                                    } else {
                                      setState(() {
                                        _isloading = false;
                                      });
                                    }
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
                            // SizedBox(
                            //     height: Device.getScreenHeight(context) / 50),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       height: 0.5,
                            //       width:
                            //           Device.getDiviseScreenWidth(context, 3.5),
                            //       color: Colors.black54,
                            //     ),
                            //     const SizedBox(width: 14),
                            //     Text(
                            //       'Ou',
                            //       style: GoogleFonts.poppins(
                            //           color: Colors.black54,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: AppText.p1(context)),
                            //     ),
                            //     const SizedBox(width: 14),
                            //     Container(
                            //       height: 0.5,
                            //       width:
                            //           Device.getDiviseScreenWidth(context, 3.5),
                            //       color: Colors.black54,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //     height: Device.getScreenHeight(context) / 50),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.blue[900],
                            //         borderRadius: BorderRadius.circular(50),
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
                            //         borderRadius: BorderRadius.circular(50),
                            //       ),
                            //       child: IconButton(
                            //         icon: const Icon(LineIcons.instagram),
                            //         onPressed: () async {
                            //           await showInstagramAuthDialog(context);
                            //         },
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 14),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.blue[400],
                            //         borderRadius: BorderRadius.circular(50),
                            //       ),
                            //       child: IconButton(
                            //         icon: const Icon(LineIcons.linkedinIn),
                            //         onPressed: () async {
                            //           await showLinkedinAuthDialog(context);
                            //         },
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                                height: Device.getScreenHeight(context) / 25),
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
                                SharedPreferencesHelper.setBoolValue(
                                    "logged", false);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.pushReplacementNamed(
                                    context, '/acceuil');
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
      ),
    );
  }

  startRegister() {
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
    print('email =' + email);
    Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
        countryCode;
    for (var countrie in countries) {
      if (countryCode == countrie['dial_code']) {
        Provider.of<DefaultUserProvider>(context, listen: false).paysId =
            countrie['id'];
      }
    }

    Provider.of<DefaultUserProvider>(context, listen: false).tel1 = tel;
    Provider.of<DefaultUserProvider>(context, listen: false).email1 = email;
    Provider.of<DefaultUserProvider>(context, listen: false).password =
        password;
    print('email provider =' +
        Provider.of<DefaultUserProvider>(context, listen: false).email1);
    if (Provider.of<DefaultUserProvider>(context, listen: false)
        .email1
        .isNotEmpty) {
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth = 1;
      verifieMail();
      return;
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false)
        .tel1
        .isNotEmpty) {
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth = 0;
      verifieNumber();
      print('verifieNumber');
      return;
    }
  }

  // verifieNumber() async {
  //   // print(verifieNumberInApi(tel));
  //   if (await verifieNumberInApi(countryCode,
  //           Provider.of<DefaultUserProvider>(context, listen: false).tel1) ==
  //       0) {
  //     setState(() {
  //       _isloading = false;
  //       email = '';
  //       Provider.of<DefaultUserProvider>(context, listen: false).email1 = '';
  //       fToast.showToast(
  //           fadeDuration: 1000,
  //           child: toastError(
  //               context, "Cette numéro de téléphone déjà été utilisé !"));
  //     });
  //   } else if (await verifieNumberInApi(countryCode,
  //           Provider.of<DefaultUserProvider>(context, listen: false).tel1) ==
  //       1) {
  //     await SharedPreferencesHelper.setValue('password', password);
  //     _isloading = false;
  //     Navigator.pushNamed(context, "/verificationRegister",
  //         arguments: {'email': email, 'password': password});
  //   } else if (await verifieNumberInApi(countryCode,
  //           Provider.of<DefaultUserProvider>(context, listen: false).tel1) ==
  //       2) {
  //     setState(() {
  //       _isloading = false;
  //       email = '';
  //       Provider.of<DefaultUserProvider>(context, listen: false).email1 = '';
  //       fToast.showToast(
  //           500
  //           child: toastError(
  //               context, "Un problème est survenu Veuillez ressayer !"));
  //     });
  //   }
  // }

  verifieNumber() async {
    if (await verifieNumberInApi(countryCode,
            Provider.of<DefaultUserProvider>(context, listen: false).tel1) ==
        0) {
      await SharedPreferencesHelper.setValue('password', password);
      setState(() {
        _isloading = false;
        email = '';
        Provider.of<DefaultUserProvider>(context, listen: false).email1 = '';
        // fToast.showToast(
        //     fadeDuration: const Duration(milliseconds: 1000),
        //     child: toastsuccess(context, "Un SMS vous à été envoyé !"));
      });
      // Navigator.pushNamed(context, "/verificationRegister",
      //     arguments: {'email': email, 'password': password});
      Navigator.pushNamed(context, '/authUserInfo',
          arguments: {'user': {}, 'actions': []});
    } else if (await verifieNumberInApi(countryCode,
            Provider.of<DefaultUserProvider>(context, listen: false).tel1) ==
        1) {
      setState(() {
        _isloading = false;
        email = '';
        Provider.of<DefaultUserProvider>(context, listen: false).email1 = '';
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 1000),
            child: toastError(
                context, "Ce numéro de téléphone a déjà été utilisé !"));
      });
    } else if (await verifieNumberInApi(countryCode,
            Provider.of<DefaultUserProvider>(context, listen: false).tel1) >=
        2) {
      setState(() {
        _isloading = false;
        email = '';
        Provider.of<DefaultUserProvider>(context, listen: false).email1 = '';
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }

  verifieMail() async {
    int isVerify = await
        //verifieEmailInApiForRegister
        verifieEmailInApi(
            Provider.of<DefaultUserProvider>(context, listen: false).email1);
    if (isVerify == 0) {
      // if (isVerify >= 2) {
      //   setState(() {
      //     _isloading = false;
      //     tel = '';
      //     Provider.of<DefaultUserProvider>(context, listen: false).tel1 = '';
      //     fToast.showToast(
      //         500
      //         child: toastError(
      //             context, "Un problème est survenu Veuillez ressayer !"));
      //   });
      // }
      await SharedPreferencesHelper.setValue('password', password);
      setState(() {
        _isloading = false;
        tel = '';
        Provider.of<DefaultUserProvider>(context, listen: false).tel1 = '';
        // fToast.showToast(
        //     fadeDuration: const Duration(milliseconds: 1000),
        //     child: toastsuccess(context, "Un mail vous à été envoyé !"));
      });
      Navigator.pushNamed(context, '/authUserInfo',
          arguments: {'user': {}, 'actions': []});
      // Navigator.pushNamed(context, "/verificationRegister",
      //     arguments: {'email': email, 'password': password});
    } else if (isVerify == 1) {
      setState(() {
        _isloading = false;
        tel = '';
        Provider.of<DefaultUserProvider>(context, listen: false).tel1 = '';
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 1000),
            child: toastError(
                context, "Cette adresse email a déjà été utilisé !"));
      });
    } else if (isVerify >= 2) {
      setState(() {
        _isloading = false;
        tel = '';
        Provider.of<DefaultUserProvider>(context, listen: false).tel1 = '';
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }
}
