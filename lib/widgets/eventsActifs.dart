import 'package:cible/widgets/card.dart';
import 'package:flutter/material.dart';

import '../helpers/textHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/appColorsProvider.dart';


class EventsActifs extends StatefulWidget {
   EventsActifs({required this.type, Key? key}) : super(key: key);
  String type;

  @override
  State<EventsActifs> createState() => _EventsActifsState();
}

class _EventsActifsState extends State<EventsActifs>
    with SingleTickerProviderStateMixin {
        @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
return 
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

