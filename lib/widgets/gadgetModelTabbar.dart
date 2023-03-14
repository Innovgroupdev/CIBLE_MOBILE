import 'package:cible/models/couleurModel.dart';
import 'package:cible/models/modelGadgetUser.dart';
import 'package:cible/models/tailleModel.dart';
import 'package:cible/providers/gadgetProvider.dart';
import 'package:cible/widgets/GadgetSizeContainer.dart';
import 'package:cible/widgets/popupGadgetDetail.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';

import '../helpers/colorsHelper.dart';
import '../helpers/screenSizeHelper.dart';
import '../helpers/textHelper.dart';
import '../models/gadget.dart';
import '../providers/appColorsProvider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'GadgetColorContainer.dart';

class GadjetModelTabbar extends StatefulWidget {
  GadjetModelTabbar({required this.gadget, Key? key}) : super(key: key);
  Gadget gadget;

  @override
  State<GadjetModelTabbar> createState() => _GadjetModelTabbarState();
}

class _GadjetModelTabbarState extends State<GadjetModelTabbar>
    with TickerProviderStateMixin {
  late PageController tabController;
  int selectedIndex = 0;
  List modelsColors = [
    {
      "libelle" : "gris",
      "couleur": Colors.grey
    },
    {
      "libelle" : "bleu",
      "couleur": Colors.blue
    },
    {
      "libelle" : "vert",
      "couleur": Colors.green
    },
    {
      "libelle" : "rouge",
      "couleur": Colors.red
    },
    {
      "libelle" : "jaune",
      "couleur": Colors.yellow
    },
    {
      "libelle" : "blanc",
      "couleur": Colors.white
    },
    {
      "libelle" : "noir",
      "couleur": Colors.black
    },
    {
      "libelle" : "or",
      "couleur": Color.fromARGB(255, 248, 237, 75)
    },
    {
      "libelle" : "violet",
      "couleur": Colors.purple
    },
    {
      "libelle" : "marron",
      "couleur": Color.fromARGB(255, 61, 12, 12)
    }
  ];

  @override
  void initState() {
    super.initState();
    tabController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return 
             Container(
                      height: 200,
                      child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: tabController,
                              children: [
                                for(var models in widget.gadget.models) ...[
                 
                                               ListView.builder(
                                                physics: const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: 2,
                                                 itemBuilder: (context, snapshot) {
                                                  List finalModelColors = [];
                                                  for(var modelColor in models.couleursModels){
                                                    for(var modelColorRegister in modelsColors){
                                                      
                                                    if(modelColor.libelle == modelColorRegister['libelle']){
                                                      finalModelColors.add(modelColorRegister);
                                                    }
                                                  }
                                                  }
                                                  
                                                  print('biennnnnnn'+finalModelColors.toString());
                                                   return Container(
                                                    height: 500,
                                                     child: Stack(
                                                     // fit: StackFit.expand, 
                                                      
                                                      children: [
                                                                                 Center(
                                                                                   child: Padding(
                                                                                     padding: const EdgeInsets.symmetric(
                                                                                         horizontal: 20),
                                                                                     child: Stack(
                                                                                       alignment: Alignment.center,
                                                                                       children: [
                                                                                         Container(
                                                                                           width: double.infinity,
                                                                                           height: 250,
                                                                                           decoration: BoxDecoration(
                                                      //borderRadius: BorderRadius.circular(10),
                                                      color: appColorProvider.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: appColorProvider.black12,
                                                          spreadRadius: 0.2,
                                                          blurRadius: 2, // changes position of shadow
                                                        ),
                                                      ]),
                                                                                           child: 
                                                                                           Image.asset(
                                                                                             'assets/images/whiteTshirt.jpg',
                                                                                             fit: BoxFit.fitHeight,
                                                                                           ),
                                                                                         ),
                                                                                         Padding(
                                                                           padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                           child: Row(
                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                             children: [
                                                                               InkWell(
                                                                                 onTap: () {
                                                                                   setState(() {
                                                                                     tabController.previousPage(
                                                                                         duration: const Duration(milliseconds: 400),
                                                                                         curve: Curves.easeIn);
                                                                                   });
                                                                                 },
                                                                                 child: Container(
                                                                                   width: 40,
                                                                                   height: 40,
                                                                                   decoration: BoxDecoration(
                                                                                       borderRadius: BorderRadius.circular(1000),
                                                                                       color: appColorProvider.white,
                                                                                       boxShadow: [
                                                                                         BoxShadow(
                                                                                           color: appColorProvider.black12,
                                                                                           spreadRadius: 0.2,
                                                                                           blurRadius: 2, // changes position of shadow
                                                                                         ),
                                                                                       ]),
                                                                                   child: const Icon(Icons.arrow_back_ios),
                                                                                 ),
                                                                               ),
                                                                               InkWell(
                                                                                 onTap: () {
                                                                                   setState(() {
                                                                                     tabController.nextPage(
                                                                                         duration: const Duration(milliseconds: 400),
                                                                                         curve: Curves.easeIn);
                                                                                   });
                                                                                 },
                                                                                 child: Container(
                                                                                     width: 40,
                                                                                     height: 40,
                                                                                     decoration: BoxDecoration(
                                                                                         borderRadius: BorderRadius.circular(1000),
                                                                                         color: appColorProvider.white,
                                                                                         boxShadow: [
                                                                                           BoxShadow(
                                                                                             color: appColorProvider.black12,
                                                                                             spreadRadius: 0.2,
                                                                                             blurRadius: 2, // changes position of shadow
                                                                                           ),
                                                                                         ]),
                                                                                     child: const Icon(Icons.arrow_forward_ios)),
                                                                               )
                                                                             ],
                                                                           ),
                                                                         ),
                                                                      
                                                                                       ],
                                                                                     ),
                                                                                   ),
                                                                                 ),
                                                                                 Align(
                                                                                   alignment: Alignment.topLeft,
                                                                                   child: Padding(
                                                                                     padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                                                                     child: Row(
                                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                       children: [
                                                                                         Image.asset(
                                                                                           'assets/images/priceIcon.png',
                                                                                         ),
                                                                                         Padding(
                                                                                           padding: const EdgeInsets.only(top: 30),
                                                                                           child: Column(
                                                                                             mainAxisSize: MainAxisSize.min,
                                                                                             crossAxisAlignment: CrossAxisAlignment.end,
                                                                                             children: [
                                                      Text(
                                                        models.libelle,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: AppText.p2(context),
                                                          color: appColorProvider.black54,
                                                          //fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        models.couleursModels[0].libelle.toString(),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: AppText.p2(context),
                                                          color: appColorProvider.black54,
                                                          //fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${models.prixCible} ${models.deviseCible}',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: AppText.p1(context),
                                                          color: appColorProvider.primary,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                                                             ],
                                                                                           ),
                                                                                         )
                                                                                       ],
                                                                                     ),
                                                                                   ),
                                                                                 ),
                                                                                 Align(
                                                                                   alignment: Alignment.bottomCenter,
                                                                                   child: Padding(
                                                                                     padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                                                                                     child: SizedBox(
                                                                                       height: 45,
                                                                                       child: Row(
                                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                         children: [
                                                                                           Expanded(
                                                                                             child: OutlinedButton(
                                                      onPressed: () {
                                                        showGadgetModelDetail(context,models);
                                                        // showDialog<void>(
                                                        //   context: context,
                                                        //   barrierDismissible:
                                                        //       true, // user must tap button!
                                                        //   builder: (BuildContext context) {
                                                        //     return Center(
                                                        //       child: ClipRRect(
                                                        //         borderRadius: BorderRadius.circular(
                                                        //             Device.getScreenHeight(
                                                        //                     context) /
                                                        //                 70),
                                                        //         child: Container(
                                                        //           height:
                                                        //               Device.getDiviseScreenHeight(
                                                        //                   context, 1.6),
                                                        //           width:
                                                        //               Device.getDiviseScreenWidth(
                                                        //                   context, 1.2),
                                                        //           color:
                                                        //               Provider.of<AppColorProvider>(
                                                        //                       context,
                                                        //                       listen: false)
                                                        //                   .white,
                                                        //           padding: EdgeInsets.symmetric(
                                                        //               horizontal:
                                                        //                   Device.getScreenWidth(
                                                        //                           context) /
                                                        //                       30,
                                                        //               vertical:
                                                        //                   Device.getScreenHeight(
                                                        //                           context) /
                                                        //                       50),
                                                        //           child: Column(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment.center,
                                                        //             crossAxisAlignment:
                                                        //                 CrossAxisAlignment.start,
                                                        //             children: [
                                                        //               // SizedBox(
                                                        //               //   height: Device.getScreenHeight(context) / 60,
                                                        //               // ),
                                                        //               Container(
                                                        //                 width: double.infinity,
                                                        //                 height: Device
                                                        //                     .getDiviseScreenHeight(
                                                        //                         context, 4),
                                                        //                 decoration: BoxDecoration(
                                                        //                     borderRadius:
                                                        //                         BorderRadius
                                                        //                             .circular(10),
                                                        //                     color: appColorProvider
                                                        //                         .white,
                                                        //                     boxShadow: [
                                                        //                       BoxShadow(
                                                        //                         color:
                                                        //                             appColorProvider
                                                        //                                 .black12,
                                                        //                         spreadRadius: 0.2,
                                                        //                         blurRadius:
                                                        //                             2, // changes position of shadow
                                                        //                       ),
                                                        //                     ]),
                                                        //                 child: Image.asset(
                                                        //                   'assets/images/whiteTshirt.jpg',
                                                        //                   fit: BoxFit.cover,
                                                        //                 ),
                                                        //               ),
                                                        //               SizedBox(
                                                        //                 height:
                                                        //                     Device.getScreenHeight(
                                                        //                             context) /
                                                        //                         40,
                                                        //               ),
                                                        //               Text(
                                                        //                 'Chemise',
                                                        //                 style: GoogleFonts.poppins(
                                                        //                     textStyle:
                                                        //                         Theme.of(context)
                                                        //                             .textTheme
                                                        //                             .bodyLarge,
                                                        //                     fontSize:
                                                        //                         AppText.p2(context),
                                                        //                     color: Provider.of<
                                                        //                                 AppColorProvider>(
                                                        //                             context,
                                                        //                             listen: false)
                                                        //                         .primary,
                                                        //                     fontWeight:
                                                        //                         FontWeight.bold),
                                                        //               ),
                                                                
                                                        //               const SizedBox(
                                                        //                 height: 10,
                                                        //               ),
                                                        //               Text(
                                                        //                 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat ',
                                                        //                 style: GoogleFonts.poppins(
                                                        //                     textStyle:
                                                        //                         Theme.of(context)
                                                        //                             .textTheme
                                                        //                             .bodyLarge,
                                                        //                     fontSize:
                                                        //                         AppText.p3(context),
                                                        //                     color: Provider.of<
                                                        //                                 AppColorProvider>(
                                                        //                             context,
                                                        //                             listen: false)
                                                        //                         .black38),
                                                        //               ),
                                                                
                                                        //               const SizedBox(
                                                        //                 height: 10,
                                                        //               ),
                                                        //               Text(
                                                        //                 'Tailles disponibles',
                                                        //                 style: GoogleFonts.poppins(
                                                        //                     textStyle:
                                                        //                         Theme.of(context)
                                                        //                             .textTheme
                                                        //                             .bodyLarge,
                                                        //                     fontSize:
                                                        //                         AppText.p2(context),
                                                        //                     color: Provider.of<
                                                        //                                 AppColorProvider>(
                                                        //                             context,
                                                        //                             listen: false)
                                                        //                         .primary,
                                                        //                     fontWeight:
                                                        //                         FontWeight.bold),
                                                        //               ),
                                                        //               const SizedBox(
                                                        //                 height: 10,
                                                        //               ),
                                                        //               Row(
                                                        //                 children: [
                                                        //                   Container(
                                                        //                     height: 30,
                                                        //                     width: 40,
                                                        //                     decoration:
                                                        //                         BoxDecoration(
                                                        //                       borderRadius:
                                                        //                           BorderRadius
                                                        //                               .circular(5),
                                                        //                       border: Border.all(
                                                        //                           color:
                                                        //                               appColorProvider
                                                        //                                   .black54),
                                                        //                     ),
                                                        //                     child: Center(
                                                        //                       child: Text(
                                                        //                         'S',
                                                        //                         style: GoogleFonts.poppins(
                                                        //                             textStyle: Theme.of(
                                                        //                                     context)
                                                        //                                 .textTheme
                                                        //                                 .bodyLarge,
                                                        //                             fontSize:
                                                        //                                 AppText.p3(
                                                        //                                     context),
                                                        //                             color: Provider.of<
                                                        //                                         AppColorProvider>(
                                                        //                                     context,
                                                        //                                     listen:
                                                        //                                         false)
                                                        //                                 .black54,
                                                        //                             fontWeight:
                                                        //                                 FontWeight
                                                        //                                     .bold),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   const SizedBox(width: 20),
                                                        //                   Container(
                                                        //                     height: 30,
                                                        //                     width: 40,
                                                        //                     decoration:
                                                        //                         BoxDecoration(
                                                        //                       borderRadius:
                                                        //                           BorderRadius
                                                        //                               .circular(5),
                                                        //                       border: Border.all(
                                                        //                           color:
                                                        //                               appColorProvider
                                                        //                                   .black54),
                                                        //                     ),
                                                        //                     child: Center(
                                                        //                       child: Text(
                                                        //                         'M',
                                                        //                         style: GoogleFonts.poppins(
                                                        //                             textStyle: Theme.of(
                                                        //                                     context)
                                                        //                                 .textTheme
                                                        //                                 .bodyLarge,
                                                        //                             fontSize:
                                                        //                                 AppText.p3(
                                                        //                                     context),
                                                        //                             color: Provider.of<
                                                        //                                         AppColorProvider>(
                                                        //                                     context,
                                                        //                                     listen:
                                                        //                                         false)
                                                        //                                 .black54,
                                                        //                             fontWeight:
                                                        //                                 FontWeight
                                                        //                                     .bold),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   const SizedBox(width: 20),
                                                        //                   Container(
                                                        //                     height: 30,
                                                        //                     width: 40,
                                                        //                     decoration:
                                                        //                         BoxDecoration(
                                                        //                       borderRadius:
                                                        //                           BorderRadius
                                                        //                               .circular(5),
                                                        //                       border: Border.all(
                                                        //                           color:
                                                        //                               appColorProvider
                                                        //                                   .black54),
                                                        //                     ),
                                                        //                     child: Center(
                                                        //                       child: Text(
                                                        //                         'L',
                                                        //                         style: GoogleFonts.poppins(
                                                        //                             textStyle: Theme.of(
                                                        //                                     context)
                                                        //                                 .textTheme
                                                        //                                 .bodyLarge,
                                                        //                             fontSize:
                                                        //                                 AppText.p3(
                                                        //                                     context),
                                                        //                             color: Provider.of<
                                                        //                                         AppColorProvider>(
                                                        //                                     context,
                                                        //                                     listen:
                                                        //                                         false)
                                                        //                                 .black54,
                                                        //                             fontWeight:
                                                        //                                 FontWeight
                                                        //                                     .bold),
                                                        //                       ),
                                                        //                     ),
                                                        //                   )
                                                        //                 ],
                                                        //               ),
                                                                
                                                        //               const SizedBox(
                                                        //                 height: 20,
                                                        //               ),
                                                        //               Text(
                                                        //                 '1500 XOF',
                                                        //                 style: GoogleFonts.poppins(
                                                        //                   fontSize:
                                                        //                       AppText.p1(context),
                                                        //                   color: appColorProvider
                                                        //                       .black,
                                                        //                   fontWeight:
                                                        //                       FontWeight.bold,
                                                        //                 ),
                                                        //               ),
                                                        //             ],
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        // );
                                                      
                                                      },
                                                      style: OutlinedButton.styleFrom(
                                                        padding: EdgeInsets.all(
                                                            Device.getDiviseScreenHeight(
                                                                context, 70)),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        side: BorderSide(
                                                            width: 0.7,
                                                            color: Provider.of<AppColorProvider>(
                                                                    context,
                                                                    listen: false)
                                                                .primary),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Détails",
                                                              style: GoogleFonts.poppins(
                                                                  color:
                                                                      Provider.of<AppColorProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .black87,
                                                                  fontSize: AppText.p2(context)),
                                                            ),
                                                          ]),
                                                                                             ),
                                                                                           ),
                                                                                           const SizedBox(
                                                                                             width: 5,
                                                                                           ),
                                                                                           Expanded(
                                                                                             child: RaisedButtonDecor(
                                                      onPressed: () {
                                                        showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              true, // user must tap button!
                                                          builder: (BuildContext context) {
                                                            TailleModel? sizeSelected;
                                                            String colorSelected = '';
                                                            int quantity = 0;
                                                            return StatefulBuilder(builder: (context, StateSetter setState) {
                                                            return Center(
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(
                                                                    Device.getScreenHeight(
                                                                            context) /
                                                                        70),
                                                                child: Container(
                                                                  height:
                                                                      Device.getDiviseScreenHeight(
                                                                          context, 2),
                                                                  width:
                                                                      Device.getDiviseScreenWidth(
                                                                          context, 1.2),
                                                                  color:
                                                                      Provider.of<AppColorProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .white,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          Device.getScreenWidth(
                                                                                  context) /
                                                                              20,),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            Device.getScreenHeight(
                                                                                    context) /
                                                                                60,
                                                                      ),
                                                                      Center(
                                                                        child: SizedBox(
                                                                          height: 40,
                                                                          child: Image.asset(
                                                                              'assets/images/gadgetIcons.png'),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Text(
                                                                        'Taille',
                                                                        style: GoogleFonts.poppins(
                                                                            textStyle:
                                                                                Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyLarge,
                                                                            fontSize:
                                                                                AppText.p2(context),
                                                                            color: Provider.of<
                                                                                        AppColorProvider>(
                                                                                    context,
                                                                                    listen: false)
                                                                                .black54,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          for(var taille in models.tailleModels)...[
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  sizeSelected =
                                                                                      taille;
                                                                                });
                                                                              },
                                                                              child: GadgetSizeContainer(
                                                                                sizeBorder: 
                                                                                sizeSelected ==
                                                                                          taille
                                                                                      ?null:
                                                                                Border.all(color: appColorProvider.black54),
                                                                                  textColor: sizeSelected !=
                                                                                          taille
                                                                                      ? Provider.of<
                                                                                                  AppColorProvider>(
                                                                                              context,
                                                                                              listen:
                                                                                                  false)
                                                                                          .black54
                                                                                      : appColorProvider
                                                                                          .white,
                                                                                  fillColors:
                                                                                      sizeSelected !=
                                                                                              taille
                                                                                          ? null
                                                                                          : appColorProvider
                                                                                              .primary,
                                                                                  taille: taille.libelle)
                                                                                  ),
                                                                          ]
                                                                          
                                                                          // const SizedBox(width: 20),
                                                                          // GestureDetector(
                                                                          //     onTap: () {
                                                                          //       setState(() {
                                                                          //         sizeSelected =
                                                                          //             'M';
                                                                          //       });
                                                                          //     },
                                                                          //     child:
                                                                          //         GadgetSizeContainer(sizeBorder: 
                                                                          //       sizeSelected ==
                                                                          //                 'M'
                                                                          //             ?null:
                                                                          //       Border.all(color: appColorProvider.black54),
                                                                          //         textColor: sizeSelected !=
                                                                          //                 'M'
                                                                          //             ? Provider.of<
                                                                          //                         AppColorProvider>(
                                                                          //                     context,
                                                                          //                     listen:
                                                                          //                         false)
                                                                          //                 .black54
                                                                          //             : appColorProvider
                                                                          //                 .white,
                                                                          //         fillColors:
                                                                          //             sizeSelected !=
                                                                          //                     'M'
                                                                          //                 ? null
                                                                          //                 : appColorProvider
                                                                          //                     .primary,
                                                                          //         taille: 'M')),
                                                                          // const SizedBox(width: 20),
                                                                          // GestureDetector(
                                                                          //     onTap: () {
                                                                                
                                                                          //       setState(() {
                                                                          //         sizeSelected =
                                                                          //             'L';
                                                                          //       });
                                                                          //     },
                                                                          //     child:
                                                                          //         GadgetSizeContainer(
                                                                          //             sizeBorder: 
                                                                          //       sizeSelected ==
                                                                          //                 'L'
                                                                          //             ?null:
                                                                          //       Border.all(color: appColorProvider.black54),
                                                                          //         textColor: sizeSelected !=
                                                                          //                 'L'
                                                                          //             ? Provider.of<
                                                                          //                         AppColorProvider>(
                                                                          //                     context,
                                                                          //                     listen:
                                                                          //                         false)
                                                                          //                 .black54
                                                                          //             : appColorProvider
                                                                          //                 .white,
                                                                          //         fillColors:
                                                                          //             sizeSelected !=
                                                                          //                     'L'
                                                                          //                 ? null
                                                                          //                 : appColorProvider
                                                                          //                     .primary,
                                                                          //         taille: 'L')),
                                                                        
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            Device.getScreenHeight(
                                                                                    context) /
                                                                                40,
                                                                      ),
                                                                      Text(
                                                                        'Couleurs disponibles',
                                                                        style: GoogleFonts.poppins(
                                                                            textStyle:
                                                                                Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyLarge,
                                                                            fontSize:
                                                                                AppText.p2(context),
                                                                            color: Provider.of<
                                                                                        AppColorProvider>(
                                                                                    context,
                                                                                    listen: false)
                                                                                .black54,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          for(var modelColor in finalModelColors)...[
                                                                             GestureDetector(
                                                                            onTap: (){
                                                                              setState(() {
                                                                                colorSelected = modelColor['libelle'];
                                                                              });
                                                                            },
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: GadgetColorContainer(
                                                                                color: 
                                                                                modelColor['couleur'],
                                                                              icon:
                                                                              colorSelected == modelColor['libelle']?
                                                                              Icon(Icons.done,color: 
                                                                              colorSelected != 'blanc'?
                                                                              appColorProvider.white:appColorProvider.black,):null
                                                                              ),
                                                                            ),
                                                                          ),
                                                                         
                                                                          ]
                                                                         
                                                                         
                                                                      //     const SizedBox(
                                                                      //   width:10,
                                                                      // ),
                                                                      //     GestureDetector(
                                                                      //       onTap: (){
                                                                      //         setState(() {
                                                                      //           colorSelected = 'orange';
                                                                      //         });
                                                                      //       },
                                                                      //       child: GadgetColorContainer(color: appColorProvider.primary,
                                                                      //       icon:
                                                                      //       colorSelected == 'orange'?
                                                                      //       Icon(Icons.done,color: appColorProvider.white,):null
                                                                      //       ),
                                                                      //     ),
                                                                      //     const SizedBox(
                                                                      //   width:10,
                                                                      // ),
                                                                      //     GestureDetector(
                                                                      //       onTap: (){
                                                                      //         setState(() {
                                                                      //           colorSelected = 'grey';
                                                                      //         });
                                                                      //       },
                                                                      //       child: GadgetColorContainer(color: appColorProvider.grey8,
                                                                      //                                                          icon:
                                                                      //       colorSelected == 'grey'?
                                                                      //       Icon(Icons.done,color: appColorProvider.white,):null
                                                                      //       ),
                                                                      //     )
                                                                          
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            Device.getScreenHeight(
                                                                                    context) /
                                                                                40,
                                                                      ),
                                                                      Text(
                                                                        'Quantité',
                                                                        style: GoogleFonts.poppins(
                                                                            textStyle:
                                                                                Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyLarge,
                                                                            fontSize:
                                                                                AppText.p2(context),
                                                                            color: Provider.of<
                                                                                        AppColorProvider>(
                                                                                    context,
                                                                                    listen: false)
                                                                                .black54,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:(){
                                                                              if(quantity>0){
                                                                                setState((){
                                                                                quantity--;
                                                                              });
                                                                              }
                                                                            },
                                                                            child: Container(height: 40,width:40,
                                                                            decoration:BoxDecoration(borderRadius: BorderRadius.circular(1000),
                                                                            color: appColorProvider.white,
                                                                            boxShadow: [
                                                                                                        BoxShadow(
                                                                                                          color: appColorProvider.black26,
                                                                                                          spreadRadius: 1,
                                                                                                          blurRadius: 5, // changes position of shadow
                                                                                                        ),
                                                                                                      ],
                                                                            ),child: const Icon(Icons.remove),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width:20),
                                                                          Text(
                                                                        '$quantity',
                                                                        style: GoogleFonts.poppins(
                                                                            textStyle:
                                                                                Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyLarge,
                                                                            fontSize:
                                                                                AppText.p2(context),
                                                                            color: Provider.of<
                                                                                        AppColorProvider>(
                                                                                    context,
                                                                                    listen: false)
                                                                                .black54,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(width:20),
                                                                          GestureDetector(
                                                                            onTap:(){
                                                                                setState((){
                                                                                quantity++;
                                                                              });
                                                                            },
                                                                            child: Container(height: 40,width:40,
                                                                            decoration:BoxDecoration(borderRadius: BorderRadius.circular(1000),
                                                                            color: appColorProvider.white,
                                                                            boxShadow: [
                                                                                                        BoxShadow(
                                                                                                          color: appColorProvider.black26,
                                                                                                          spreadRadius: 1,
                                                                                                          blurRadius: 5, // changes position of shadow
                                                                                                        ),
                                                                                                      ],
                                                                            ),child: const Icon(Icons.add),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 10,),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: OutlinedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(
                                                                                    context);
                                                                              },
                                                                              style: OutlinedButton
                                                                                  .styleFrom(
                                                                                padding: EdgeInsets
                                                                                    .all(Device
                                                                                        .getDiviseScreenHeight(
                                                                                            context,
                                                                                            70)),
                                                                                shape:
                                                                                    RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                      BorderRadius
                                                                                          .circular(
                                                                                              12),
                                                                                ),
                                                                                side: BorderSide(
                                                                                    width: 0.7,
                                                                                    color: Provider.of<
                                                                                                AppColorProvider>(
                                                                                            context,
                                                                                            listen:
                                                                                                false)
                                                                                        .black26),
                                                                              ),
                                                                              child: Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment
                                                                                          .center,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Annuler",
                                                                                      style: GoogleFonts.poppins(
                                                                                          color: Provider.of<AppColorProvider>(
                                                                                                  context,
                                                                                                  listen:
                                                                                                      false)
                                                                                              .black87,
                                                                                          fontSize:
                                                                                              AppText.p2(
                                                                                                  context)),
                                                                                    ),
                                                                                  ]),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                RaisedButtonDecor(
                                                                              onPressed: () {
                                                                                CouleurModel? finalColorSelected;
                                                                               for(var modelColor in models.couleursModels){
                                                    if(modelColor.libelle == colorSelected){
                                                              finalColorSelected = modelColor;
                                                    }
                                                  print("quantite"+ finalColorSelected.toString()+' '+sizeSelected.toString()+' '+widget.gadget.toString()+
                                                  models.toString()+' '+widget.gadget.eventId.toString()+' '+quantity.toString()  +' '+models.prixCible.toString()
                                                  );
                                              
                                                   }
                                   // print(quantite);
                                    Provider.of<ModelGadgetProvider>(context,
                                            listen: false)
                                        .addGadget(
                                      ModelGadgetUser(
                                          widget.gadget,
                                          models,
                                          sizeSelected!,
                                          finalColorSelected!,
                                          widget.gadget.eventId,
                                          int.parse(quantity.toString()).clamp(1, 10),
                                          (models.prixCible) *
                                              int.parse(quantity.toString()).clamp(1, 10)
                                          ),
                                    );
                                         Navigator.of(context).pop();                                  
                                                                              },
                                                                              elevation: 3,
                                                                              color: AppColor
                                                                                  .primaryColor,
                                                                              shape: BorderRadius
                                                                                  .circular(10),
                                                                              padding:
                                                                                  const EdgeInsets
                                                                                      .all(15),
                                                                              child: Text(
                                                                                "Valider",
                                                                                style: GoogleFonts.poppins(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize:
                                                                                        AppText.p2(
                                                                                            context)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );});},
                                                        );
                                                      },
                                                      elevation: 3,
                                                      color: AppColor.primaryColor,
                                                      shape: BorderRadius.circular(10),
                                                      padding: const EdgeInsets.all(15),
                                                      child: Text(
                                                        "Choisir",
                                                        style: GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: AppText.p2(context)),
                                                      ),
                                                                                             ),
                                                                                           ),
                                                                                         ],
                                                                                       ),
                                                                                     ),
                                                                                   ),
                                                                                 )
                                                                               ]),
                                                   );
                                                 }
                                               ),
                                
                 
                                              ],
                               
                                // Stack(
                                //   fit: StackFit.expand, children: [
                                //   Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 20, vertical: 20),
                                //     child: Container(
                                //       width: double.infinity,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(10),
                                //           color: appColorProvider.white,
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color: appColorProvider.black12,
                                //               spreadRadius: 0.2,
                                //               blurRadius: 2, // changes position of shadow
                                //             ),
                                //           ]),
                                //       child: Image.asset(
                                //         'assets/images/blackTshirst.jpg',
                                //       ),
                                //     ),
                                //   ),
                                //   Align(
                                //     alignment: Alignment.topLeft,
                                //     child: Padding(
                                //       padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Image.asset(
                                //             'assets/images/priceIcon.png',
                                //           ),
                                //           Padding(
                                //             padding: const EdgeInsets.only(top: 30),
                                //             child: Column(
                                //               mainAxisSize: MainAxisSize.min,
                                //               crossAxisAlignment: CrossAxisAlignment.end,
                                //               children: [
                                //                 Text(
                                //                   'Chemise',
                                //                   style: GoogleFonts.poppins(
                                //                     fontSize: AppText.p2(context),
                                //                     color: appColorProvider.black54,
                                //                     //fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //                 Text(
                                //                   'Blanc',
                                //                   style: GoogleFonts.poppins(
                                //                     fontSize: AppText.p2(context),
                                //                     color: appColorProvider.black54,
                                //                     //fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //                 Text(
                                //                   '1500 XOF',
                                //                   style: GoogleFonts.poppins(
                                //                     fontSize: AppText.p1(context),
                                //                     color: appColorProvider.primary,
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                //   Align(
                                //     alignment: Alignment.bottomCenter,
                                //     child: Padding(
                                //       padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                                //       child: SizedBox(
                                //         height: 45,
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Expanded(
                                //               child: OutlinedButton(
                                //                 onPressed: () {
                                //                   showDialog<void>(
                                //                     context: context,
                                //                     barrierDismissible:
                                //                         true, // user must tap button!
                                //                     builder: (BuildContext context) {
                                //                       return Center(
                                //                         child: ClipRRect(
                                //                           borderRadius: BorderRadius.circular(
                                //                               Device.getScreenHeight(
                                //                                       context) /
                                //                                   70),
                                //                           child: Container(
                                //                             height:
                                //                                 Device.getDiviseScreenHeight(
                                //                                     context, 1.6),
                                //                             width:
                                //                                 Device.getDiviseScreenWidth(
                                //                                     context, 1.2),
                                //                             color:
                                //                                 Provider.of<AppColorProvider>(
                                //                                         context,
                                //                                         listen: false)
                                //                                     .white,
                                //                             padding: EdgeInsets.symmetric(
                                //                                 horizontal:
                                //                                     Device.getScreenWidth(
                                //                                             context) /
                                //                                         30,
                                //                                 vertical:
                                //                                     Device.getScreenHeight(
                                //                                             context) /
                                //                                         50),
                                //                             child: Column(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment.center,
                                //                               crossAxisAlignment:
                                //                                   CrossAxisAlignment.start,
                                //                               children: [
                                //                                 // SizedBox(
                                //                                 //   height: Device.getScreenHeight(context) / 60,
                                //                                 // ),
                                //                                 Container(
                                //                                   width: double.infinity,
                                //                                   height: Device
                                //                                       .getDiviseScreenHeight(
                                //                                           context, 4),
                                //                                   decoration: BoxDecoration(
                                //                                       borderRadius:
                                //                                           BorderRadius
                                //                                               .circular(10),
                                //                                       color: appColorProvider
                                //                                           .white,
                                //                                       boxShadow: [
                                //                                         BoxShadow(
                                //                                           color:
                                //                                               appColorProvider
                                //                                                   .black12,
                                //                                           spreadRadius: 0.2,
                                //                                           blurRadius:
                                //                                               2, // changes position of shadow
                                //                                         ),
                                //                                       ]),
                                //                                   child: Image.asset(
                                //                                     'assets/images/blackTshirst.jpg',
                                //                                     fit: BoxFit.cover,
                                //                                   ),
                                //                                 ),
                                //                                 SizedBox(
                                //                                   height:
                                //                                       Device.getScreenHeight(
                                //                                               context) /
                                //                                           40,
                                //                                 ),
                                //                                 Text(
                                //                                   'Chemise',
                                //                                   style: GoogleFonts.poppins(
                                //                                       textStyle:
                                //                                           Theme.of(context)
                                //                                               .textTheme
                                //                                               .bodyLarge,
                                //                                       fontSize:
                                //                                           AppText.p2(context),
                                //                                       color: Provider.of<
                                //                                                   AppColorProvider>(
                                //                                               context,
                                //                                               listen: false)
                                //                                           .primary,
                                //                                       fontWeight:
                                //                                           FontWeight.bold),
                                //                                 ),
                 
                                //                                 const SizedBox(
                                //                                   height: 10,
                                //                                 ),
                                //                                 Text(
                                //                                   'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat ',
                                //                                   style: GoogleFonts.poppins(
                                //                                       textStyle:
                                //                                           Theme.of(context)
                                //                                               .textTheme
                                //                                               .bodyLarge,
                                //                                       fontSize:
                                //                                           AppText.p3(context),
                                //                                       color: Provider.of<
                                //                                                   AppColorProvider>(
                                //                                               context,
                                //                                               listen: false)
                                //                                           .black38),
                                //                                 ),
                 
                                //                                 const SizedBox(
                                //                                   height: 10,
                                //                                 ),
                                //                                 Text(
                                //                                   'Tailles disponibles',
                                //                                   style: GoogleFonts.poppins(
                                //                                       textStyle:
                                //                                           Theme.of(context)
                                //                                               .textTheme
                                //                                               .bodyLarge,
                                //                                       fontSize:
                                //                                           AppText.p2(context),
                                //                                       color: Provider.of<
                                //                                                   AppColorProvider>(
                                //                                               context,
                                //                                               listen: false)
                                //                                           .primary,
                                //                                       fontWeight:
                                //                                           FontWeight.bold),
                                //                                 ),
                                //                                 const SizedBox(
                                //                                   height: 10,
                                //                                 ),
                                //                                 Row(
                                //                                   children: [
                                //                                     Container(
                                //                                       height: 30,
                                //                                       width: 40,
                                //                                       decoration:
                                //                                           BoxDecoration(
                                //                                         borderRadius:
                                //                                             BorderRadius
                                //                                                 .circular(5),
                                //                                         border: Border.all(
                                //                                             color:
                                //                                                 appColorProvider
                                //                                                     .black54),
                                //                                       ),
                                //                                       child: Center(
                                //                                         child: Text(
                                //                                           'S',
                                //                                           style: GoogleFonts.poppins(
                                //                                               textStyle: Theme.of(
                                //                                                       context)
                                //                                                   .textTheme
                                //                                                   .bodyLarge,
                                //                                               fontSize:
                                //                                                   AppText.p3(
                                //                                                       context),
                                //                                               color: Provider.of<
                                //                                                           AppColorProvider>(
                                //                                                       context,
                                //                                                       listen:
                                //                                                           false)
                                //                                                   .black54,
                                //                                               fontWeight:
                                //                                                   FontWeight
                                //                                                       .bold),
                                //                                         ),
                                //                                       ),
                                //                                     ),
                                //                                     const SizedBox(width: 20),
                                //                                     Container(
                                //                                       height: 30,
                                //                                       width: 40,
                                //                                       decoration:
                                //                                           BoxDecoration(
                                //                                         borderRadius:
                                //                                             BorderRadius
                                //                                                 .circular(5),
                                //                                         border: Border.all(
                                //                                             color:
                                //                                                 appColorProvider
                                //                                                     .black54),
                                //                                       ),
                                //                                       child: Center(
                                //                                         child: Text(
                                //                                           'M',
                                //                                           style: GoogleFonts.poppins(
                                //                                               textStyle: Theme.of(
                                //                                                       context)
                                //                                                   .textTheme
                                //                                                   .bodyLarge,
                                //                                               fontSize:
                                //                                                   AppText.p3(
                                //                                                       context),
                                //                                               color: Provider.of<
                                //                                                           AppColorProvider>(
                                //                                                       context,
                                //                                                       listen:
                                //                                                           false)
                                //                                                   .black54,
                                //                                               fontWeight:
                                //                                                   FontWeight
                                //                                                       .bold),
                                //                                         ),
                                //                                       ),
                                //                                     ),
                                //                                     const SizedBox(width: 20),
                                //                                     Container(
                                //                                       height: 30,
                                //                                       width: 40,
                                //                                       decoration:
                                //                                           BoxDecoration(
                                //                                         borderRadius:
                                //                                             BorderRadius
                                //                                                 .circular(5),
                                //                                         border: Border.all(
                                //                                             color:
                                //                                                 appColorProvider
                                //                                                     .black54),
                                //                                       ),
                                //                                       child: Center(
                                //                                         child: Text(
                                //                                           'L',
                                //                                           style: GoogleFonts.poppins(
                                //                                               textStyle: Theme.of(
                                //                                                       context)
                                //                                                   .textTheme
                                //                                                   .bodyLarge,
                                //                                               fontSize:
                                //                                                   AppText.p3(
                                //                                                       context),
                                //                                               color: Provider.of<
                                //                                                           AppColorProvider>(
                                //                                                       context,
                                //                                                       listen:
                                //                                                           false)
                                //                                                   .black54,
                                //                                               fontWeight:
                                //                                                   FontWeight
                                //                                                       .bold),
                                //                                         ),
                                //                                       ),
                                //                                     )
                                //                                   ],
                                //                                 ),
                 
                                //                                 const SizedBox(
                                //                                   height: 20,
                                //                                 ),
                                //                                 Text(
                                //                                   '1500 XOF',
                                //                                   style: GoogleFonts.poppins(
                                //                                     fontSize:
                                //                                         AppText.p1(context),
                                //                                     color: appColorProvider
                                //                                         .black,
                                //                                     fontWeight:
                                //                                         FontWeight.bold,
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       );
                                //                     },
                                //                   );
                                //                 },
                                //                 style: OutlinedButton.styleFrom(
                                //                   padding: EdgeInsets.all(
                                //                       Device.getDiviseScreenHeight(
                                //                           context, 70)),
                                //                   shape: RoundedRectangleBorder(
                                //                     borderRadius: BorderRadius.circular(12),
                                //                   ),
                                //                   side: BorderSide(
                                //                       width: 0.7,
                                //                       color: Provider.of<AppColorProvider>(
                                //                               context,
                                //                               listen: false)
                                //                           .primary),
                                //                 ),
                                //                 child: Row(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment.center,
                                //                     children: [
                                //                       Text(
                                //                         "Détails",
                                //                         style: GoogleFonts.poppins(
                                //                             color:
                                //                                 Provider.of<AppColorProvider>(
                                //                                         context,
                                //                                         listen: false)
                                //                                     .black87,
                                //                             fontSize: AppText.p2(context)),
                                //                       ),
                                //                     ]),
                                //               ),
                                //             ),
                                //             const SizedBox(
                                //               width: 5,
                                //             ),
                                //             Expanded(
                                //               child: RaisedButtonDecor(
                                //                 onPressed: () {},
                                //                 elevation: 3,
                                //                 color: AppColor.primaryColor,
                                //                 shape: BorderRadius.circular(10),
                                //                 padding: const EdgeInsets.all(15),
                                //                 child: Text(
                                //                   "Choisir",
                                //                   style: GoogleFonts.poppins(
                                //                       color: Colors.white,
                                //                       fontSize: AppText.p2(context)),
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   )
                                // ]),
                              
                              
                              ]),
                          
                       
                    );
          
           
             
           
      ;
    });
  }
}
