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

class AuthActionChoix extends StatefulWidget {
  dynamic data = {};
  AuthActionChoix({Key? key, required this.data}) : super(key: key);

  @override
  State<AuthActionChoix> createState() => _AuthActionChoixState(data);
}

class _AuthActionChoixState extends State<AuthActionChoix> {
  dynamic data;
  _AuthActionChoixState(this.data);

  bool error = false;
  List<ActionUser> actionSelected = [];

  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  @override
  void initState() {
    super.initState();

    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(2);
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
                  "Veuillez terminer votre inscription",
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
                  "Dans cette partie vous devez les actions que vous aurai à mener sur la plateforme",
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
                SizedBox(
                  height: Device.getScreenHeight(context) / 200,
                ),
                Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Device.getStaticDeviseScreenHeight(context, 2)
                          : Device.getStaticDeviseScreenHeight(context, 1.9),
                  child: Expanded(
                    child: GridView.builder(
                      itemCount: actions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              actions[index].changeEtat();
                              if (actions[index].etat) {
                                actionSelected.add(actions[index]);
                              } else {
                                if (actions[index].etat != null) {
                                  actionSelected.removeAt(
                                      actionSelected.indexOf(actions[index]));
                                }
                              }
                              if (this.actionSelected.isNotEmpty) {
                                this.error = false;
                              }
                            });
                          }),
                          child: Card(
                            elevation: 3,
                            shadowColor: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 17,
                                        height: 17,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: actions[index].etat
                                                    ? AppColor.primaryColor1
                                                    : const Color.fromARGB(
                                                        31, 151, 151, 151)),
                                            color: actions[index].etat
                                                ? AppColor.primaryColor1
                                                : Colors.grey[100],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100))),
                                        child: Icon(
                                          LineIcons.check,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        Device.getScreenHeight(context) / 50,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        actions[index].image != ''
                                            ? actions[index].image
                                            : "",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height:
                                            Device.getScreenHeight(context) /
                                                50,
                                      ),
                                      Text(
                                        actions[index].titre,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            fontSize: AppText.p2(context),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87),
                                      ),
                                    ], //just for testing, will fill with image later
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButtonDecor(
                      onPressed: () {
                        Navigator.pop(context);
                        actionSelected.clear();
                        for (var action in actions) {
                          action.etat = false;
                        }
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
                      onPressed: () {
                        if (this.actionSelected.isNotEmpty) {
                          this.error = false;
                          Navigator.pushNamed(context, '/authUserInfo',
                              arguments: {
                                'user': data,
                                'actions': actionSelected
                              });
                          Provider.of<DefaultUserProvider>(context,
                                  listen: false)
                              .actions = actionSelected;
                        } else {
                          setState(() {
                            fToast.showToast(
                                fadeDuration: 500,
                                child: toastError(context,
                                    "Vous devez sélectionner au moins un élément "));
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
