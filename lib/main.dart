import 'package:cible/core/routes.dart';
import 'package:cible/database/database.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');

    if (message.notification != null) {
      await NotificationService().showNotification(
          int.parse(message.data['id']),
          message.notification!.title!,
          message.notification!.body!,
          2);
      print('Message data: ${message.data}');
      print(
          'Message also contained a notification: ${message.notification!.body}');
    }
  });
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  String? fcmToken = await fcm.getToken();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcm_token', fcmToken == null ? fcmToken! : "");
  print('toke,fcm' + fcmToken.toString());
  runApp(MyApp(fcm: fcm));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.fcm, Key? key}) : super(key: key);

  final FirebaseMessaging? fcm;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Future<void>? initState() {
    // TODO: implement initState
    NotificationService.init();

    //FirebaseMessaging.instance.subscribeToTopic('cibleTopic');
    widget.fcm!.subscribeToTopic('cibleTopic');
    //FirebaseMessaging.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr', null);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppManagerProvider>(
            create: (_) => AppManagerProvider()),
        ChangeNotifierProvider<DefaultUserProvider>(
            create: (_) => DefaultUserProvider()),
        ChangeNotifierProvider<AppColorProvider>(
            create: (_) => AppColorProvider()),
      ],
      child: MaterialApp(
        title: 'Cible',
        theme: ThemeData(
            primarySwatch:
                const MaterialColor(0xFFf96643, AppColor.primarySwatch),
            primaryColor: AppColor.primaryColor),
        routes: routes,
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        initialRoute: '/welcome',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
