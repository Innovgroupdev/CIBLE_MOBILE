// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:cible/core/routes.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
// import 'package:cible/views/ModifieIdentite/ModifieIdentite.controller.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../helpers/regexHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:geocode/geocode.dart';

// import 'package:geocoding_platform_interface/src/models/location.dart'
//     deferred as Location;
// import 'package:location/location.dart';

class ModifieIdentite extends StatefulWidget {
  ModifieIdentite({Key? key}) : super(key: key);

  @override
  State<ModifieIdentite> createState() => _ModifieIdentiteState();
}

class _ModifieIdentiteState extends State<ModifieIdentite> {
  String sexe = '';
  dynamic date;
  bool dateError = false;
  String nom = '';
  String prenom = '';

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sexe = Provider.of<DefaultUserProvider>(context, listen: false).sexe;
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(3);
    });
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<DefaultUserProvider>(
                builder: (context, defaultUserProvider, child) {
              return Form(
                key: _keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Nom",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 90),
                    TextFormField(
                      initialValue: defaultUserProvider.nom,
                      decoration: inputDecorationGrey(
                          "Nom", Device.getScreenWidth(context)),
                      validator: (val) => val.toString().length < 3
                          ? 'veuillez entrer un nom valide !'
                          : null,
                      onChanged: (val) {
                        nom = val;
                        if (Provider.of<AppManagerProvider>(context,
                                listen: false)
                            .userTemp
                            .containsKey('nom')) {
                          Provider.of<AppManagerProvider>(context,
                                  listen: false)
                              .userTemp['nom'] = nom;
                        } else {
                          Provider.of<AppManagerProvider>(context,
                                  listen: false)
                              .userTemp
                              .addAll({'nom': nom});
                        }
                      },
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Text(
                      " Prénom(s)",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 90),
                    TextFormField(
                      initialValue: defaultUserProvider.prenom,
                      decoration: inputDecorationGrey(
                          "Prénom", Device.getScreenWidth(context)),
                      onChanged: (val) {
                        prenom = val;
                        if (Provider.of<AppManagerProvider>(context,
                                listen: false)
                            .userTemp
                            .containsKey('prenom')) {
                          Provider.of<AppManagerProvider>(context,
                                  listen: false)
                              .userTemp['prenom'] = prenom;
                        } else {
                          Provider.of<AppManagerProvider>(context,
                                  listen: false)
                              .userTemp
                              .addAll({'prenom': prenom});
                        }
                      },
                      validator: (val) => val.toString().length < 3
                          ? 'veuillez entrer un prénom valide !'
                          : null,
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 90),
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
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              activeColor: appColorProvider.primary,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  sexe = "Homme";
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              child: Text(
                                "Homme",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w400,
                                    color: appColorProvider.black45),
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
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              activeColor: appColorProvider.primary,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  sexe = "Femme";
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              child: Text(
                                "Femme",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w400,
                                    color: appColorProvider.black45),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              groupValue: sexe,
                              value: "Indifférent",
                              onChanged: (i) {
                                setState(() {
                                  sexe = "Indifférent";
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              activeColor: appColorProvider.primary,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  sexe = "Indifférent";
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('sexe')) {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp['sexe'] = sexe;
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'sexe': sexe});
                                  }
                                });
                              },
                              child: Text(
                                "Indifférent",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: AppText.p2(context),
                                    fontWeight: FontWeight.w400,
                                    color: appColorProvider.black45),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Text(
                      " Date de naissance",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 90),
                    InkWell(
                        onTap: () async {
                          date = await datePicker(context);
                          defaultUserProvider.birthday =
                              DateConvertisseur().convertirDatePicker(date);
                          setState(() {
                            if (Provider.of<AppManagerProvider>(context,
                                    listen: false)
                                .userTemp
                                .containsKey('date')) {
                              Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .userTemp['date'] = sexe;
                            } else {
                              Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .userTemp
                                  .addAll({'date': sexe});
                            }
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: appColorProvider.grey2,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              children: [
                                Icon(
                                  LineIcons.calendar,
                                  size: AppText.p2(context),
                                  color: appColorProvider.black45,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                      defaultUserProvider.birthday == ''
                                          ? 'Date de naissance'
                                          : defaultUserProvider.birthday,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          fontSize: Device.getDiviseScreenWidth(
                                              context, 30),
                                          color: appColorProvider.black45)),
                                ),
                              ],
                            ))),
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
                                      color: appColorProvider.primary)),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// =======================================================================================================//
