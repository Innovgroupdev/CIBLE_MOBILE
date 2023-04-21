import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class SharedPreferencesHelper {
  static Future<String> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static Future<int> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.remove(key));
    return prefs.getInt(key) ?? 0;
  }

  static Future<bool?> getBoolValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  static Future<double> getDoubleValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.remove(key));
    return prefs.getDouble(key) ?? 0;
  }

  static Future<bool> setValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<bool> setIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  static Future<bool?> setBoolValue(String key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

    static Future<bool> setDoubleValue(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setDouble(key, value);
  }

    Future<String> getDeviceIdFirst() async{
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String id = 'iddd';
    try{
      if(Platform.isAndroid){
        await deviceInfoPlugin.androidInfo.then((value) {
          id = value.id;
        });
      }else if(Platform.isIOS){
        await deviceInfoPlugin.iosInfo.then((value) {
          id = value.name!;
        });
      }
    }on PlatformException{
print('unable to get the device platform');
    }
    return id;
  }
}
