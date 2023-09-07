import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cible/models/Event.dart';
import 'package:cible/models/tiketPaye.dart';
import 'package:cible/views/eventDetails/eventDetails.screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../helpers/screenSizeHelper.dart';
import '../helpers/textHelper.dart';
import 'dart:io';

import '../models/categorie.dart';
import '../models/date.dart';
import '../providers/appColorsProvider.dart';
import '../providers/appManagerProvider.dart';
import '../providers/defaultUser.dart';
import '../views/eventDetails/eventDetails.controller.dart';
import 'package:provider/provider.dart';

class CustomData {
  const CustomData({this.name = '[your name]'});

  final String name;
}

var _data = const CustomData();
typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  const Example(this.builder);
  final LayoutCallbackWithData builder;
}

const examples = <Example>[
  Example(generateResume),
];
late TicketPaye mapReceive;
dynamic date;
dynamic heure;
String eventCategorie = '';
List dateCollections = [];

class TicketPdfPage extends StatefulWidget {
  TicketPaye ticketPaye;
  TicketPdfPage({Key? key, required this.ticketPaye}) : super(key: key);

  @override
  State<TicketPdfPage> createState() => _TicketPdfPageState();
}

class _TicketPdfPageState extends State<TicketPdfPage> {
  List<Categorie> listCategories = [];

  @override
  void initState() {
    // TODO: implement initState
    print("hello");
    print("${widget.ticketPaye.avantages}");
    print("${widget.ticketPaye.titre} hjjhjhjh");
    print("${widget.ticketPaye.lieu} hiiiii");
    print("hello");
    initEventData();
  }

  initEventData() {
    listCategories =
        Provider.of<DefaultUserProvider>(context, listen: false).categorieList;
    for (var categorie in listCategories) {
      if (widget.ticketPaye.event.categorieId == categorie.id) {
        eventCategorie = categorie.code;
      }
    }
    // if (getCategorieIsMultiple(eventCategorie) &&
    //     widget.map['event'].lieux[0].creneauDates[0].dateDebut != '') {
    //   initDate2();
    // } else {
    //   //initDate();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) {
          mapReceive = widget.ticketPaye;
          date = mapReceive.event.dateOneDay.toString().split(' ');
          heure = mapReceive.event.heureDebut;
          return examples[0].builder(format, _data);
        },
        canDebug: false,
        canChangePageFormat: false,
      ),
    );
  }
}

const PdfColor green = PdfColor.fromInt(0xFFf96643);
const PdfColor black = PdfColor.fromInt(0xFF000000);
//PdfColor black1 = PdfColor.fromRYB(255, 255, 255,0.1 );
const PdfColor white = PdfColor.fromInt(0xFFffffff);
const PdfColor grey = PdfColor.fromInt(0xFFD5D7D6);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const sep = 120.0;

