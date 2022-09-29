// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:cible/core/routes.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/countriesJsonHelper.dart';
import 'package:cible/helpers/dateHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/authUserInfo/authUserInfo.controller.dart';
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
  bool dateError = false;
  Placemark location = new Placemark(isoCountryCode: '', country: '');
  var _selectedLocation;
  List _locations = [];
  bool defautLocationState = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    locationService();
    sexe = Provider.of<DefaultUserProvider>(context, listen: false).sexe;
    print(Provider.of<DefaultUserProvider>(context, listen: false).image);
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
                  child: Provider.of<DefaultUserProvider>(context,
                                      listen: false)
                                  .image ==
                              '' ||
                          Provider.of<DefaultUserProvider>(context,
                                      listen: false)
                                  .image ==
                              null
                      ? Container(
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
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: Provider.of<DefaultUserProvider>(
                                      context,
                                      listen: false)
                                  .image,
                              height: Device.getDiviseScreenHeight(context, 8),
                              width: Device.getDiviseScreenHeight(context, 8)),
                        ),
                ),
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
                                "Nom", Device.getScreenWidth(context)),
                            validator: (val) => val.toString().length < 3
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
                                "Prénom", Device.getScreenWidth(context)),
                            onChanged: (val) =>
                                defaultUserProvider.prenom = val,
                            validator: (val) => val.toString().length < 3
                                ? 'veuillez entrer un prénom valide !'
                                : null,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: CountryCodePicker(
                                    onChanged: (value) {
                                      print(value);
                                    },
                                    dialogSize: Size(
                                        Device.getDiviseScreenWidth(
                                            context, 1.2),
                                        Device.getDiviseScreenHeight(
                                            context, 1.5)),
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection:
                                        this.location.isoCountryCode != ''
                                            ? this.location.isoCountryCode
                                            : '',
                                    favorite: [
                                      this.location.isoCountryCode != ''
                                          ? this
                                              .location
                                              .isoCountryCode
                                              .toString()
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
                                  initialValue: defaultUserProvider.tel1,
                                  decoration: inputDecorationGrey(
                                      "Numéro de téléphone (Sans indicatif)",
                                      Device.getScreenWidth(context)),
                                  onChanged: (val) =>
                                      defaultUserProvider.tel1 = val,
                                  validator: (val) => val.toString().length < 5
                                      ? 'Numéro de téléphone invalide !'
                                      : null,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
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
                              Row(
                                children: [
                                  Radio(
                                    groupValue: sexe,
                                    value: "Indifférent",
                                    onChanged: (i) {
                                      setState(() {
                                        sexe = "Indifférent";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    activeColor: AppColor.primary,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        sexe = "Indifférent";
                                        defaultUserProvider.sexe = sexe;
                                      });
                                    },
                                    child: Text(
                                      "Indifférent",
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
                              SizedBox()
                            ],
                          ),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          InkWell(
                              onTap: () async {
                                date = await datePicker(context);
                                defaultUserProvider.birthday =
                                    DateConvertisseur()
                                        .convertirDatePicker(date);
                                setState(() {});
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LineIcons.calendar,
                                        size: AppText.p2(context),
                                        color: Colors.black45,
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
                                                fontSize:
                                                    Device.getDiviseScreenWidth(
                                                        context, 30),
                                                color: Colors.black45)),
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
                                            color: AppColor.primary)),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                              height: Device.getScreenHeight(context) / 90),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: CountryCodePicker(
                                    onChanged: (value) async {
                                      setState(() {
                                        defaultUserProvider.codeTel1 =
                                            value.toString();
                                        _selectedLocation = null;
                                        _locations =
                                            getCountryCitiesWithCountryCode(
                                                getCountryCodeWithCode(value));
                                      });
                                    },
                                    onInit: (value) {
                                      if (location.isoCountryCode ==
                                          getCountryCitiesWithCountryCode(
                                              getCountryCodeWithCode(value))) {
                                        defaultUserProvider.codeTel1 =
                                            value.toString();
                                        _locations =
                                            getCountryCitiesWithCountryCode(
                                                getCountryCodeWithCode(value));
                                      }
                                    },

                                    dialogSize: Size(
                                        Device.getDiviseScreenWidth(
                                            context, 1.2),
                                        Device.getDiviseScreenHeight(
                                            context, 1.5)),
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection:
                                        this.location.isoCountryCode != ''
                                            ? this.location.isoCountryCode
                                            : '',
                                    favorite: [
                                      this.location.isoCountryCode != ''
                                          ? this
                                              .location
                                              .isoCountryCode
                                              .toString()
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
                        setState(() {
                          _isloading = true;
                        });
                        Provider.of<DefaultUserProvider>(context, listen: false)
                            .pays = location.country.toString();
                        Provider.of<DefaultUserProvider>(context, listen: false)
                                .codeTel1 =
                            getCountryDialCodeWithCountryCode(
                                location.isoCountryCode);
                        if (await register(context)) {
                          setState(() {
                            _isloading = false;
                          });
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
                                ? Container(
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
}
