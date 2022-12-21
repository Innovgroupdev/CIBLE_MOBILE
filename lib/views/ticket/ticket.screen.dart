import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<Ticket> tickets = [];
  double total = 0;
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

  @override
  Widget build(BuildContext context) {
    setState(() {
      tickets = Provider.of<TicketProvider>(context).ticketsList;
      total = Provider.of<TicketProvider>(context).total;
    });
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return WillPopScope(
        onWillPop: () {
          Provider.of<AppManagerProvider>(context, listen: false).userTemp = {};
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
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
              "Mes Tickets",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Device.getDiviseScreenWidth(context, 30),
            ),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tickets.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Device.getDiviseScreenHeight(context, 100),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                Device.getDiviseScreenWidth(context, 30),
                            vertical: Device.getDiviseScreenWidth(context, 30),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      );
    });
  }
}