Future<Uint8List> generateResume(PdfPageFormat format, CustomData data) async {
  final doc = pw.Document(title: 'Ticket payé');

  final pageTheme = await _myPageTheme(format);
  final loadingIcon = pw.MemoryImage(
    (await rootBundle.load('assets/images/loadingIcon.png'))
        .buffer
        .asUint8List(),
  );
  final warningIcon = pw.MemoryImage(
    (await rootBundle.load('assets/images/warnnigIcon.png'))
        .buffer
        .asUint8List(),
  );
  final locationIcon = pw.MemoryImage(
    (await rootBundle.load('assets/images/locationIcon.png'))
        .buffer
        .asUint8List(),
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) => [
        pw.Stack(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Row(children: [
                  pw.Expanded(
                      child: pw.Container(
                          height: 3,
                          decoration: const pw.BoxDecoration(color: green))),
                  pw.SizedBox(width: 10),
                  pw.Text('TICKET N ${mapReceive.id}',
                      textScaleFactor: 1,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                          fontWeight: pw.FontWeight.bold,
                          color: black,
                          fontSize: 13)),
                ]),
                pw.Stack(children: [
                  pw.Container(
                    height: 480,
                    width: double.infinity,
                    color: black,
                  ),
                  pw.Positioned(
                      left: 300,
                      top: 10,
                      child: pw.ClipOval(
                          child: pw.Container(
                              height: 100,
                              width: 100,
                              decoration: const pw.BoxDecoration(
                                gradient: pw.RadialGradient(
                                    colors: [white, black],
                                    focal: pw.Alignment.center,
                                    tileMode: pw.TileMode.clamp),
                                color: white,
                              )))),
                  pw.Positioned(
                      left: 20,
                      top: 400,
                      child: pw.ClipOval(
                          child: pw.Container(
                              height: 100,
                              width: 100,
                              decoration: const pw.BoxDecoration(
                                gradient: pw.RadialGradient(
                                    colors: [white, black],
                                    focal: pw.Alignment.center,
                                    tileMode: pw.TileMode.clamp),
                                color: white,
                              )))),
                  pw.Container(
                      height: 480,
                      padding: const pw.EdgeInsets.all(30),
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: white, width: 2)),
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            pw.Text(mapReceive.titre,
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 22,
                                        fontWeight: pw.FontWeight.bold,
                                        color: white)),
                            pw.SizedBox(height: 20),
                            _Block(image: locationIcon, event: mapReceive.event)
                          ],
                        ),
                      )),
                ]),
                pw.SizedBox(height: 10),
                pw.Text(
                  "TICKET ${mapReceive.libelle}",
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                      color: green,
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          pw.Positioned(
              bottom: 70,
              right: 0,
              child: pw.Transform.rotate(
                  angle: math.pi / 4,
                  origin: const PdfPoint(50, 50),
                  child: pw.Container(
                    height: 40,
                    width: 250,
                    color: green,
                    child: pw.Center(
                        child: pw.Text('${mapReceive.prix.toString()} FCFA',
                            textScaleFactor: 1,
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(
                                    color: white,
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold))),
                  )))
        ]),
        pw.SizedBox(height: 10),
        pw.LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = constraints!.constrainWidth();
            const dashWidth = 5.0;
            final dashCount = (boxWidth / (2 * dashWidth)).floor();
            return pw.Flex(
              children: List.generate(dashCount, (_) {
                return pw.SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: pw.DecoratedBox(
                    decoration: const pw.BoxDecoration(color: grey),
                  ),
                );
              }),
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              direction: pw.Axis.horizontal,
            );
          },
        ),
        pw.SizedBox(height: 5),
        pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 30),
            child: pw.Column(children: [
              pw.Container(
                  height: 150,
                  child: pw.Row(children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                          color: white,
                          border: pw.Border.all(color: grey, width: 2)),
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.BarcodeWidget(
                        data:
                            '${mapReceive.codeQr} ${mapReceive.ticketAccessToken} ',
                        width: 150,
                        height: 150,
                        barcode: pw.Barcode.qrCode(),
                        drawText: false,
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                        child: pw.Column(children: [
                      pw.Expanded(
                        child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                                color: grey,
                                borderRadius: pw.BorderRadius.circular(2)),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(children: [
                                    pw.Container(
                                      width: 20,
                                      height: 20,
                                      child: pw.Image(loadingIcon),
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Text('Avantages du Tickets',
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                color: black, fontSize: 15)),
                                  ]),
                                  pw.Text(mapReceive.avantages,
                                      style: pw.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                              color: black, fontSize: 10)),
                                ])),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                                color: white,
                                borderRadius: pw.BorderRadius.circular(2)),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(children: [
                                    pw.Container(
                                      width: 20,
                                      height: 20,
                                      child: pw.Image(warningIcon),
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Text('Avis important',
                                        style: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                                color: black, fontSize: 15)),
                                  ]),
                                  pw.Text(mapReceive.event.conditions,
                                      maxLines: 2,
                                      style: pw.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                              color: black, fontSize: 10)),
                                ])),
                      ),
                    ]))
                  ])),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text('INFO LINE: ${mapReceive.event.auteur.tel1}',
                    textScaleFactor: 1,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: black, fontSize: 13)),
              ])
            ]))
      ],
    ),
  );
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
  final fontBold = await rootBundle.load("assets/fonts/Poppins-Bold.ttf");
  final ttf = pw.Font.ttf(font);
  final ttfBold = pw.Font.ttf(fontBold);

  format = PdfPageFormat.a4;
  return pw.PageTheme(
    pageFormat: format,
    theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold /*icons: await PdfGoogleFonts.materialIcons(),*/),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
          ignoreMargins: false,
          child: pw.Column(children: [
            pw.Expanded(
              child: pw.Stack(
                children: [
                  pw.Container(
                    decoration: const pw.BoxDecoration(color: white),
                  ),
                ],
              ),
            ),
          ]));
    },
  );
}

class _Block extends pw.StatelessWidget {
  _Block({required this.image, required this.event});

  pw.MemoryImage image;
  Event1 event;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Row(children: <pw.Widget>[
          pw.Container(width: 20, height: 20, child: pw.Image(image)),
          pw.SizedBox(width: 10),
          pw.Expanded(
              child: pw.Stack(
                  //alignment : pw.Alignment.center,
                  children: [
                pw.Opacity(
                  opacity: 0.4,
                  child: pw.Container(
                      decoration: const pw.BoxDecoration(
                        color: white,
                        borderRadius:
                            pw.BorderRadius.all(pw.Radius.circular(2)),
                      ),
                      child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: pw.Text('${mapReceive.lieu}',
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: white)),
                          ))),
                ),
                // pw.Padding(
                //   padding:
                //       const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                //   child: pw.Text('${mapReceive.event.categorieId}',
                //       style: pw.Theme.of(context).defaultTextStyle.copyWith(
                //           fontSize: 15,
                //           fontWeight: pw.FontWeight.bold,
                //           color: white)),
                // ),
                //pw.Container(height: 20,width: 50,color: green)
              ])),
        ]),
        pw.Container(
          child:
              // getCategorieIsMultiple(eventCategorie) &&
              //         event.dateOneDay.isNotEmpty
              //     ? getDates2(context)
              //     :
              pw.ListView(direction: pw.Axis.horizontal, children: <pw.Widget>[
            pw.Stack(alignment: pw.Alignment.center, children: [
              pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 10),
                  height: 90,
                  width: 90,
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: white, width: 2)),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        //${date[0]}
                        pw.Text('${date[0]}',
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(color: white, fontSize: 15)),
                        //${date[1]}
                        pw.Text('${date[1]}',
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                    color: white,
                                    fontSize: 15)),

                        //${date[2]}
                        pw.Text('${date[2]}',
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(color: white, fontSize: 15)),
                      ])),
              pw.Positioned(
                  bottom: 0,
                  right: 15,
                  child: pw.Container(
                    height: 20,
                    width: 60,
                    color: green,
                    child: pw.Center(
                        //${heure[0]}H${heure[3]}
                        child: pw.Text('${heure}',
                            textScaleFactor: 1,
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(color: white, fontSize: 15))),
                  ))
            ])
          ]),
        ),
      ],
    );
  }
}
