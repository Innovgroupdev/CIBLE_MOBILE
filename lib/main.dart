import 'dart:io';

import 'package:cible/core/routes.dart';
import 'package:cible/database/database.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/models/notification.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/eventsProvider.dart';
import 'package:cible/providers/gadgetProvider.dart';
import 'package:cible/providers/payementProvider.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/notificationDBcontroller.dart';
import 'firebase_options.dart';
import 'helpers/sharePreferenceHelper.dart';
import 'services/notificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  dynamic deviceId;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
//await NotificationDBcontroller().insert();
    if (message.notification != null) {

      // await NotificationService().showNotification(
      //     int.parse(message.data['id']),
      //     message.notification!.title!,
      //     message.notification!.body!,
      //     2);
      print('Message data: ${message.data}');
      print(
          'Message also contained a notification: ${message.notification!.body}');
    }
  });
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  String? fcmToken = await fcm.getToken();
  
  bool isFirstRunning = true;
  final prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('isFirstRunning') != null)
  {
    isFirstRunning = false;
    
    //print('fuiiiiiiiiiiii'+isFirstRunning.toString());
  }else{
    prefs.setBool('isFirstRunning', true);

     await SharedPreferencesHelper().getDeviceIdFirst().then((value) {
    deviceId = value;
    SharedPreferencesHelper.setValue('deviceId',deviceId);
  }) ;
  print('deviceeId '+deviceId );
  }
  await prefs.setString('fcmToken', fcmToken != null ? fcmToken : "");
 
  print('fcmtokennnn' + fcmToken.toString());
  runApp(MyApp(isFirstRunning: isFirstRunning,fcm: fcm));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.isFirstRunning,required this.fcm, Key? key}) : super(key: key);

  final FirebaseMessaging? fcm;
  final bool isFirstRunning;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Future<void>? initState() {
    // TODO: implement initState
    NotificationService.init();
  
    //FirebaseMessaging.instance.subscribeToTopic('cibleTopic');
    widget.fcm!.subscribeToTopic('ciblePartTopic');
    //FirebaseMessaging.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
//  NotificationService().showNotification(
//           0,
//           '',
//           '',
//           2);
    initializeDateFormatting('fr', null);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppManagerProvider>(
            create: (_) => AppManagerProvider()),
        ChangeNotifierProvider<DefaultUserProvider>(
            create: (_) => DefaultUserProvider()),
        ChangeNotifierProvider<PortefeuilleProvider>(
            create: (_) => PortefeuilleProvider()),
        ChangeNotifierProvider<AppColorProvider>(
            create: (_) => AppColorProvider()),
        ChangeNotifierProvider<TicketProvider>(create: (_) => TicketProvider()),
        ChangeNotifierProvider<ModelGadgetProvider>(create: (_) => ModelGadgetProvider()),
        ChangeNotifierProvider<EventsProvider>(create: (_) => EventsProvider()),
        ChangeNotifierProvider<PayementProvider>(
            create: (_) => PayementProvider()),
      ],
      child: MaterialApp(
        title: 'CIBLE',
        theme: ThemeData(
            primarySwatch:
                const MaterialColor(0xFFf96643, AppColor.primarySwatch),
            primaryColor: AppColor.primaryColor),
        routes: routes,
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        initialRoute: 
        widget.isFirstRunning?
        //'/splash':
        '/welcome':
        '/welcome',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
