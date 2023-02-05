import 'package:flutter/material.dart';

import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CinetPayWebView extends StatefulWidget {
  const CinetPayWebView({required this.url,Key? key}) : super(key: key);
  final String url;

  @override
  State<CinetPayWebView> createState() => _CinetPayWebViewState();
}

class _CinetPayWebViewState extends State<CinetPayWebView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor:
              Provider.of<AppColorProvider>(context, listen: false).black54,
          title: Text(
            "Recharger mon compte",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p1(context),
                fontWeight: FontWeight.w800,
                color: Provider.of<AppColorProvider>(context, listen: false)
                    .black54),
          ),
          centerTitle: true,
        ),
        body: WebView(
          initialUrl:widget.url,
          javascriptMode: JavascriptMode.unrestricted
        )
        );
  });
}
}