import 'dart:convert';

import 'package:cible/widgets/card.dart';
import 'package:flutter/material.dart';

import '../constants/api.dart';
import '../helpers/colorsHelper.dart';
import '../helpers/sharePreferenceHelper.dart';
import '../helpers/textHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/appColorsProvider.dart';


class EventsActifs extends StatefulWidget {
   EventsActifs({required this.type, Key? key}) : super(key: key);
  String type;

  @override
  State<EventsActifs> createState() => _EventsActifsState();
}

class _EventsActifsState extends State<EventsActifs>
    with SingleTickerProviderStateMixin {
var token;
  dynamic sondages;

 @override
  void initState() {
    getSondageEnCoursFromAPI();
    super.initState();
  }



  getSondageEnCoursFromAPI() async {
    token = await SharedPreferencesHelper.getValue('token');
    var response = await http.get(
      Uri.parse('$baseApiUrl/surveys/users/active'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // eventsList = jsonDecode(response.body)['events'];
      setState(() {
        sondages = jsonDecode(response.body)['data'] as List;
      });
      return sondages;
    }
  }
      
        @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
return sondages == null
        ? Center(child: CircularProgressIndicator())
        : sondages!.isEmpty?
        Center(child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: 350,
              width: 350,
                      child: Image.asset('assets/images/empty.png'),
                    ),
             const Text(
                            'Pas de Favoris',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColor.primary,
                            ),
                          ),
          ],
        ),)
        :
    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              '05-02-2023',
                              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  fontSize: AppText.p2(context),
                  fontWeight: FontWeight.bold,
                  color: appColorProvider.black54),
                            ),
                              MyCards(
                                type:widget.type,
                                image: Image.asset(
                                        'assets/images/event1.jpg',
                                        height: 130,
                                        fit: BoxFit.fitHeight,
                                      ),
                                name: 'DANCE ALL',
                                lieu:
                                    'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. V'
                                    'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. V'
                                    ,
                                date:
                                    'date',
                                    eventId: 80,
                              ),
                            ],
                          );
                        });

        });
    
    }}

