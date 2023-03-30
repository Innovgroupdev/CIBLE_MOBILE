import 'dart:convert';

import 'package:cible/providers/eventsProvider.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../constants/api.dart';
import '../database/parametreDBcontroller.dart';
import '../helpers/screenSizeHelper.dart';
import '../helpers/sharePreferenceHelper.dart';
import '../helpers/textHelper.dart';
import '../models/categorie.dart';
import '../providers/appColorsProvider.dart';
import '../providers/appManagerProvider.dart';


class Parametrage extends StatefulWidget {
  Parametrage({Key? key}) : super(key: key);

  @override
  State<Parametrage> createState() => _ParametrageState();
}

class _ParametrageState extends State<Parametrage> {


  FToast fToast = FToast();
  var _selectedLieu;
  var categorieIdSelected;
  List<dynamic> _categories = [];
  List? _data;
  List _lieux = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLieuxFromAPI();
    getCategories();
  }

   getLieuxFromAPI() async {
    var token = await SharedPreferencesHelper.getValue('token');
    List data = [];
    var response = await http.get(
      Uri.parse('$baseApiUrl/events/ville'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(response.body)['data'];
      

      Provider.of<EventsProvider>(context, listen: false).setEventsLieux(data);
      //print("helllllllllll"+Provider.of<EventsProvider>(context, listen: false).eventsLieux.toString());
      setState(() {
    _data = Provider.of<EventsProvider>(context, listen: false).eventsLieux;
      });

      for (var i = 0; i < data.length; i++) {
        _lieux.add(data[i]['lieu']);
      }
    }
  }

    getCategories() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/categories/list'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {

      setState(() {
        _categories =  getCategorieFromMap(jsonDecode(response.body)['data'] as List);
      });
    }
  }

    getCategorieFromMap(List categorieListFromAPI) {
    final List<Categorie> tagObjs = [];
    for (var element in categorieListFromAPI) {
      var categorie = Categorie.fromMap(element);
        tagObjs.add(categorie);
    }
    return tagObjs;
  }

  @override
  Widget build(BuildContext context) {
     fToast.init(context);
    return 
    Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return 
    Scaffold(
      backgroundColor: appColorProvider.grey2,
      appBar: AppBar(
            backgroundColor: appColorProvider.grey2,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: appColorProvider.black54,
              onPressed: () {
                Provider.of<AppManagerProvider>(context, listen: false)
                    .userTemp = {};
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Paramétrage",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54,
              ),
            ),
          ),
          body: 
          _categories.isEmpty || _data == null
        ? 
          const Center(child:  CircularProgressIndicator()):
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                  height: Device.getDiviseScreenHeight(context, 20),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: Device.getDiviseScreenHeight(context, 90),
                        left: Device.getDiviseScreenWidth(context, 30),
                        right: Device.getDiviseScreenWidth(context, 30)),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _data!.length,
                    itemExtent: Device.getDiviseScreenWidth(context, 5),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (() {
                          setState(() {
                            print('douuuu'+_data![index]['lieu']);
                            if(_selectedLieu == _data![index]['lieu'])
                            {
                              _selectedLieu = '';
                            }else{
                              _selectedLieu = _data![index]['lieu'];
                            }
                              });
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: 
                            _selectedLieu == _data![index]['lieu']?
                                appColorProvider.white:
                                appColorProvider.primaryColor4,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            right: Device.getDiviseScreenHeight(context, 150),
                          ),
                          child: Center(
                            child: Text(
                              _data![index]['lieu'] ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: 
                                appColorProvider.primaryColor1,
                                fontSize: AppText.p4(context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
               SizedBox(
                    height: Device.getScreenHeight(context) / 100,
                  ),
                     Padding(
            padding: EdgeInsets.only(
                top: Device.getScreenHeight(context) / 100,
                left: Device.getScreenHeight(context) / 100),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Device.getScreenHeight(context) / 100,
                  ),
                  Text(
                    "Veuillez choisir une ou plusieurs catégories",
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        fontSize: AppText.p2(context),
                        fontWeight: FontWeight.bold,
                        color: appColorProvider.black87),
                  ),
                  SizedBox(
                    height: Device.getScreenHeight(context) / 200,
                  ),
                  Text(
                    "à quelles catégories d'évènements voulez vous souscrire ?",
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        fontSize: AppText.p3(context),
                        fontWeight: FontWeight.w300,
                        color: appColorProvider.black54),
                  ),
                  SizedBox(
                    height: Device.getScreenHeight(context) / 50,
                  ),
                  _categories.isEmpty?
                  SizedBox(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? Device.getStaticDeviseScreenHeight(context, 1.6)
                        : Device.getStaticDeviseScreenHeight(context, 1.9),
                    child: const Center(child: CircularProgressIndicator())):
                  SizedBox(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? Device.getStaticDeviseScreenHeight(context, 1.6)
                        : Device.getStaticDeviseScreenHeight(context, 1.9),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2,
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              print('diiiiiiiii'+_categories[index].id.toString());
                              for (int i = 0; i < _categories.length; i++) {
                                _categories[i].checked = false;
                              }
                              _categories[index].changeEtat();
                              if (_categories[index].checked) {
                                // Provider.of<EventCreateProvider>(context,
                                //         listen: false)
                                //     .categorie = _categories[index];
                              }
                              categorieIdSelected = _categories[index].id;
                            });
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: appColorProvider.primary
                                              .withOpacity(0.4),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _categories[index].image),
                                            fit: BoxFit.cover,
                                          )),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: appColorProvider.primary
                                              .withOpacity(0.6),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromARGB(255, 59, 111, 145),
                                              Color.fromARGB(255, 60, 28, 119),
                                              Color.fromARGB(255, 83, 23, 94),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _categories[index].titre,
                                            style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                fontSize: AppText.p2(context),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              Positioned(
                                  left:
                                      Device.getDiviseScreenWidth(context, 50),
                                  top: Device.getDiviseScreenHeight(
                                      context, 100),
                                  child: Container(
                                    width: 17,
                                    height: 17,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: _categories[index].checked
                                                ? appColorProvider.primaryColor1
                                                : const Color.fromARGB(
                                                    31, 151, 151, 151)),
                                        color: _categories[index].checked
                                            ? Color.fromARGB(255, 76, 207, 24)
                                            : Color.fromARGB(
                                                106, 245, 245, 245),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Icon(
                                      LineIcons.check,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                Positioned(
            bottom: Device.getDiviseScreenHeight(context, 50),
            child: SizedBox(
              width: Device.getDiviseScreenWidth(context, 1) -
                  Device.getDiviseScreenWidth(context, 30) * 2,
              child: Container(
                padding: EdgeInsets.only(
                    left: Device.getDiviseScreenWidth(context, 50),
                    bottom: Device.getDiviseScreenHeight(context, 50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButtonDecor(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 0,
                      color: Colors.white,
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
                        if(categorieIdSelected != null && _selectedLieu != null && _selectedLieu != ''){
                        await ParametreDBcontroller().insert(categorieIdSelected,_selectedLieu);
                        ParametreDBcontroller().liste().then((value) => print('ouuuuuuuu'+value[0]['id_categorie'].toString()));

                      fToast.showToast(
                                                        fadeDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        child: toastsuccess(
                                                            context,
                                                            "Vos paramètres ont été mise à jour avec succès"));
                      
                        }else{
                          fToast.showToast(
                                                        fadeDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        child: toastError(
                                                            context,
                                                            "Vous devez sélectionner une catégorie et une ville "));
                        }
                      },
                      elevation: 3,
                      color: appColorProvider.primaryColor1,
                      shape: BorderRadius.circular(10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: 
                            // _loading
                            //     ? const Center(
                            //         heightFactor: 0.38,
                            //         child: CircularProgressIndicator(
                            //           backgroundColor: Colors.white,
                            //         ),
                            //       )
                            //     : 
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Enregistrer",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: AppText.p2(context)),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.save,
                                        size: AppText.p2(context),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          )
                        ],
                      ),
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
          
            ],
          ),
    );
      });
  }
}