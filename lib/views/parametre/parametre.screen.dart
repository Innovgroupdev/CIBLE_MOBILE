import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Parametre extends StatefulWidget {
  Parametre({required this.etat, Key? key}) : super(key: key);
  var etat;

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Parametres",
            style: GoogleFonts.poppins(
                fontSize: AppText.p4(context), fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
          color: appColorProvider.defaultBg,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              widget.etat != null && !widget.etat
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/parametrage');
                      },
                      child: ListTile(
                        title: Text(
                          "Paramètre de suggestion d'evènements",
                          style: GoogleFonts.poppins(
                              fontSize: AppText.p5(context),
                              fontWeight: FontWeight.w500,
                              color: appColorProvider.black),
                        ),
                      ),
                    ),
              ListTile(
                  title: Text(
                    "Thème sombre",
                    style: GoogleFonts.poppins(
                        fontSize: AppText.p5(context),
                        fontWeight: FontWeight.w500,
                        color: appColorProvider.black),
                  ),
                  trailing: Switch(
                      activeColor: appColorProvider.primary,
                      value: appColorProvider.darkMode,
                      onChanged: (onChanged) {
                        // appColorProvider.todarkMode();
                        setState(() {
                          print(onChanged);
                          if (!appColorProvider.darkMode) {
                            appColorProvider.darkMode = true;
                            appColorProvider.todarkMode();
                          } else {
                            appColorProvider.darkMode = false;
                            appColorProvider.toLightMode();
                          }
                        });
                      })),
              Divider(color: appColorProvider.black12)
            ],
          ),
        ),
      );
    });
  }
}
