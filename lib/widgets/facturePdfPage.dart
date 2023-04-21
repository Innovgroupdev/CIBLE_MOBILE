import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cible/models/modelGadgetUser.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/gadgetProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:cible/views/eventDetails/eventDetails.screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helpers/textHelper.dart';
import 'dart:io';

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

 List<TicketUser> tickets = [];
  List<ModelGadgetUser> gadgets = [];
  double total = 0;
  final oCcy = NumberFormat("#,##0.00", "fr_FR");

class FacturePdfPage extends StatefulWidget {
  FacturePdfPage({Key? key}) : super(key: key);

  @override
  State<FacturePdfPage> createState() => _FacturePdfPageState();
}

class _FacturePdfPageState extends State<FacturePdfPage> {




  @override
  Widget build(BuildContext context) {
    setState(() {
      tickets = Provider.of<TicketProvider>(context).ticketsList;
      gadgets = Provider.of<ModelGadgetProvider>(context).gadgetsList;
      total = Provider.of<TicketProvider>(context).total+Provider.of<ModelGadgetProvider>(context).total;
    });
    return WillPopScope(
      onWillPop: () {
          Provider.of<TicketProvider>(context, listen: false)
                      .setTicketsList([]);
          Provider.of<ModelGadgetProvider>(context, listen: false)
                      .setGadgetsList([]);
          Navigator.pop(context);
          return Future.value(false);
        },
      child: Scaffold(
        body: PdfPreview(
          maxPageWidth: 700,
          build: (format) {
            
            return examples[0].builder(format, _data);},
            canDebug : false,
            canChangePageFormat : false,
        ),
      ),
    );
  }
}

