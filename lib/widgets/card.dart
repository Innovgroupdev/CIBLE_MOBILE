import 'dart:ui';

import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/raisedButtonDecor.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/localPath.dart';
import '../helpers/textHelper.dart';

class MyCards extends StatelessWidget {
  String type;
  final Widget image;
  final String name;
  final String lieu;
  final String date;
  final int eventId;
  final _codeController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  FToast fToast = FToast();
  bool isLoading = false;
  MyCards(
      {super.key,
      required this.type,
      required this.image,
      required this.name,
      required this.lieu,
      required this.date,
      required this.eventId});

  @override
  Widget build(BuildContext context) {
    fToast.init(context);

    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: SizedBox(
            width: double.maxFinite,
            height: 150,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), child: image),
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
                                name,
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    fontSize: AppText.p1(context),
                                    fontWeight: FontWeight.bold,
                                    color: appColorProvider.black54),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                lieu.length > 50
                                    ? '${lieu.substring(0, 80)}...'
                                    : lieu,
                                maxLines: 2,
                                style: TextStyle(
                                  color: appColorProvider.black54,
                                  fontSize: AppText.p2(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        type != 'sondage'
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/sondage', arguments: {
                                        "eventId": eventId
                                      }
                                      );
                                      //Navigator.pushNamed(context, '/sondage');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: appColorProvider.primary,
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Participez',
                                    ),
                                  ),
                                ],
                              )
                      ],
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
