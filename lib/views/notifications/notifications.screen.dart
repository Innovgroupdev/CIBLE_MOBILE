import 'package:cible/models/notification.dart';
import 'package:cible/views/notifications/notifications.controller.dart';
import 'package:flutter/material.dart';

import '../../database/notificationDBcontroller.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badge;

import '../../widgets/raisedButtonDecor.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  dynamic notifs;
  // final Future<NotificationModel> _notifications =
  //     [] as Future<NotificationModel>;
  @override
  void initState() {
    // TODO: implement initState
    //insertNotification();
    // NotificationDBcontroller().liste().then((value) {
    //   setState(() {
    //     notifs = value as List;
    //     for (var i in notifs) {}
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items = List<String>.generate(10000, (i) => 'Item $i');
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
          appBar: AppBar(
            foregroundColor: appColorProvider.white,
            elevation: 0,
            title: Text(
              "Notifications",
              style: GoogleFonts.poppins(
                fontSize: AppText.p2(context),
              ),
            ),
          ),
          body: FutureBuilder(
              // future: _notifications,
              builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: items.length,
                prototypeItem: ListTile(
                  title: Text(items.first),
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              );
            } else {
              return ListView.builder(
                itemCount: items.length,
                prototypeItem: ListTile(
                  title: Text(items.first),
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              );
            }
          }));
    });
  }
}