const PdfColor green = PdfColor.fromInt(0xFFFFDFD7);
const PdfColor green1 = PdfColor.fromInt(0xFFf96643);
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
        pw.Container(
                          height: 40,
                          width: double.infinity,
                          decoration: const pw.BoxDecoration(color: green),
                          child: pw.Row(
                            mainAxisAlignment:  pw.MainAxisAlignment.start ,
                            children:[
                              pw.SizedBox(width: 20),
                          pw.Text('FACTURE',
                          style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black))
              ])
                          ),
                          pw.Container(
                            color: white,
                            padding: const pw.EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20,
                        ),
                        child:pw.Column(
                          children: [
                            pw.Row(
                              mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                              children: [
                              pw.Text(
                                "Nom du client :",
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                              ),
                              pw.Text(
                                'AHETO Da Yawa Livlic',
                                style:  pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),)
                            ]),

                            pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Date de l'achat :",
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                              ),
                              pw.Text(
                                '06 Avril 2023',
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                              ),
                            ],
                          ),
                          pw.SizedBox(
                            width: double.infinity,
                            height: 30,
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  'Ticket',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  'Prix Unitaire',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'Quantité',
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(
                            width: double.infinity,
                            height: 10,
                          ),
                          pw.Container(
                            width: double.infinity,
                            height: 1,
                            color: black,
                          ),

                          pw.SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
pw.ListView.builder(
                                  itemCount: tickets.length,
                                  itemBuilder: (context, i) {
                                    return pw.Container(
                                      decoration: pw.BoxDecoration(
                                        color: white,
                                        borderRadius: pw.BorderRadius.circular(10),
                                      ),
                                      margin: const pw.EdgeInsets.symmetric(
                                        horizontal: 0,
                                      ),
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Text(
                                                  tickets[i].ticket.libelle,
                                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                                ),
                                                pw.RichText(
                                                  overflow: pw.TextOverflow.span ,
                                                  text: pw.TextSpan(
                                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black),
                                                    text: tickets[i].event.titre,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Text(
                                              '${oCcy.format(tickets[i].ticket.prix)} FCFA',
                                              style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                            ),
                                          ),
                                          pw.Expanded(
                                            flex: 1,
                                            child: pw.Align(
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text(
                                                ' * ${tickets[i].quantite}',
                                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
      

                          pw.SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),gadgets.isEmpty?
                          pw.SizedBox():
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  'Gadget',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  'Prix Unitaire',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'Quantité',
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          gadgets.isEmpty?
                          pw.SizedBox():
                          pw.SizedBox(
                            width: double.infinity,
                            height: 10,
                          ),
                          gadgets.isEmpty?
                          pw.SizedBox():
                          pw.Container(
                            width: double.infinity,
                            height: 1,
                            color: black,
                          ),
                          pw.SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
                          
                          pw.ListView.builder(
                                  itemCount: gadgets.length,
                                  itemBuilder: (context, i) {
                                    return pw.Container(
                                      decoration: pw.BoxDecoration(
                                        color: white,
                                        borderRadius: pw.BorderRadius.circular(10),
                                      ),
                                      margin: const pw.EdgeInsets.symmetric(
                                        horizontal: 10
                                      ),
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Text(
                                                  gadgets[i].modelGadget.libelle,
                                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                                ),
                                                pw.RichText(
                                                  overflow: pw.TextOverflow.span,
                                                  text: pw.TextSpan(
                                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black),
                                                    text: gadgets[i].tailleModel.libelle,
                                                  ),
                                                ),
                                                pw.RichText(
                                                  overflow: pw.TextOverflow.span,
                                                  text: pw.TextSpan(
                                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black),
                                                    text: gadgets[i].couleurModel.libelle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          pw.Expanded(
                                            flex: 2,
                                            child: pw.Text(
                                              '${oCcy.format(gadgets[i].modelGadget.prixCible)} ${gadgets[i].modelGadget.deviseCible}',
                                              style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                            ),
                                          ),
                                          pw.Expanded(
                                            flex: 1,
                                            child: pw.Align(
                                              alignment: pw.Alignment.centerRight,
                                              child: pw.Text(
                                                ' * ${gadgets[i].quantite}',
                                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        color: black)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              
                          pw.Container(
                          width: double.infinity,
                          padding: const pw.EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20,
                        ),
                          decoration: const pw.BoxDecoration(color: green),
                          child: 
                          pw.Column(
                            children: [
                              pw.Row(
                            children:[
                          pw.Expanded(
                                child: pw.Text(
                                  'Sous-total :',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.RichText(
                                  textAlign: pw.TextAlign.right ,
                                  text: pw.TextSpan(
                                    text: oCcy.format(total),
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                    children: [
                                      pw.TextSpan(
                                        text: ' FCFA',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
              ]),

              pw.Row(
                            children:[
                          pw.Expanded(
                                child: pw.Text(
                                  'Frais :',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.RichText(
                                  textAlign: pw.TextAlign.right ,
                                  text: pw.TextSpan(
                                    text: '4',
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                    children: [
                                      pw.TextSpan(
                                        text: ' %',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
              ]),
              pw.Row(
                            children:[
                          pw.Expanded(
                                child: pw.Text(
                                  'TOTAL :',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.RichText(
                                  textAlign: pw.TextAlign.right ,
                                  text: pw.TextSpan(
                                    text:  oCcy.format(total + (total * 4 / 100)),
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: green1),
                                    children: [
                                      pw.TextSpan(
                                        text: ' FCFA',
                                        style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: green1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
              ]),
              pw.Row(
                            children:[
                          pw.Expanded(
                                child: pw.Text(
                                  'Remise :',
                                  style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.RichText(
                                  textAlign: pw.TextAlign.right ,
                                  text: pw.TextSpan(
                                    text: '0',
                                    style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                    children: [
                                      pw.TextSpan(
                                        text: ' FCFA',
                                        style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
              ]),
                          ])
                          ),
                          pw.Container(
                      color: green,
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'Merci à vous !',
                          style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        color: black),
                        ),
                      ),
                    ),
                          ]
                        )
                          ),
          // pw.Padding(
          //   padding: const pw.EdgeInsets.symmetric(horizontal: 0),
          //   child: pw.Column(
          //     crossAxisAlignment: pw.CrossAxisAlignment.start,
          //     children: <pw.Widget>[
                
                  
          //     ],
          //   ),
          // ),
       
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
  _Block({required this.image});
  // {required this.title,
  // required this.lieu,
  // required this.date,
  // required this.heure}

  // final String title;
  // final String lieu;
  // final String date;
  // final String heure;
  pw.MemoryImage image;

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
                              child: pw.Text('lieux',
                                  style: pw.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold,
                                          color: white)),
                            ))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    child: pw.Text('lieux',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                            color: white)),
                  ),
                  //pw.Container(height: 20,width: 50,color: green)
                ])),
          ]),
          pw.Container(
            child: pw.Row(children: <pw.Widget>[
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
                          pw.Text('date1',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(color: white, fontSize: 15)),
                          pw.Text('date2}',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: white,
                                      fontSize: 15)),
                          pw.Text('date3}',
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
                          child: pw.Text('heure0',
                              textScaleFactor: 1,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(color: white, fontSize: 15))),
                    ))
              ])
            ]),
          ),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({required this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: lightGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Text(title,
          textScaleFactor: 1.5,
          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: white)),
    );
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    required this.size,
    required this.value,
    required this.title,
  });

  final double size;

  final double value;

  final pw.Widget title;

  static const fontSize = 1.2;

  PdfColor get color => green;

  static const backgroundColor = PdfColors.grey300;

  static const strokeWidth = 5.0;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text('${(value * 100).round().toInt()}%',
                  textScaleFactor: fontSize,
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(fontWeight: pw.FontWeight.bold, color: white)),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: green,
          )),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (3 * dashWidth)).floor();
        return Flex(
          children: List.generate(100, (_) {
            return SizedBox(
              width: 2,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}
