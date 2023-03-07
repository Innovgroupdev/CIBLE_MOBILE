import 'package:flutter/material.dart';

import '../helpers/screenSizeHelper.dart';
import '../helpers/textHelper.dart';
import '../providers/appColorsProvider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

showGadgetModelDetail(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(Device.getScreenHeight(context) / 70),
          child: Container(
            height: Device.getDiviseScreenHeight(context, 1.6),
            width: Device.getDiviseScreenWidth(context, 1.2),
            color: Provider.of<AppColorProvider>(context, listen: false).white,
            padding: EdgeInsets.symmetric(
                horizontal: Device.getScreenWidth(context) / 30,
                vertical: Device.getScreenHeight(context) / 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: Device.getScreenHeight(context) / 60,
                // ),
                Container(
                  width: double.infinity,
                  height: Device.getDiviseScreenHeight(context, 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColorProvider().white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColorProvider().black12,
                          spreadRadius: 0.2,
                          blurRadius: 2, // changes position of shadow
                        ),
                      ]),
                  child: Image.asset(
                    'assets/images/whiteTshirt.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 40,
                ),
                Text(
                  'Chemise',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .primary,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat ',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p3(context),
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .black38),
                ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Tailles disponibles',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: AppText.p2(context),
                      color:
                          Provider.of<AppColorProvider>(context, listen: false)
                              .primary,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColorProvider().black54),
                      ),
                      child: Center(
                        child: Text(
                          'S',
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p3(context),
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColorProvider().black54),
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p3(context),
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColorProvider().black54),
                      ),
                      child: Center(
                        child: Text(
                          'L',
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: AppText.p3(context),
                              color: Provider.of<AppColorProvider>(context,
                                      listen: false)
                                  .black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  '1500 XOF',
                  style: GoogleFonts.poppins(
                    fontSize: AppText.p1(context),
                    color: AppColorProvider().black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  ;
}