//                                                                                                        //
//                                           CONTACTS UPDATE                                              //
//                                                                                                        //
// =======================================================================================================//

class ModifieContact extends StatefulWidget {
  ModifieContact({Key? key}) : super(key: key);

  @override
  State<ModifieContact> createState() => _ModifieContactState();
}

class _ModifieContactState extends State<ModifieContact> {
  String tel1 = '';
  String tel2 = '';
  String payscode = '';
  Placemark location = new Placemark(isoCountryCode: '', country: '');
  var _selectedLocation;
  List _locations = [];
  bool defautLocationState = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Provider.of<DefaultUserProvider>(context, listen: false).pays == '') {
      locationService();
    } else {
      payscode = getCountryCodeWithCountryName(
          Provider.of<DefaultUserProvider>(context, listen: false).pays);
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
          Provider.of<DefaultUserProvider>(context, listen: false).pays =
              location.country.toString();

          _locations =
              getCountryCitiesWithCountryCode(this.location.isoCountryCode);

          this._locations.add(this.location.locality.toString());

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
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<DefaultUserProvider>(
                builder: (context, defaultUserProvider, child) {
              return Form(
                key: _keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Device.getScreenHeight(context) / 90),
                    Text(
                      " \t\t\tNuméro de téléphone",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: appColorProvider.grey2,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: CountryCodePicker(
                              onChanged: (value) {
                                print(value);
                              },
                              dialogSize: Size(
                                  Device.getDiviseScreenWidth(context, 1.2),
                                  Device.getDiviseScreenHeight(context, 1.5)),
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection:
                                  this.location.isoCountryCode != ''
                                      ? this.location.isoCountryCode
                                      : payscode,
                              favorite: [
                                payscode,
                                this.location.isoCountryCode != ''
                                    ? this.location.isoCountryCode.toString()
                                    : '',
                              ],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,

                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: defaultUserProvider.tel1,
                            decoration: inputDecorationGrey(
                                "Numéro de téléphone (Sans indicatif)",
                                Device.getScreenWidth(context)),
                            onChanged: (val) {
                              tel1 = val;
                              if (Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .userTemp
                                  .containsKey('tel1')) {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp['tel1'] = tel1;
                              } else {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp
                                    .addAll({'tel1': tel1});
                              }
                            },
                            validator: (val) => val.toString().length < 5
                                ? 'Numéro de téléphone invalide !'
                                : null,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Text(
                      " \t\t\tNuméro de téléphone secondaire",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: appColorProvider.grey2,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: CountryCodePicker(
                              onChanged: (value) {
                                print(value);
                              },
                              dialogSize: Size(
                                  Device.getDiviseScreenWidth(context, 1.2),
                                  Device.getDiviseScreenHeight(context, 1.5)),
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection:
                                  this.location.isoCountryCode != ''
                                      ? this.location.isoCountryCode
                                      : payscode,
                              favorite: [
                                payscode,
                                this.location.isoCountryCode != ''
                                    ? this.location.isoCountryCode.toString()
                                    : '',
                              ],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,

                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: defaultUserProvider.tel2,
                            decoration: inputDecorationGrey(
                                "Numéro de téléphone (Sans indicatif)",
                                Device.getScreenWidth(context)),
                            onChanged: (val) {
                              tel2 = val;
                              if (Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .userTemp
                                  .containsKey('tel2')) {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp['tel2'] = tel2;
                              } else {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp
                                    .addAll({'tel2': tel2});
                              }
                            },
                            validator: (val) => val.toString().length < 5
                                ? 'Numéro de téléphone invalide !'
                                : null,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// =======================================================================================================//
//                                                                                                        //
//                                           POSITION UPDATE                                              //
//                                                                                                        //
// =======================================================================================================//

class ModifiePosition extends StatefulWidget {
  ModifiePosition({Key? key}) : super(key: key);

  @override
  State<ModifiePosition> createState() => _ModifiePositionState();
}

class _ModifiePositionState extends State<ModifiePosition> {
  Placemark location = new Placemark(isoCountryCode: '', country: '');
  var _selectedLocation;
  List _locations = [];
  bool defautLocationState = false;
  String payscode = '';
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Provider.of<DefaultUserProvider>(context, listen: false).pays == '') {
      locationService();
    } else {
      payscode = getCountryCodeWithCountryName(
          Provider.of<DefaultUserProvider>(context, listen: false).pays);
      if (Provider.of<DefaultUserProvider>(context, listen: false).ville !=
          '') {
        _selectedLocation =
            Provider.of<DefaultUserProvider>(context, listen: false).ville;
        _locations = getCountryCitiesWithCountryCode(payscode);
        if (!_locations.contains(_selectedLocation)) {
          _locations.add(_selectedLocation);
        }
      }
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
          Provider.of<DefaultUserProvider>(context, listen: false).pays =
              location.country.toString();

          _locations =
              getCountryCitiesWithCountryCode(this.location.isoCountryCode);

          this._locations.add(this.location.locality.toString());

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
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<DefaultUserProvider>(
                builder: (context, defaultUserProvider, child) {
              return Form(
                key: _keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Text(
                      " \t\t\tPays",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: appColorProvider.grey2,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: CountryCodePicker(
                              onChanged: (value) async {
                                setState(() {
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('codeTel1')) {
                                    Provider.of<AppManagerProvider>(context,
                                                listen: false)
                                            .userTemp['codeTel1'] =
                                        value.toString();
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'codeTel1': value.toString()});
                                  }

                                  _selectedLocation = null;
                                  _locations = getCountryCitiesWithCountryCode(
                                      getCountryCodeWithCode(value));
                                });
                              },
                              onInit: (value) {
                                if (location.isoCountryCode ==
                                    getCountryCitiesWithCountryCode(
                                        getCountryCodeWithCode(value))) {
                                  if (Provider.of<AppManagerProvider>(context,
                                          listen: false)
                                      .userTemp
                                      .containsKey('codeTel1')) {
                                    Provider.of<AppManagerProvider>(context,
                                                listen: false)
                                            .userTemp['codeTel1'] =
                                        value.toString();
                                  } else {
                                    Provider.of<AppManagerProvider>(context,
                                            listen: false)
                                        .userTemp
                                        .addAll({'codeTel1': value.toString()});
                                  }
                                  _locations = getCountryCitiesWithCountryCode(
                                      getCountryCodeWithCode(value));
                                }
                              },

                              dialogSize: Size(
                                  Device.getDiviseScreenWidth(context, 1.2),
                                  Device.getDiviseScreenHeight(context, 1.5)),
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection:
                                  this.location.isoCountryCode != ''
                                      ? this.location.isoCountryCode
                                      : payscode,
                              favorite: [
                                payscode,
                                this.location.isoCountryCode != ''
                                    ? this.location.isoCountryCode.toString()
                                    : ''
                              ],

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
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Text(
                      " \t\t\tVille",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p3(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black),
                    ),
                    SizedBox(height: Device.getScreenHeight(context) / 50),
                    Container(
                        padding: EdgeInsets.only(
                            left: Device.getDiviseScreenWidth(context, 30)),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 240, 240, 240),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          icon: Icon(Icons.arrow_drop_down),
                          dropdownColor: appColorProvider.white,
                          focusColor: appColorProvider.black,
                          style: GoogleFonts.lato(
                            color: appColorProvider.black,
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
                              if (Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .userTemp
                                  .containsKey('ville')) {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp['ville'] = _selectedLocation;
                              } else {
                                Provider.of<AppManagerProvider>(context,
                                        listen: false)
                                    .userTemp
                                    .addAll({'ville': _selectedLocation});
                              }
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
              );
            }),
          ],
        ),
      );
    });
  }
}
