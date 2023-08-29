import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/countries_service.dart';
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
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';

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
  var countries;
  String tel = '';
  String etat = '';
  String countryCode = '';
  List<Map<String, String>> finalCountries = [];

  @override
  void initState() {
    super.initState();
    getUserLocation();
    CountriesService().fetchCountries(context).then((value) {
      setState(() {
        finalCountries = value;
      });
    });
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
        // Provider.of<DefaultUserProvider>(context, listen: false).pays =
        //     getCountryNameWithCodeCountry(countryCode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            TabBar(
                              labelColor: AppColor.primary,
                              indicatorColor: AppColor.primary,
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
                              height: Device.getDiviseScreenHeight(context, 10),
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
                                                Device.getScreenWidth(context)),
                                            validator: (val) {
                                              !telRegex(val.toString().trim())
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
                                            onChanged: (val) {
                                              tel = val;
                                              defaultUserProvider.tel1 = val;
                                            },
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
                                      validator: (val) => !emailRegex
                                              .hasMatch(val.toString().trim())
                                          ? "Veuillez entrer une adresse mail valide !"
                                          : null,
                                      onChanged: (val) => email = val,
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Device.getScreenHeight(context) / 15,
                            ),
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
                                    print("etat");
                                    print(etat);
                                    FocusScope.of(context).unfocus();
                                    if (_keyForm.currentState!.validate()) {
                                      submit();
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
                                                child:
                                                    CircularProgressIndicator(
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
                                                        fontSize: AppText.p2(
                                                            context)),
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
      ),
    );
  }

  submit() {
    Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
        countryCode;
    print(countryCode);
    Provider.of<DefaultUserProvider>(context, listen: false).tel1 = tel;
    Provider.of<DefaultUserProvider>(context, listen: false).email1 = email;
    if (Provider.of<DefaultUserProvider>(context, listen: false)
        .email1
        .isNotEmpty) {
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth = 1;
      verification();
      return;
    }
    if (Provider.of<DefaultUserProvider>(context, listen: false)
        .tel1
        .isNotEmpty) {
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth = 0;
      verification();
      return;
    }
  }

  verification() async {
    setState(() {
      _isloading = true;
    });

    var isUserExist;

    isUserExist = await checkUserExistAndSendCode(context);

    if (isUserExist == 0) {
      setState(() {
        _isloading = false;
      });
      fToast.showToast(
          fadeDuration: const Duration(milliseconds: 500),
          child: toastError(context, "Adresse email introuvable !"));
    } else if (isUserExist == 1) {
      Navigator.pushNamed(context, '/verification', arguments: {'email': ""});
      Provider.of<AppManagerProvider>(context, listen: false)
          .forgetPasswd['email'] = "";
      setState(() {
        _isloading = false;
      });
    } else if (isUserExist == 2) {
      setState(() {
        _isloading = false;
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu Veuillez ressayer !"));
      });
    }
  }
}
