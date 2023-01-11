import 'package:cible/core/routes.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/providers/eventsProvider.dart';
import 'package:cible/providers/portefeuilleProvider.dart';
import 'package:cible/providers/ticketProvider.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ChangeNotifierProvider<EventsProvider>(create: (_) => EventsProvider()),
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
