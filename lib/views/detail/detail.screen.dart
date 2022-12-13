import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Detail extends StatelessWidget {
  final String image;
  final String name;
  final String auteur;
  const Detail({
    super.key,
    required this.image,
    required this.name,
    required this.auteur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(
            image,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.transparent),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black.withAlpha(300),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            top: Device.getDiviseScreenHeight(context, 90),
            left: Device.getDiviseScreenWidth(context, 20),
            right: Device.getDiviseScreenWidth(context, 20),
            bottom: Device.getDiviseScreenWidth(context, 90),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                    onPressed: () {
                      debugPrint(image);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 2,
                        color: AppColorProvider().primaryColor1,
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 15.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: AppColorProvider().primaryColor1,
                    )),
              ),
              const Gap(3),
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorProvider().primaryColor1,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15.0,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Ajouter au panier',
                    style: GoogleFonts.poppins(
                      fontSize: AppText.p1(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Consumer<AppColorProvider>(
            builder: (context, appColorProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: Device.getDiviseScreenHeight(context, 90),
                        left: Device.getDiviseScreenWidth(context, 20),
                        right: Device.getDiviseScreenWidth(context, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(5),
                        Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 224, 224, 224),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Text(
                          name,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: AppText.titre4(context),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gap(10),
                        RichText(
                          text: TextSpan(
                            text: 'Organisateur : ',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: AppText.p2(context),
                            ),
                            children: [
                              TextSpan(
                                text: auteur,
                                style: TextStyle(
                                  color: appColorProvider.primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'Rue CAIMAN, Agbalépédogan | Lomé',
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p2(context),
                          ),
                        ),
                        const Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Description',
                              style: GoogleFonts.poppins(
                                fontSize: AppText.p1(context),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque nisl non lectus rutrum, sit amet aliquam nisi tincidunt. Sed venenatis tellus ipsum, consequat luctus arcu aliquam eget. Ut eget blandit quam. Nulla augue felis, consequat id nisl at, dignissim sagittis arcu. Integer eu eros ultrices, molestie massa sit amet.',
                              style: GoogleFonts.poppins(
                                fontSize: AppText.p3(context),
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        Container(
                          padding: EdgeInsets.only(
                            left: Device.getDiviseScreenWidth(context, 30),
                          ),
                          height: Device.getDiviseScreenHeight(context, 9),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DatePicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now(),
                                selectionColor: appColorProvider.primary,
                                selectedTextColor: Colors.white,
                                dateTextStyle: GoogleFonts.poppins(
                                    color: appColorProvider.black,
                                    fontSize: AppText.titre4(context),
                                    fontWeight: FontWeight.w800),
                                dayTextStyle: GoogleFonts.poppins(
                                    color: appColorProvider.black45,
                                    fontSize: AppText.p5(context),
                                    fontWeight: FontWeight.w500),
                                monthTextStyle: GoogleFonts.poppins(
                                    color: appColorProvider.black45,
                                    fontSize: AppText.p6(context),
                                    fontWeight: FontWeight.w500),
                                deactivatedColor: appColorProvider.black12,
                                locale: 'fr',
                                height:
                                    Device.getDiviseScreenHeight(context, 10),
                                width:
                                    Device.getDiviseScreenWidth(context, 6.5),
                                inactiveDates: [
                                  DateTime.now().add(Duration(days: 3)),
                                  DateTime.now().add(Duration(days: 4)),
                                  DateTime.now().add(Duration(days: 7))
                                ],
                                onDateChange: (date) {
                                  // New date selected
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: Device.getDiviseScreenWidth(context, 30),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    color: appColorProvider.primaryColor,
                                    size: 20,
                                  ),
                                  Gap(7),
                                  RichText(
                                    text: TextSpan(
                                      text: '12 h 30 - ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: AppText.p2(context),
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Stade de Kégué',
                                            style: TextStyle(
                                                color: appColorProvider
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    color: appColorProvider.primaryColor,
                                    size: 20,
                                  ),
                                  Gap(7),
                                  RichText(
                                    text: TextSpan(
                                      text: '12 h 30 - ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: AppText.p2(context),
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Stade de Kégué',
                                            style: TextStyle(
                                                color: appColorProvider
                                                    .primaryColor))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tickets',
                              style: GoogleFonts.poppins(
                                fontSize: AppText.p1(context),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              // margin: EdgeInsets.symmetric(horizontal: 15),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,

                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 227, 156, 240),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Ticket VIP',
                                        ),
                                        Container(
                                          color: Colors.black,
                                          height: 20,
                                          width: 1,
                                        ),
                                        Text(
                                          '1200 FCFA',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.black,
                                          height: 20,
                                          width: 1,
                                        ),
                                        Text(
                                          '123 Tickets',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppText.p1(context),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    'Pour les entrees VIP de premiere classeLorem ipsum dolor sit amet, consectetur adipiscing elit. ',
                                  ),
                                  const Gap(10),
                                  Text(
                                    '5% de reduction',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppText.p2(context),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 0.0,
                                              ),
                                            ),
                                            labelText: 'Quantité',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: AppText.p3(context),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Gap(3),
                                      Expanded(
                                          child: ElevatedButton(
                                        child: Text('Choisir'),
                                        onPressed: () {},
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Gap(30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Acteurs',
                              style: GoogleFonts.poppins(
                                fontSize: AppText.p1(context),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Gap(10),
                            Container(
                              child: Text('Artiste'),
                            ),
                          ],
                        ),
                        const Gap(30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
