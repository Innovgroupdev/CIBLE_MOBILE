// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:cible/core/routes.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/countries_service.dart';
import 'package:cible/services/login.dart';
import 'package:cible/views/authActionChoix/authActionChoix.controller.dart';
import 'package:cible/views/authUserInfo/authUserInfo.controller.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../constants/api.dart';
import '../../helpers/regexHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geocode/geocode.dart';

// import 'package:geocoding_platform_interface/src/models/location.dart'
//     deferred as Location;
// import 'package:location/location.dart';

class AuthUserInfo extends StatefulWidget {
  dynamic data = {};
  AuthUserInfo({Key? key, required this.data}) : super(key: key);

  @override
  State<AuthUserInfo> createState() => _AuthUserInfoState(data);
}

class _AuthUserInfoState extends State<AuthUserInfo> {
  dynamic data;
  _AuthUserInfoState(this.data);

  bool _isloading = false;
  String email = '';
  String password = '';
  String tel1 = '';
  String sexe = '';
  String pays = '';
  String ville = '';
  dynamic date;
  List<dynamic> trancheAge = [
    // '25 ans et moins',
    // 'Entre 26 et 35 ans',
    // 'Entre 36 et 50 ans',
    // 'Entre 51 et 65 ans',
    // '66 ans et plus'
  ];
  int? userAge;
  bool dateError = false;
  Placemark location = new Placemark(isoCountryCode: '', country: '');
  var _selectedLocation;
  List _locations = [];
  bool defautLocationState = false;
  var countryCode = '';
  var city = '';
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  var countries;
  List<Map<String, String>> finalCountries = [];
  @override
  void initState() {
    super.initState();
    // locationService();
    getAllTrancheAge();
    CountriesService().fetchCountries(context).then((value) {
      setState(() {
        finalCountries = value;
      });
    });
    getFcmToken();
    getUserLocation();
    tel1 = Provider.of<DefaultUserProvider>(context, listen: false).tel1;
    email = Provider.of<DefaultUserProvider>(context, listen: false).email1;
    sexe = Provider.of<DefaultUserProvider>(context, listen: false).sexe;
    print(Provider.of<DefaultUserProvider>(context, listen: false).tel1);
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAllTrancheAge() async {
    var response;
    response = await http.get(
      Uri.parse('$baseApiUrl/age-ranges'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $apiKey',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        setState(() {
          trancheAge = responseBody['data'] as List;
        });
      }
      return true;
    } else {
      return false;
    }
  }

  getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = await prefs.getString('fcmToken');
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
      // print(object)
      setState(() {
        countryCode = jsonDecode(response.body)['country'];
        city = jsonDecode(response.body)['city'];
        Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
            getCountryDialCodeWithCountryCode(countryCode);

        // Provider.of<DefaultUserProvider>(context, listen: false).pays =
        //     getCountryNameWithCodeCountry(countryCode);
        // print('pays = ' +
        //     Provider.of<DefaultUserProvider>(context, listen: false).pays);

        _locations = getCountryCitiesWithCountryCode(countryCode);

        if (!_locations.contains(city.toString())) {
          this._locations.add(city.toString());
        }

        print(_locations);
        _selectedLocation = city;
        Provider.of<DefaultUserProvider>(context, listen: false).ville =
            _selectedLocation;
      });
    }
  }

  Future locationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "en");
    // print(placemarks);
    if (placemarks[0] != null && defautLocationState) {
      defautLocationState = true;
    }
    setState(() {
      if (defautLocationState) {
        return;
      } else {
        if (placemarks[0] != null) {
          this.location = placemarks[0];
          Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 =
              getCountryDialCodeWithCountryCode(location.isoCountryCode);
          // Provider.of<DefaultUserProvider>(context, listen: false).pays =
          //     location.country.toString();

          _locations =
              getCountryCitiesWithCountryCode(this.location.isoCountryCode);

          if (!_locations.contains(this.location.locality.toString())) {
            this._locations.add(this.location.locality.toString());
          }

          print(_locations);
          _selectedLocation = this.location.locality;
          Provider.of<DefaultUserProvider>(context, listen: false).ville =
              _selectedLocation;
          defautLocationState = true;
          return;
        } else {
          return;
        }
      }
    });

    // print(this.location);

    return placemarks[0];
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(3);
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
                Hero(
                    tag: "Image_Profile",
                    child: Container(
                        height: Device.getDiviseScreenHeight(context, 10),
                        width: Device.getDiviseScreenHeight(context, 10),
                        child: photoProfil(
                            context, AppColor.primaryColor3, 1000))),
                SizedBox(
                  height: Device.getScreenHeight(context) / 100,
                ),
                Text(
                  "Encore une étape :)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.titre3(context),
                      fontWeight: FontWeight.w800,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Text(
                  "Dans cette partie vous devez renseigner vos informations personnelles",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
                Consumer<DefaultUserProvider>(
                    builder: (context, defaultUserProvider, child) {
                  return Form(
                    key: _keyForm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: Device.getScreenHeight(context) / 50),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: defaultUserProvider.nom,
                            decoration: inputDecorationGrey(
                                "Nom*", Device.getScreenWidth(context)),
                            validator: (val) => val.toString().isEmpty
                                ? 'veuillez entrer un nom valide !'
                                : null,
                            onChanged: (val) => defaultUserProvider.nom = val,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          TextFormField(
                            initialValue: defaultUserProvider.prenom,
                            decoration: inputDecorationGrey(
                                "Prénom*", Device.getScreenWidth(context)),
                            onChanged: (val) =>
                                defaultUserProvider.prenom = val,
                            validator: (val) => val.toString().isEmpty
                                ? 'veuillez entrer un prénom valide !'
                                : null,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .typeAuth ==
                                  1
                              ? Row(
                                  children: [
                                    finalCountries.isEmpty
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator())
                                        : Expanded(
                                            flex: 7,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: CountryCodePicker(
                                                onChanged: (value) {
                                                  countryCode =
                                                      value.toString();
                                                },
                                                countryList: finalCountries,
                                                dialogSize: Size(
                                                    Device.getDiviseScreenWidth(
                                                        context, 1.2),
                                                    Device
                                                        .getDiviseScreenHeight(
                                                            context, 1.5)),
                                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                initialSelection:
                                                    countryCode != ''
                                                        ? countryCode
                                                        : '',
                                                // favorite: [
                                                //   countryCode != ''
                                                //       ? countryCode.toString()
                                                //       : '',
                                                // ],
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
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 9,
                                      child: TextFormField(
                                        initialValue: defaultUserProvider.tel1,
                                        decoration: inputDecorationGrey(
                                            "Numéro de téléphone (Sans indicatif)",
                                            Device.getScreenWidth(context)),
                                        onChanged: (val) =>
                                            defaultUserProvider.tel1 = val,
                                        validator: (val) {
                                          telRegex(val.toString().trim()) ||
                                                  val.toString().isEmpty
                                              ? setState(() {
                                                  _isloading = false;
                                                  fToast.showToast(
                                                      fadeDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      child: toastError(context,
                                                          "Numéro de téléphone invalide !"));
                                                })
                                              : null;
                                        },
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                )
                              : TextFormField(
                                  initialValue: defaultUserProvider.email1,
                                  decoration: inputDecorationGrey(
                                      "Email", Device.getScreenWidth(context)),
                                  validator: (val) => val
                                              .toString()
                                              .isNotEmpty &&
                                          !emailRegex
                                              .hasMatch(val.toString().trim())
                                      ? "Veuillez entrer une adresse mail valide !"
                                      : null,
                                  onChanged: (val) => email = val,
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    groupValue: sexe,
                                    value: "Homme",
                                    onChanged: (i) {
                                      setState(() {
                                        sexe = "Homme";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    activeColor: AppColor.primary,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        sexe = "Homme";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    child: Text(
                                      "Homme",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    groupValue: sexe,
                                    value: "Femme",
                                    onChanged: (i) {
                                      setState(() {
                                        sexe = "Femme";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    activeColor: AppColor.primary,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        sexe = "Femme";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    child: Text(
                                      "Femme",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          fontSize: AppText.p2(context),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Radio(
                              //       groupValue: sexe,
                              //       value: "Indifférent",
                              //       onChanged: (i) {
                              //         setState(() {
                              //           sexe = "Indifférent";
                              //           defaultUserProvider.sexe = sexe;
                              //         });
                              //       },
                              //       activeColor: AppColor.primary,
                              //     ),
                              //     InkWell(
                              //       onTap: () {
                              //         setState(() {
                              //           sexe = "Indifférent";
                              //           defaultUserProvider.sexe = sexe;
                              //         });
                              //       },
                              //       child: Text(
                              //         "Indifférent",
                              //         textAlign: TextAlign.center,
                              //         style: GoogleFonts.poppins(
                              //             textStyle: Theme.of(context)
                              //                 .textTheme
                              //                 .bodyLarge,
                              //             fontSize: AppText.p2(context),
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.black45),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              SizedBox()
                            ],
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          trancheAge == []
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                      Text(
                                        "Votre tranche d'âge",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54),
                                      ),
                                      for (var age in trancheAge) ...[
                                        SizedBox(
                                          height: 40,
                                          child: RadioListTile<dynamic>(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            value: age['id'],
                                            groupValue: userAge,
                                            onChanged: ((value) {
                                              setState(() {
                                                userAge = value;
                                                defaultUserProvider.ageRangeId =
                                                    userAge!;
                                                print('gooooog' +
                                                    defaultUserProvider
                                                        .ageRangeId
                                                        .toString());
                                              });
                                            }),
                                            title: Text(
                                              age['name'],
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: AppText.p2(context),
                                                //  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ])),

                          // InkWell(
                          //     onTap: () async {
                          //       date = await datePicker(context);
                          //       defaultUserProvider.birthday =
                          //           DateConvertisseur()
                          //               .convertirDatePicker(date);
                          //       setState(() {
                          //         defaultUserProvider.birthday =
                          //             DateConvertisseur()
                          //                 .convertirDatePicker(date);
                          //       });
                          //     },
                          //     child: Container(
                          //         padding: const EdgeInsets.all(15),
                          //         decoration: BoxDecoration(
                          //             color: Colors.grey[100],
                          //             borderRadius: const BorderRadius.all(
                          //                 Radius.circular(5))),
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               LineIcons.calendar,
                          //               size: AppText.p2(context),
                          //               color: Colors.black45,
                          //             ),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             Expanded(
                          //               child: Text(
                          //                   defaultUserProvider.birthday == ''
                          //                       ? 'Date de naissance'
                          //                       : defaultUserProvider.birthday,
                          //                   textAlign: TextAlign.start,
                          //                   style: GoogleFonts.poppins(
                          //                       fontSize:
                          //                           Device.getDiviseScreenWidth(
                          //                               context, 30),
                          //                       color: Colors.black45)),
                          //             ),
                          //           ],
                          //         ))),

                          const SizedBox(
                            height: 5,
                          ),
                          date != null &&
                                  DateConvertisseur()
                                      .compareDates(date, DateTime.now())
                              ? Row(
                                  children: [
                                    Text("Date invalide !",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: AppColor.primary)),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Row(
                            children: [
                              finalCountries.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: CountryCodePicker(
                                          countryList: finalCountries,
                                          onChanged: (value) async {
                                            setState(() {
                                              defaultUserProvider.codeTel1 =
                                                  value.toString();
                                              _selectedLocation = null;
                                              _locations =
                                                  getCountryCitiesWithCountryCode(
                                                      getCountryCodeWithCode(
                                                          value));
                                            });
                                          },
                                          onInit: (value) {
                                            if (countryCode ==
                                                getCountryCitiesWithCountryCode(
                                                    getCountryCodeWithCode(
                                                        value))) {
                                              defaultUserProvider.codeTel1 =
                                                  value.toString();
                                              _locations =
                                                  getCountryCitiesWithCountryCode(
                                                      getCountryCodeWithCode(
                                                          value));
                                            }
                                          },

                                          dialogSize: Size(
                                              Device.getDiviseScreenWidth(
                                                  context, 1.2),
                                              Device.getDiviseScreenHeight(
                                                  context, 1.5)),
                                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                          initialSelection: countryCode != ''
                                              ? countryCode
                                              : '',
                                          // favorite: [
                                          //   countryCode != ''
                                          //       ? countryCode.toString()
                                          //       : ''
                                          // ],

                                          // optional. Shows only country name and flag
                                          showCountryOnly: true,
                                          // optional. Shows only country name and flag when popup is closed.
                                          showOnlyCountryWhenClosed: true,

                                          // optional. aligns the flag and the Text left
                                          alignLeft: true,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Container(
                              padding: EdgeInsets.only(
                                  left:
                                      Device.getDiviseScreenWidth(context, 30)),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton(
                                icon: Icon(Icons.arrow_drop_down),
                                dropdownColor: Colors.white,
                                focusColor: Colors.black,
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                elevation: 25,
                                hint: Text(
                                  'Ville',
                                  style: GoogleFonts.poppins(
                                      fontSize: AppText.p2(context)),
                                ),

                                // Not necessary for Option 1
                                value: _selectedLocation,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocation = newValue;
                                    defaultUserProvider.ville =
                                        _selectedLocation;
                                  });
                                },
                                items: _locations.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      location,
                                      style: GoogleFonts.poppins(
                                          fontSize: AppText.p2(context)),
                                    ),
                                    value: location,
                                  );
                                }).toList(),
                              )),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: Device.getScreenHeight(context) / 50,
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
                        FocusScope.of(context).unfocus();
                        if (_keyForm.currentState!.validate()) {
                          if (!telRegex(Provider.of<DefaultUserProvider>(
                                          context,
                                          listen: false)
                                      .tel1
                                      .toString()
                                      .trim()) &&
                                  Provider.of<DefaultUserProvider>(context,
                                          listen: false)
                                      .tel1
                                      .toString()
                                      .isNotEmpty ||
                              Provider.of<DefaultUserProvider>(context,
                                      listen: false)
                                  .tel1
                                  .toString()
                                  .isEmpty) {
                            setState(() {
                              _isloading = true;
                            });

                            Provider.of<DefaultUserProvider>(context,
                                    listen: false)
                                .email1 = email;

                            print(countryCode);

                            for (var country in finalCountries) {
                              if (countryCode == country['code']) {
                                Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .paysId = int.parse(country['id']!);
                              }
                            }
                            Provider.of<DefaultUserProvider>(context,
                                        listen: false)
                                    .codeTel1 =
                                getCountryDialCodeWithCountryCode(countryCode);
                            if (await register(context)) {
                              setState(() {
                                _isloading = false;
                              });
                            }
                          }
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
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Suivant",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: AppText.p2(context)),
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
    );
  }

  register(context) async {
    // Insertion via API
    var etat = await registerUserInAPI(
        context,
        Provider.of<DefaultUserProvider>(context, listen: false)
            .toDefaulUserModel);
    if (etat) {
      setState(() {
        _isloading = false;
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 500),
            child:
                toastsuccess(context, "Inscription effectuée avec success ! "));
      });
      if (Provider.of<AppManagerProvider>(context, listen: false).typeAuth ==
          0) {
        await SharedPreferencesHelper.setBoolValue("RegisterSMSType", true);
      }
      List actionSelected =
          Provider.of<DefaultUserProvider>(context, listen: false).actions;
      if (!await loginUser(
          context,
          Provider.of<DefaultUserProvider>(context, listen: false)
              .toDefaulUserModel)) {
        setState(() {
          _isloading = false;
          fToast.showToast(
              fadeDuration: const Duration(milliseconds: 1000),
              child: toastError(context,
                  "Un problème est survenu lors de la connexion, Connectez vous ! "));
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
      final status = await addActionToUser(context, actionSelected);
      return true;
    } else {
      setState(() {
        _isloading = false;
        fToast.showToast(
            fadeDuration: const Duration(milliseconds: 500),
            child: toastError(
                context, "Un problème est survenu lors de l'inscription ! "));
      });
      return false;
    }
  }
}
