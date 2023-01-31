// import 'package:flutter/material.dart';

// import '../../database/notificationDBcontroller.dart';
// import '../../helpers/colorsHelper.dart';
// import '../../helpers/screenSizeHelper.dart';
// import '../../helpers/textHelper.dart';
// import '../../providers/appColorsProvider.dart';
// import '../../providers/appManagerProvider.dart';
// import '../../providers/defaultUser.dart';
// import '../../widgets/formWidget.dart';
// import '../../widgets/photoprofil.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:badges/badges.dart';

// import '../../widgets/raisedButtonDecor.dart';

// class MiseAJourFonc extends StatefulWidget {
//   MiseAJourFonc({Key? key}) : super(key: key);

//   @override
//   State<MiseAJourFonc> createState() => _MiseAJourFoncState();
// }

// class _MiseAJourFoncState extends State<MiseAJourFonc> {
//   dynamic notifs;
//   @override
//   void initState() {
//     // TODO: implement initState
//     //insertNotification();
//     NotificationDBcontroller().insert().then((value) {
//       NotificationDBcontroller().liste().then((value) {
//         setState(() {
//           notifs = value as List;
//         });
//       });
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppColorProvider>(
//         builder: (context, appColorProvider, child) {
//       return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           foregroundColor:
//               Provider.of<AppColorProvider>(context, listen: false).black54,
//           title: Text(
//             "Mise à jour des fonctionnalités",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//                 textStyle: Theme.of(context).textTheme.bodyLarge,
//                 fontSize: AppText.p1(context),
//                 fontWeight: FontWeight.w800,
//                 color: Provider.of<AppColorProvider>(context, listen: false)
//                     .black54),
//           ),
//           centerTitle: true,
//         ),
//         body: Container(
//           child: Column(
//             children: [
//               Container(
//                 height: Device.getScreenHeight(context) / 20,
//                 decoration: BoxDecoration(color: appColorProvider.primary),
//               ),
//               SizedBox(height: Device.getScreenHeight(context) / 30),
//               Expanded(
//                 child: Container(
//                   child: SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Dans cette partie vous devez les actions que vous aurai à mener sur la plateforme",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyLarge,
//                                 fontSize: AppText.p2(context),
//                                 fontWeight: FontWeight.w800,
//                                 color: appColorProvider.black54),
//                           ),
//                           SizedBox(
//                               height: Device.getScreenHeight(context) / 15),
//                           RaisedButtonDecor(
//                             onPressed: () {},
//                             elevation: 3,
//                             color: AppColor.primaryColor,
//                             shape: BorderRadius.circular(10),
//                             padding: const EdgeInsets.all(15),
//                             child: Text(
//                               "Recharger",
//                               style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: AppText.p2(context)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/action.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/authActionChoix/authActionChoix.controller.dart';
import 'package:cible/views/authActionChoix/authActionChoix.widgets.dart';
import 'package:cible/views/login/login.screen.dart';
import 'package:cible/widgets/errorWidget.dart';
import 'package:cible/widgets/formWidget.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/models/action.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../helpers/sharePreferenceHelper.dart';
import '../providers/appColorsProvider.dart';

class MiseAJourFonc extends StatefulWidget {
  dynamic data = {};
  MiseAJourFonc({Key? key, required this.data}) : super(key: key);

  @override
  State<MiseAJourFonc> createState() => _MiseAJourFoncState(data);
}

class _MiseAJourFoncState extends State<MiseAJourFonc> {
  dynamic data;
  _MiseAJourFoncState(this.data);

  bool error = false;
  List<ActionUser> actionSelected = [];
  List userActions = [];
  late int userActionsLength;

  FToast fToast = FToast();
  @override
  void initState() {
    super.initState();
    getAllUserActions(context);
    getActions();
    clearProviderImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAllUserActions(context) async {
    var response;
    var token = await SharedPreferencesHelper.getValue('token');
    response = await http.get(
      Uri.parse('$baseApiUrl/particular/actions'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    //print(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        setState(() {
          userActions = remplieActionListe(responseBody['data'] as List);
          userActionsLength = userActions.length;
        });
      }
      return true;
    } else {
      return false;
    }
  }

  getActions() async {
    var response = await http.get(
      Uri.parse('$baseApiUrl/actions/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    // print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['actions'] != null) {
        setState(() {
          actions = remplieActionListe(responseBody['actions'] as List);
        });
      }
      return true;
    } else {
      return false;
    }
  }

  clearProviderImage() {
    //print(Provider.of<DefaultUserProvider>(context, listen: false).email1);
    Provider.of<DefaultUserProvider>(context, listen: false).clearDBImage();
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    Timer(Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(2);
    });
    return Consumer<AppColorProvider>(
      builder: (context, appColorProvider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            foregroundColor:
                Provider.of<AppColorProvider>(context, listen: false).black54,
            title: Text(
              "Mise à jour des fonctionnalités",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p1(context),
                  fontWeight: FontWeight.w800,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .black54),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Device.getDiviseScreenWidth(context, 12)),
            width: Device.getStaticScreenWidth(context),
            height: Device.getStaticScreenHeight(context),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Device.getScreenHeight(context) / 40,
                    ),
                    Text(
                      "Dans cette partie vous pouvez mettre à jour les actions que vous aurai à mener sur la plateforme",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: AppText.p2(context),
                          fontWeight: FontWeight.w600,
                          color: appColorProvider.black54),
                    ),
                    SizedBox(
                      height: Device.getScreenHeight(context) / 200,
                    ),
                    actions == null && userActions == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? Device.getStaticDeviseScreenHeight(context, 2)
                                : Device.getStaticDeviseScreenHeight(
                                    context, 1.9),
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: actions.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? 2
                                              : 4),
                              itemBuilder: (BuildContext context, int index) {
                                for (var i = 0; i < userActions.length; i++) {
                                  if (userActions[i].titre ==
                                      actions[index].titre) {
                                    actions[index].changeEtat();
                                  }
                                }
                                return Card(
                                  elevation: 3,
                                  shadowColor: Colors.grey[100],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Container(
                                        //       width: 17,
                                        //       height: 17,
                                        //       decoration: BoxDecoration(
                                        //           border: Border.all(
                                        //               color: actions[index].etat
                                        //                   ? AppColor.primaryColor1
                                        //                   : const Color.fromARGB(
                                        //                       31, 151, 151, 151)),
                                        //           color: actions[index].etat
                                        //               ? AppColor.primaryColor1
                                        //               : Colors.grey[100],
                                        //           borderRadius:
                                        //               const BorderRadius.all(
                                        //                   Radius.circular(100))),
                                        //       child: Icon(
                                        //         LineIcons.check,
                                        //         size: 10,
                                        //         color: Colors.white,
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        SizedBox(
                                          width:
                                              Device.getScreenHeight(context) /
                                                  22,
                                          height:
                                              Device.getScreenHeight(context) /
                                                  22,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageUrl: actions[index].image,
                                          ),
                                        ),
                                        Text(
                                          actions[index].titre.length < 30
                                              ? actions[index].titre
                                              : actions[index]
                                                      .titre
                                                      .toString()
                                                      .substring(0, 27) +
                                                  '...',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              fontSize: AppText.p3(context),
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                        Container(
                                          height:
                                              Device.getScreenHeight(context) /
                                                  25,
                                          width:
                                              Device.getScreenHeight(context) /
                                                  7,
                                          child: StatefulBuilder(
                                              builder: (context, setState1) {
                                            return RaisedButtonDecor(
                                              onPressed: (() async {
                                                if (!actions[index].etat) {
                                                  userActionsLength++;
                                                  setState1(() {
                                                    actions[index].changeEtat();
                                                  });

                                                  actionSelected = [
                                                    actions[index]
                                                  ];
                                                  final status =
                                                      await addActionToUser(
                                                          context,
                                                          [actions[index]]);
                                                } else {
                                                  if (actions[index] != null &&
                                                      userActionsLength > 1) {
                                                    userActionsLength--;
                                                    setState1(() {
                                                      actions[index]
                                                          .changeEtat();
                                                    });
                                                    actionSelected = [
                                                      actions[index]
                                                    ];
                                                    final status =
                                                        await deleteActionToUser(
                                                            context,
                                                            actionSelected);
                                                  } else {
                                                    fToast.showToast(
                                                        fadeDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        child: toastError(
                                                            context,
                                                            "Vous devez sélectionner au moins un élément "));
                                                  }
                                                }
                                                if (this
                                                    .actionSelected
                                                    .isNotEmpty) {
                                                  this.error = false;
                                                }
                                              }),
                                              elevation: 3,
                                              color: !actions[index].etat
                                                  ? AppColor.primaryColor1
                                                  : Colors.green,
                                              shape: BorderRadius.circular(10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    !actions[index].etat
                                                        ? "Ajouter"
                                                        : "Retirer",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: AppText.p3(
                                                            context)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    SizedBox(
                      height: Device.getScreenHeight(context) / 50,
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
      },
    );
  }
}
