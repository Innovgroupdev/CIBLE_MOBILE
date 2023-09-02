import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/models/notification.dart';
import 'package:cible/views/notifications/notifications.controller.dart';
import 'package:flutter/material.dart';

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
  // late List<NotificationModel> _notifications;

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
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
          backgroundColor: appColorProvider.defaultBg,
          appBar: AppBar(
            backgroundColor: appColorProvider.grey2,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: appColorProvider.black54,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Notifications",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54,
              ),
            ),
          ),
          body: FutureBuilder(
              future: fetchNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<NotificationModel>? notifications =
                      snapshot.data as List<NotificationModel>?;

                  if (notifications != null) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 30),
                      ),
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  Device.getDiviseScreenWidth(context, 30),
                              vertical:
                                  Device.getDiviseScreenWidth(context, 30),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  Device.getDiviseScreenHeight(context, 100),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.circle_notifications_sharp,
                                  color: appColorProvider.primaryColor,
                                  size: 30),
                              title: Text(
                                notification.titre,
                                style: GoogleFonts.poppins(
                                  fontSize: AppText.p2(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                notification.description,
                                style: GoogleFonts.poppins(
                                  fontSize: AppText.p3(context),
                                ),
                              ),
                              isThreeLine: true,
                              dense: true,
                              onTap: () {
                                print("object");
                              },
                              trailing: Text(
                                notification.date,
                                style: GoogleFonts.poppins(
                                  fontSize: AppText.p6(context),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('Pas notification disponible.');
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }));
    });
  }
}
