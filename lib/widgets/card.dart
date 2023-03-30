import 'dart:async';
import 'dart:ui';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/raisedButtonDecor.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/localPath.dart';
import '../helpers/screenSizeHelper.dart';
import '../helpers/textHelper.dart';
import '../models/Event.dart';
import '../providers/appColorsProvider.dart';
import 'package:badges/badges.dart';
import '../views/eventDetails/eventDetails.screen.dart';

import 'package:line_icons/line_icons.dart';

import '../views/eventDetails/eventDetails.controller.dart';

class MyCards extends StatelessWidget {
  String type;
  final Widget image;
  final String name;
  final Event1 event;
  final String lieu;
  final String date;
  final String codeEvent;
  final int eventId;
  final Function(bool) isloadingChange2;
  final Function(bool) isloadingChange1;
  BuildContext context;
  final _codeController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  bool isLoading = false;

  MyCards(
      {super.key,
      required this.isloadingChange2,
      required this.isloadingChange1,
      required this.type,
      required this.event,
      required this.codeEvent,
      required this.image,
      required this.name,
      required this.lieu,
      required this.date,
      required this.eventId,
      required this.context});

  @override
  Widget build(BuildContext context) {
    int nbrePlaces = 0;
    for(var i in event.tickets){
      nbrePlaces += i.nombrePlaces;
    }
    fToast.init(context);

    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: SizedBox(
            width: double.maxFinite,
            height: 125,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: 
                        ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: image),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name.length > 50
                                    ? '${name.substring(0, 80)}...'
                                    : name,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    fontSize: AppText.p3(context),
                                    fontWeight: FontWeight.bold,
                                    color: appColorProvider.black45),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 3,
                        //       child: Text(
                        //         lieu.length > 50
                        //             ? '${lieu.substring(0, 80)}...'
                        //             : lieu,
                        //         maxLines: 2,
                        //         style: TextStyle(
                        //           color: appColorProvider.black54,
                        //           fontSize: AppText.p3(context),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: Device.getDiviseScreenHeight(context, 23),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                //flex: 3,
                                child: Text(
                                event.description,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    fontSize: AppText.p5(context),
                                    color: appColorProvider.black45),
                              ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  //),
                                  type == 'Avenir'
                                          ?
                                  ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  backgroundColor:
                                                      appColorProvider.white,
                                                  minimumSize: Size(45, 25),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      side: const BorderSide(
                                                          color: Colors.red)),
                                                  elevation: 0,
                                                ),
                                                child: Text(
                                                  'Annuler',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize:
                                                        AppText.p6(context),
                                                  ),
                                                ),
                                              )
                                  :
                                  SizedBox(),
                                  type != 'Passés' && type != 'Avenir'
                                          ?
                                  SizedBox():
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('ddddddddd'+event.tickets.toString());
                                        Navigator.pushNamed(
                                          context, '/mafacture',
                                          arguments: {"event": event.tickets});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor:
                                            appColorProvider.categoriesColor(5),
                                        minimumSize: Size(55, 25),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Ma facture',
                                        style: TextStyle(
                                          color: appColorProvider.white,
                                          fontSize: AppText.p6(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  type != 'Passés' && type != 'Avenir'
                                          ?
                                  SizedBox():
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1),
                                    child: ElevatedButton(
                                      onPressed: () async {
                         Scaffold.of(context).setState(() {
                          isloadingChange1(true);
                          });
                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor: appColorProvider.blue10,
                                        minimumSize: Size(55, 25),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Tickets',
                                        style: TextStyle(
                                          color: appColorProvider.white,
                                          fontSize: AppText.p6(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      
    print('fuckinggggggggg'+event.toString());
                                      Navigator.pushNamed(
                                          context, '/eventDetails',
                                          arguments: {"event": event});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                      backgroundColor: appColorProvider.blue5,
                                      minimumSize: Size(55, 25),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Détails',
                                      style: TextStyle(
                                        color: appColorProvider.white,
                                        fontSize: AppText.p6(context),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
