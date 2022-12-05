import 'dart:async';

import 'package:cible/models/Event.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppManagerProvider with ChangeNotifier {
  late TabController profilTabController;
  initprofilTabController(page) {
    profilTabController =
        TabController(initialIndex: 0, length: 3, vsync: page);
  }

  tabControllerstateChangePlus() {
    profilTabController.index += 1;
    notifyListeners();
  }

  tabControllerstateChangeMoins() {
    profilTabController.index -= 1;
    notifyListeners();
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

  Map _forgetPasswd = {'email': '', 'code': ''};

  Map get forgetPasswd => _forgetPasswd;

  set forgetPasswd(Map forgetPasswd) {
    _forgetPasswd = forgetPasswd;
    notifyListeners();
  }

  int _typeAuth = 0;

  int get typeAuth => _typeAuth;

  set typeAuth(int typeAuth) {
    _typeAuth = typeAuth;
    notifyListeners();
  }

  late Event1 _currentEvent;

  Event1 get currentEvent => _currentEvent;

  set currentEvent(Event1 currentEvent) {
    _currentEvent = currentEvent;
    notifyListeners();
  }

  int _currentEventIndex = 0;

  int get currentEventIndex => _currentEventIndex;

  set currentEventIndex(int currentEventIndex) {
    _currentEventIndex = currentEventIndex;
    notifyListeners();
  }

  int _curentCategorieIndex = 0;

  int get curentCategorieIndex => _curentCategorieIndex;

  set curentCategorieIndex(int curentCategorieIndex) {
    _curentCategorieIndex = curentCategorieIndex;
    notifyListeners();
  }
}
