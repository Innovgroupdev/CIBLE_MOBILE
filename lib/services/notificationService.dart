import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/subjects.dart';

import '../database/notificationDBcontroller.dart';
import '../models/notification.dart';

class NotificationService {
  static final onNotifications = BehaviorSubject<String?>();
  String? routeToGo;
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  static const simplePeriodicTask =
      "be.tramckrijte.workmanagerExample.simplePeriodicTask";
  static const simplePeriodic1HourTask =
      "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();
  static Future init({bool initScheduled = false}) async {
    tz.initializeTimeZones();
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('logo_cible');
    const settings = InitializationSettings(android: android, iOS: iOS);

//when the app is closed

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse!.payload);
    }
    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (notificationResponse) async {
      print('Today payload' + notificationResponse.payload!);
      onNotifications.add(notificationResponse.payload);
    });
  }

  Future<void> selectNotification(payload) async {
    if (payload != null) {
      debugPrint('notification payload : $payload');
      onNotifications.add(payload);
    }
    return payload;
  }

  Future<void> showNotification(
      int id, String title, String body, int seconds) async {
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        'Titre de la notification',
        'Contenu de la notification',
        RepeatInterval.everyMinute,
        const NotificationDetails(
            android: AndroidNotificationDetails('main_channel', 'Main channel',
                channelDescription: 'Main channel notification',
                importance: Importance.max,
                priority: Priority.high,
                icon: 'logo_cible')),
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
         await NotificationDBcontroller().insert(NotificationModel(
        101,
        'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
        'titre101',
        'description101',
        'type101',
        false));
        
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
