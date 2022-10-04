import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppManagerProvider with ChangeNotifier {
  late TabController profilTabController;
  initprofilTabController(page) {
    profilTabController =
        TabController(initialIndex: 0, length: 3, vsync: page);
  }

  categoriesIcon(int i) {
    switch (i) {
      case 0:
        return LineIcons.guitar;
      case 1:
        return LineIcons.users;
      case 2:
        return LineIcons.videoFile;
      case 3:
        return LineIcons.graduationCap;
      case 4:
        return LineIcons.bicycle;
      case 5:
        return LineIcons.flagCheckered;
      default:
        return LineIcons.music;
    }
  }

  Map _userTemp = {};

  Map get userTemp => _userTemp;

  set userTemp(Map userTemp) {
    _userTemp = userTemp;
    notifyListeners();
  }
}
