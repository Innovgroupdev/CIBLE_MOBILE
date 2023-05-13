import 'dart:convert';

import 'package:cible/widgets/card.dart';
import 'package:flutter/material.dart';

import '../constants/api.dart';
import '../helpers/colorsHelper.dart';
import '../helpers/screenSizeHelper.dart';
import '../helpers/sharePreferenceHelper.dart';
import '../helpers/textHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';

import '../models/Event.dart';
import '../providers/appColorsProvider.dart';


class EventsActifs extends StatefulWidget {
   EventsActifs({required this.type,required this.eventList, Key? key}) : super(key: key);
  String type;
  List<Event1> eventList;

  @override
  State<EventsActifs> createState() => _EventsActifsState();
}

class _EventsActifsState extends State<EventsActifs>
    with SingleTickerProviderStateMixin {
var token;
bool _isloading2 = false;
bool _isloading1 = false;

 @override
  void initState() {
    super.initState();
  }

isLoading1(bool isLoading){
  setState(() {
    _isloading1 = isLoading;
  });
}

isLoading2(bool isLoading){
  setState(() {
    _isloading2 = isLoading;
  });
}


      
        @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
return 
// sondages == null
//         ? Center(child: CircularProgressIndicator())
//         : sondages!.isEmpty?
//         Center(child:  Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:  [
//             SizedBox(
//               height: 350,
//               width: 350,
//                       child: Image.asset('assets/images/empty.png'),
//                     ),
//              const Text(
//                             'Pas de Sondages',
//                             style: TextStyle(
//                               fontSize: 17,
//                               color: AppColor.primary,
//                             ),
//                           ),
//           ],
//         ),)
       // :
    ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.eventList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                      //             Text(
                      //             '05-02-2023',
                      //             style: GoogleFonts.poppins(
                      // textStyle: Theme.of(context).textTheme.bodyText1,
                      // fontSize: AppText.p2(context),
                      // fontWeight: FontWeight.bold,
                      // color: appColorProvider.black54),
                      //           ),
                                  MyCards(
                                    isloadingChange1: (isLoad) {
                                      isLoading1(isLoad);
                                    },
                                    isloadingChange2: (isLoad) {
                                      isLoading2(isLoad);
                                    },
                                    context: context,
                                    type:widget.type,
                                    event: widget.eventList[index],
                                    image: Image.network(
                                      widget.eventList[index].image,
                                            height: 130,
                                            fit: BoxFit.fitHeight,
                                          ),
                                    name: widget.eventList[index].titre,
                                    lieu:
                                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. V'
                                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. V'
                                        ,
                                    date:
                                        'date',
                                        eventId: widget.eventList[index].id,
                                    codeEvent: widget.eventList[index].code,
                                  ),
                                ],
                              );
                            });
     

      

        });
    
    }}

