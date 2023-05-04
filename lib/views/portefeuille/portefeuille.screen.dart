import 'dart:math';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

class PortefeuilleScreen extends StatefulWidget {
  const PortefeuilleScreen({Key? key}) : super(key: key);

  @override
  _PortefeuilleScreenState createState() => _PortefeuilleScreenState();
}

class _PortefeuilleScreenState extends State<PortefeuilleScreen> {
  final montant = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              "Portefeuille",
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
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: inputDecorationGrey(
                      "Montant",
                      Device.getScreenWidth(context),
                    ),
                    controller: montant,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    // montant.text
                    onPressed: () async {
                      String amount = montant.text;
                      if (amount.isEmpty) {
                        return;
                      }
                      double _amount;
                      try {
                        _amount = double.parse(amount);

                        if (_amount < 100) {
                          return;
                        }

                        if (_amount > 1500000) {
                          return;
                        }
                      } catch (exception) {
                        return;
                      }

                      montant.clear();

                      final String transactionId = Random()
                          .nextInt(100000000)
                          .toString(); // Mettre en place un endpoint à contacter cêté serveur pour générer des ID unique dans votre BD
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorProvider().primaryColor1,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Recharger',
                      style: GoogleFonts.poppins(
                        fontSize: AppText.p3(context),
                        fontWeight: FontWeight.w400,
                      ),
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
