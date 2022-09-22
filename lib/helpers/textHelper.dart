import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:flutter/cupertino.dart';

class AppText {
  static final titre1 = (context) => Device.getDiviseScreenWidth(context, 16);
  static final titre2 = (context) => Device.getDiviseScreenWidth(context, 19);
  static final titre3 = (context) => Device.getDiviseScreenWidth(context, 21);
  static final p1 = (context) => Device.getDiviseScreenWidth(context, 25);
  static final p2 = (context) => Device.getDiviseScreenWidth(context, 30);
   static final p3 = (context) => Device.getDiviseScreenWidth(context, 33);
}
