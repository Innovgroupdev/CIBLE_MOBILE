// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TicketPdfPage extends StatefulWidget {
  TicketPdfPage({Key? key}) : super(key: key);

  @override
  State<TicketPdfPage> createState() => _TicketPdfPageState();
}

class _TicketPdfPageState extends State<TicketPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printing"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _createPdf,
              child: Text(
                'Create & Print PDF',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _displayPdf,
              child: Text(
                'Display PDF',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: generatePdf,
              child: Text(
                'Generate Advanced PDF',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// create PDF & print it
  void _createPdf() async {
    final doc = pw.Document();

    /// for using an image from assets
    // final image = await imageFromAssetBundle('assets/image.png');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello eclectify Enthusiast'),
          ); // Center
        },
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    // await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }

  /// display a pdf document.
  void _displayPdf() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello eclectify Enthusiast',
              style: pw.TextStyle(fontSize: 30),
            ),
          );
        },
      ),
    );
  }

  /// more advanced PDF styling
  Future<List<int>> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void generatePdf() async {
    const title = 'eclectify Demo';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
  }
}

// class PreviewScreen extends StatelessWidget {
//   final pw.Document doc;

//   const PreviewScreen({
//     Key? key,
//     required this.doc,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_outlined),
//         ),
//         centerTitle: true,
//         title: Text("Preview"),
//       ),
//       body: PdfPreview(
//         build: (format) => doc.save(),
//         allowSharing: true,
//         allowPrinting: true,
//         initialPageFormat: PdfPageFormat.a4,
//         pdfFileName: "mydoc.pdf",
//       ),
//     );
//   }
// }
