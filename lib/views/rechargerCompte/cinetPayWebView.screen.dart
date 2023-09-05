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
      appBar: AppBar(
        elevation: 0,
        title: Text("EFFECTUER LE PAIEMENT"),
        centerTitle: true,
      ),
      body: Stack(
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
          ),
          if (_isLoading)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // color: Colors.black, // Couleur de fond du texte
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Veuillez patienter svp, Vous serez redirigé vers la page de payement ...',
                  style: TextStyle(
                    // color: Colors.white, // Couleur du texte
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
