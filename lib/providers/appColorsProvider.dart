import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColorProvider with ChangeNotifier {
  // Primary color Section

  Color primaryColor = Color(0xFFf96643);
  Color primaryColor1 = Color.fromARGB(255, 255, 119, 84);
  Color primaryColor2 = Color.fromARGB(255, 255, 137, 107);
  Color primaryColor3 = Color.fromARGB(255, 255, 178, 159);
  Color primary = Color(0xFFf96643);

  // Black color Section

  Color transparent = Colors.transparent;

  // Menu color Section

  Color menu = Color.fromARGB(255, 255, 255, 255);

  // Categories colors Section

  Color categoriesColor(int i) {
    switch (i) {
      case 0:
        return Color.fromARGB(255, 70, 172, 3);
      case 1:
        return Colors.pink;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Color.fromARGB(255, 183, 0, 255);
      case 5:
        return Color.fromARGB(255, 4, 160, 113);
      default:
        return Color.fromARGB(255, 0, 89, 255);
    }
  }

  // Black color Section

  Color black = Colors.black;
  Color black12 = Colors.black12;
  Color black26 = Colors.black26;
  Color black38 = Colors.black38;
  Color black45 = Colors.black45;
  Color black54 = Colors.black54;
  Color black87 = Colors.black87;

  // White color Section

  Color white = Colors.white;
  Color white10 = Colors.white10;
  Color white12 = Colors.white12;
  Color white24 = Colors.white24;
  Color white30 = Colors.white30;
  Color white38 = Colors.white38;
  Color white54 = Colors.white54;
  Color white60 = Colors.white60;
  Color white70 = Colors.white70;

  // Blue color Section

  Color? blue1 = Colors.blue[50];
  Color? blue2 = Colors.blue[100];
  Color? blue3 = Colors.blue[200];
  Color? blue4 = Colors.blue[300];
  Color? blue5 = Colors.blue[400];
  Color? blue6 = Colors.blue;
  Color? blue7 = Colors.blue[600];
  Color? blue8 = Colors.blue[700];
  Color? blue9 = Colors.blue[800];
  Color? blue10 = Colors.blue[900];

  // BlueAccent color Section

}
