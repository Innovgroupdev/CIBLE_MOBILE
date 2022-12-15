import 'package:cible/core/routes.dart';
import 'package:cible/database/database.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  Database _database = await CibleDataBase().database;
  runApp(MyApp(
    database: _database,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.database}) : super(key: key);
  final Database database;

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
