import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                TabBar(
                  isScrollable: true,
                 // indicator: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              labelColor: AppColor.primary,
                              unselectedLabelColor: Colors.black54,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelStyle: GoogleFonts.poppins(
                                fontSize: AppText.p1(context),
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle:GoogleFonts.poppins(
                                fontSize: AppText.p3(context),
                                fontWeight: FontWeight.bold,
                              ),
                              tabs: const [
                                Tab(text: 'Chemise',height: 50,),
                                Tab(text: 'casquette',height: 50,),
                                Tab(text: 'stylo',height: 50,),
                                // Tab(text: 'T-shirt',height: 50,),
                                // Tab(text: 'Chemise',height: 50,),
                                // Tab(text: 'casquette',height: 50,),
                                // Tab(text: 'stylo',height: 50,),
                                // Tab(text: 'T-shirt',height: 50,),
                                // Tab(text: 'Chemise',height: 50,),
                                // Tab(text: 'casquette',height: 50,),
                              ],
                            ),
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
