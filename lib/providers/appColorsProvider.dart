import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColorProvider with ChangeNotifier {
  bool darkMode = false;

  // Primary color Section

  Color primaryColor = Color(0xFFf96643);
  Color primaryColor1 = Color.fromARGB(255, 255, 119, 84);
  Color primaryColor2 = Color.fromARGB(255, 255, 137, 107);
  Color primaryColor3 = Color.fromARGB(255, 255, 178, 159);
  Color primaryColor4 = Color.fromARGB(255, 255, 205, 192);
  Color primaryColor5 = Color.fromARGB(255, 255, 223, 215);
  Color primary = Color(0xFFf96643);

  // Black color Section

  Color transparent = Colors.transparent;

  // Menu color Section

  Color menu = Color.fromARGB(255, 255, 255, 255);

// defaultBg color Section

  Color defaultBg = Color.fromARGB(255, 235, 235, 235);

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

// Gey color SectionP

  Color? grey1 = Colors.grey[50];
  Color? grey2 = Colors.grey[100];
  Color? grey3 = Colors.grey[200];
  Color? grey4 = Colors.grey[300];
  Color? grey5 = Colors.grey[400];
  Color? grey6 = Colors.grey;
  Color? grey7 = Colors.grey[600];
  Color? grey8 = Colors.grey[700];
  Color? grey9 = Colors.grey[800];
  Color? grey10 = Colors.grey[900];

  // BlueAccent color Section

  // =======================================================================================================//
  //                                                                                                        //
  //                                           DARK MODE                                                    //
  //                                                                                                        //
  // =======================================================================================================//

  todarkMode() async {
    darkMode = true;

    // Primary color Section

    primaryColor = Color.fromARGB(255, 194, 87, 60);
    primaryColor1 = Color.fromARGB(255, 134, 70, 54);
    primaryColor2 = Color.fromARGB(255, 99, 59, 50);
    primaryColor3 = Color.fromARGB(255, 85, 62, 55);
    primaryColor4 = Color.fromARGB(255, 100, 62, 53);
    primaryColor5 = Color.fromARGB(255, 161, 97, 82);
    primary = Color.fromARGB(255, 194, 87, 60);

    // Menu color Section

    menu = Color.fromARGB(255, 29, 29, 29);

    // defaultBg color Section

    defaultBg = Color.fromARGB(255, 12, 12, 12);

    // Categories colors Section

    categoriesColor(int i) {
      switch (i) {
        case 0:
          return Color.fromARGB(255, 49, 83, 26);
        case 1:
          return Color.fromARGB(255, 122, 36, 65);
        case 2:
          return Color.fromARGB(255, 21, 76, 121);
        case 3:
          return Color.fromARGB(255, 163, 108, 26);
        case 4:
          return Color.fromARGB(255, 80, 18, 104);
        case 5:
          return Color.fromARGB(255, 23, 97, 75);
        default:
          return Color.fromARGB(255, 21, 45, 92);
      }
    }

    // Black color Section

    black = Color.fromARGB(255, 230, 230, 230);
    black12 = Color.fromARGB(31, 255, 255, 255);
    black26 = Color.fromARGB(66, 255, 255, 255);
    black38 = Color.fromARGB(96, 255, 255, 255);
    black45 = Color.fromARGB(115, 255, 255, 255);
    black54 = Color.fromARGB(137, 255, 255, 255);
    black87 = Color.fromARGB(221, 255, 255, 255);

    // White color Section

    white = Color.fromARGB(255, 19, 19, 19);
    white10 = Colors.black87;
    white12 = Colors.black54;
    white24 = Colors.black45;
    white30 = Colors.black38;
    white38 = Colors.black26;
    white54 = Colors.black12;
    white60 = Color.fromARGB(31, 22, 22, 22);
    white70 = Color.fromARGB(31, 88, 88, 88);

    // Blue color Section

    blue1 = Color.fromARGB(255, 191, 201, 209);
    blue2 = Color.fromARGB(255, 131, 152, 170);
    blue3 = Color.fromARGB(255, 78, 105, 128);
    blue4 = Color.fromARGB(255, 50, 85, 114);
    blue5 = Color.fromARGB(255, 50, 100, 141);
    blue6 = Color.fromARGB(255, 28, 77, 117);
    blue7 = Color.fromARGB(255, 21, 75, 122);
    blue8 = Color.fromARGB(255, 28, 76, 124);
    blue9 = Color.fromARGB(255, 16, 49, 87);
    blue10 = Color.fromARGB(255, 11, 34, 70);

    // Gey color Section

    grey1 = Color.fromARGB(255, 54, 54, 54);
    grey2 = Color.fromARGB(255, 59, 59, 59);
    grey3 = Color.fromARGB(255, 85, 85, 85);
    grey4 = Color.fromARGB(255, 107, 107, 107);
    grey5 = Color.fromARGB(255, 85, 85, 85);
    grey6 = Color.fromARGB(255, 73, 73, 73);
    grey7 = Color.fromARGB(255, 43, 43, 43);
    grey8 = Color.fromARGB(255, 43, 43, 43);
    grey9 = Color.fromARGB(255, 36, 36, 36);
    grey10 = Color.fromARGB(255, 19, 19, 19);
    // BlueAccent color Section
    await SharedPreferencesHelper.setBoolValue('darkMode', darkMode);
    notifyListeners();
  }

  // =======================================================================================================//
  //                                                                                                        //
  //                                           LIGHT MODE                                                   //
  //                                                                                                        //
  // =======================================================================================================//

  toLightMode() async {
    darkMode = false;

    // Primary color Section

    primaryColor = Color(0xFFf96643);
    primaryColor1 = Color.fromARGB(255, 255, 119, 84);
    primaryColor2 = Color.fromARGB(255, 255, 137, 107);
    primaryColor3 = Color.fromARGB(255, 255, 178, 159);
    primaryColor4 = Color.fromARGB(255, 255, 205, 192);
    primaryColor5 = Color.fromARGB(255, 255, 223, 215);
    primary = Color(0xFFf96643);

    // Menu Section

    menu = Color.fromARGB(255, 255, 255, 255);

// defaultBg Section

    defaultBg = Color.fromARGB(255, 235, 235, 235);

    // Categories colors Section

    categoriesColor(int i) {
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

    // Black Section

    black = Colors.black;
    black12 = Colors.black12;
    black26 = Colors.black26;
    black38 = Colors.black38;
    black45 = Colors.black45;
    black54 = Colors.black54;
    black87 = Colors.black87;

    // White Section

    white = Colors.white;
    white10 = Colors.white10;
    white12 = Colors.white12;
    white24 = Colors.white24;
    white30 = Colors.white30;
    white38 = Colors.white38;
    white54 = Colors.white54;
    white60 = Colors.white60;
    white70 = Colors.white70;

    // Blue Section

    blue1 = Colors.blue[50];
    blue2 = Colors.blue[100];
    blue3 = Colors.blue[200];
    blue4 = Colors.blue[300];
    blue5 = Colors.blue[400];
    blue6 = Colors.blue;
    blue7 = Colors.blue[600];
    blue8 = Colors.blue[700];
    blue9 = Colors.blue[800];
    blue10 = Colors.blue[900];

    // Gey color Section

    grey1 = Colors.grey[50];
    grey2 = Colors.grey[100];
    grey3 = Colors.grey[200];
    grey4 = Colors.grey[300];
    grey5 = Colors.grey[400];
    grey6 = Colors.grey;
    grey7 = Colors.grey[600];
    grey8 = Colors.grey[700];
    grey9 = Colors.grey[800];
    grey10 = Colors.grey[900];

    // BlueAccent color Section
    await SharedPreferencesHelper.setBoolValue('darkMode', darkMode);
    notifyListeners();
  }
}
