import 'package:flutter/material.dart';

class Device {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  static double getStaticScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
   static double getStaticDiviseScreenWidth(BuildContext context,value) {
    return MediaQuery.of(context).size.width / value;
  }

  static double getDiviseScreenWidth(BuildContext context, value) {
    return getScreenWidth(context) / value;
  }

  static double getMultiplieScreenWidth(BuildContext context, value) {
    return getScreenWidth(context) * value;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
  }

  static double getStaticScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double getStaticDeviseScreenHeight(BuildContext context,value) {
    return MediaQuery.of(context).size.height / value;
  }

  static double getDiviseScreenHeight(BuildContext context, value) {
    return getScreenHeight(context) / value;
  }

  static double getMultiplieScreenHeight(BuildContext context, value) {
    return getScreenHeight(context) * value;
  }
}
