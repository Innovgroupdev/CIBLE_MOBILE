import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../database/notificationDBcontroller.dart';
import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/formWidget.dart';
import '../../widgets/gadgetModelTabbar.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

import '../../widgets/raisedButtonDecor.dart';
import '../../widgets/sondageCard.dart';

class GadgetsScreen extends StatefulWidget {
  GadgetsScreen({Key? key}) : super(key: key);

  @override
  State<GadgetsScreen> createState() => _GadgetsScreenState();
}

class _GadgetsScreenState extends State<GadgetsScreen> {

  List<String> listGadget = ['Chemise','Casquette','Stylo','Pantalon','Vélo',];
  String gadgetSelected = '';
  //List<String> finalGadgetList = 
   @override
  initState() {
    gadgetSelected = listGadget[1];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Consumer<AppColorProvider>(
          builder: (context, appColorProvider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            foregroundColor:
                Provider.of<AppColorProvider>(context, listen: false).white,
            title: Text(
              "GADGETS",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p1(context),
                  fontWeight: FontWeight.w800,
                  color: Provider.of<AppColorProvider>(context, listen: false)
                      .white),
            ),
            //bottom: 
            // PreferredSize(
            //   preferredSize: const Size(double.infinity, 20),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     color: appColorProvider.white,
            //     child: Column(
            //       children: [
            //         const SizedBox(
            //       height: 10,
            //     ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(
            //                 child: LinearProgressIndicator(
            //               value: levelNumber / 6,
            //             )),
            //             const SizedBox(
            //               width: 20,
            //             ),
            //             Text(
            //               '$levelNumber/6',
            //               style: TextStyle(
            //                 color: appColorProvider.black54,
            //                 fontSize: AppText.p2(context),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

//Nouvelle version

            //     Container(height: 60,
            //     margin: const EdgeInsets.symmetric(vertical: 10),
            //       child: ListView.builder(
            // itemCount: 3,
            //         scrollDirection:Axis.horizontal,
            //         physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index){
            //     String tp;
            //     return GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           gadgetSelected = listGadget[index];
            //         });
            //         tp = listGadget[1];
            //         listGadget[1] = listGadget[index];
            //       },
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         margin: 
            //         index !=2?
            //         const EdgeInsets.fromLTRB(0,5,10,5):const EdgeInsets.fromLTRB(0,5,0,5),
            //         height: 40,
            //           width: (Device.getScreenWidth(context)-60) / 3,
            //           // decoration: BoxDecoration(
            //           //   color: appColorProvider.white,
            //           //   borderRadius: BorderRadius.circular(10),
            //           //   boxShadow: [
            //           //           BoxShadow(
            //           //             color: appColorProvider.black12,
            //           //             spreadRadius: 0.2,
            //           //             blurRadius: 2, // changes position of shadow
            //           //           ),
            //           //         ]
            //           // ),
            //           child: Center(
            //             child: Text(
            //               "${listGadget[index]}",
            //               style: GoogleFonts.poppins(
            //                 fontWeight: 
            //                 gadgetSelected == listGadget[index]?
            //                 FontWeight.bold:FontWeight.normal,
            //                   color: 
            //                   gadgetSelected == listGadget[index]?
            //                   appColorProvider.primary:appColorProvider.black54
            //                   , fontSize: 
            //                   gadgetSelected == listGadget[index]?
            //                   AppText.p2(context):AppText.p3(context)),
            //             ),
            //           ),),
            //     );
            //   }),
            //     ),



                // TabBar(
                //   isScrollable: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //  // indicator: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                //               labelColor: AppColor.primary,
                //               unselectedLabelColor: Colors.black54,
                //               indicatorSize: TabBarIndicatorSize.label,
                //               labelStyle: GoogleFonts.poppins(
                //                 fontSize: AppText.p1(context),
                //                 fontWeight: FontWeight.bold,
                //               ),
                //               unselectedLabelStyle:GoogleFonts.poppins(
                //                 fontSize: AppText.p3(context),
                //                 fontWeight: FontWeight.bold,
                //               ),
                //               tabs: const [
                //                 Tab(text: 'Chemise',height: 50,),
                //                 Tab(text: 'casquette',height: 50,),
                //                 Tab(text: 'stylo',height: 50,),
                //                 Tab(text: 'Chemise',height: 50,),
                //                 Tab(text: 'casquette',height: 50,),
                //                 Tab(text: 'stylo',height: 50,),
                //                 // Tab(text: 'T-shirt',height: 50,),
                //                 // Tab(text: 'Chemise',height: 50,),
                //                 // Tab(text: 'casquette',height: 50,),
                //                 // Tab(text: 'stylo',height: 50,),
                //                 // Tab(text: 'T-shirt',height: 50,),
                //                 // Tab(text: 'Chemise',height: 50,),
                //                 // Tab(text: 'casquette',height: 50,),
                //               ],
                //             ),
                            SizedBox(
                              height: Device.getScreenHeight(context) / 40,
                            ),
                            Expanded(
                              //height: Device.getDiviseScreenHeight(context, 20),
                              child:  TabBarView(
                                physics: const BouncingScrollPhysics(),
                                // controller: authController(),
                                children: [ 
                                  GadjetModelTabbar(),
                                  GadjetModelTabbar(),
                                  GadjetModelTabbar(),
                                  GadjetModelTabbar(),
                                  GadjetModelTabbar(),
                                  GadjetModelTabbar(),
                                ])),
                                SizedBox(
                              height: Device.getScreenHeight(context) / 20,
                            ),
                            RaisedButtonDecor(
                  onPressed: () {},
                  elevation: 3,
                  color: AppColor.primaryColor,
                  shape: BorderRadius.circular(10),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Terminer mon achat",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: AppText.p2(context)),
                  ),
                ),
                SizedBox(
                              height: Device.getScreenHeight(context) / 80,
                            ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
