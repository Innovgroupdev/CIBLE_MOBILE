import 'package:flutter/material.dart';

import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CinetPayWebView extends StatefulWidget {
  const CinetPayWebView({required this.url, Key? key}) : super(key: key);
  final String url;

  @override
  State<CinetPayWebView> createState() => _CinetPayWebViewState();
}

class _CinetPayWebViewState extends State<CinetPayWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("EFFECTUER LE PAIEMENT"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading =
                      false; // Lorsque la page est chargée, masquez le loader.
                });
              },
              backgroundColor: Colors.transparent,
            ),
            if (_isLoading)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  // color: Colors.white, // Couleur de fond du texte
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Veuillez patienter svp, vous serez redirigé vers la page de payement ...',
                    style: GoogleFonts.poppins(
                      // color: Colors.white, // Couleur du texte
                      fontSize: AppText.p2(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
