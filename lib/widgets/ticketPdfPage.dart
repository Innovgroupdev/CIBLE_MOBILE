import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cible/views/eventDetails/eventDetails.screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
dynamic mapReceive;
dynamic date;
dynamic heure;

class TicketPdfPage extends StatefulWidget {
  Map map;
  TicketPdfPage({Key? key, required this.map}) : super(key: key);

  @override
  State<TicketPdfPage> createState() => _TicketPdfPageState();
}

class _TicketPdfPageState extends State<TicketPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) {
          mapReceive = widget.map;
          date = mapReceive['date'].toString().split(' ');
          heure = mapReceive['heure'].toString().split(' ');
          return examples[0].builder(format, _data);},

          allowPrinting : false,
          allowSharing : false,
          canChangeOrientation : false,
          
          canChangePageFormat : false,
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
                  pw.Text('TICKET N ${mapReceive['idTicket']}',
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
                            child: pw.ClipOval(child: pw.Container(
                                height: 100,
                                width: 100,
                                decoration: const pw.BoxDecoration(
                                  gradient: pw.RadialGradient(colors: [
                                    white,
                                    black
                                  ],
                                  focal: pw.Alignment.center,tileMode: pw.TileMode.clamp ),
                                  color: white,
                                        )))
                            ),
                            pw.Positioned(
                            left: 20,
                            top: 400,
                            child: pw.ClipOval(child: pw.Container(
                                height: 100,
                                width: 100,
                                decoration: const pw.BoxDecoration(
                                  gradient: pw.RadialGradient(colors: [
                                    white,
                                    black
                                  ],
                                  focal: pw.Alignment.center,tileMode: pw.TileMode.clamp ),
                                  color: white,
                                        )))
                            ),
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
                            pw.Text('${mapReceive['titre']}',
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                        fontSize: 22,
                                        fontWeight: pw.FontWeight.bold,
                                        color: white)),
                            pw.SizedBox(height: 20),
                            _Block(image: locationIcon)
                          ],
                        ),
                      )),
                ]),
                pw.SizedBox(height: 10),
                pw.Text(
                  "TICKET ${mapReceive['libelle']}",
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
                        child: pw.Text('${mapReceive['prix'].toString()} FCFA',
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
                        data: '${mapReceive['code_qr']} ${mapReceive['ticket_access_token']} ',
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
                                  pw.Text(
                                      'Lorem Ipsum is simply dummy text of the printing ',
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
                                  pw.Text(
                                      '${mapReceive['conditions']}',
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
                pw.Text('INFO LINE: +228 97781443 / 93955791',
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
                              child: pw.Text('${mapReceive['lieux']}',
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
                    child: pw.Text('${mapReceive['lieux']}',
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
                          pw.Text('${date[0]}',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(color: white, fontSize: 15)),
                          pw.Text('${date[1]}',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                      fontWeight: pw.FontWeight.bold,
                                      color: white,
                                      fontSize: 15)),
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
                          child: pw.Text('${heure[0]}H${heure[3]}',
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
