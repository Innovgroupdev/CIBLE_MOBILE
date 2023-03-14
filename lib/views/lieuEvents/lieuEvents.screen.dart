import 'dart:convert';
import 'dart:ui';

import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:gap/gap.dart';
import 'package:cible/providers/eventsProvider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LieuEvents extends StatefulWidget {
  Map data;
  LieuEvents({super.key, required this.data});

  @override
  _LieuEventsState createState() => _LieuEventsState(data['indexLieu'] as int);
}

class _LieuEventsState extends State<LieuEvents> {
  int indexLieu;
  List eventsLieu = [];
  Map data = {};
  _LieuEventsState(this.indexLieu);

  @override
  void initState() {
    super.initState();
    eventsLieu =
        Provider.of<EventsProvider>(context, listen: false).eventsLieux;
  }

  @override
  Widget build(BuildContext context) {
    Map eventLieuIndexed = eventsLieu[indexLieu];
    data = (ModalRoute.of(context)!.settings.arguments ?? {}) as Map;

    print(eventLieuIndexed);

    return Consumer<AppColorProvider>(
      builder: (context, appColorProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColorProvider.defaultBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              color: appColorProvider.black87,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              // "${_data[1].titre}",
              eventLieuIndexed['lieu'],
              style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  fontSize: AppText.p1(context),
                  fontWeight: FontWeight.bold,
                  color: appColorProvider.black87),
            ),
          ),
          body: Container(
            color: appColorProvider.white,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventLieuIndexed['events'].length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10000),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(
                                // eventLieuIndexed['events'][index]
                                //     ['event']['image']
                                base64Decode(eventLieuIndexed['events'][index]
                                    ['event']['image']),
                              ),
                              fit: BoxFit.cover,
                            )),
                            height: Device.getDiviseScreenHeight(context, 20),
                            width: Device.getDiviseScreenHeight(context, 20),
                          ),
                        ),
                        title: Text(
                          "${eventLieuIndexed['events'][index]['event']['user']['raisonSocial']}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: AppText.p3(context),
                            fontWeight: FontWeight.w800,
                            color: appColorProvider.black87,
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: appColorProvider.primary,
                        ),
                      ),
                    ),
                    const Gap(5),
                    eventLieuIndexed['events'][index]['event']['image'].isEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/logo_blanc.png"),
                                  fit: BoxFit.cover,
                                )),
                            width: Device.getDiviseScreenWidth(context, 1),
                            height: Device.getDiviseScreenHeight(context, 2.4),
                          )
                        : InkWell(
                            onTap: () {
                              Provider.of<AppManagerProvider>(context,
                                      listen: false)
                                  .currentEventIndex = index;
                              Navigator.pushNamed(
                                context,
                                '/eventDetails',
                                arguments: {
                                  "event": eventLieuIndexed['events'][index]
                                      ['event']
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  // borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width:
                                        Device.getDiviseScreenWidth(context, 1),
                                    height: Device.getDiviseScreenHeight(
                                        context, 2.4),
                                    color: appColorProvider.primaryColor3,
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                                    // eventLieuIndexed['events']
                                                    // [index]['event']['image'],
                                            base64Decode(
                                                eventLieuIndexed['events']
                                                    [index]['event']['image']),
                                            width: Device.getDiviseScreenWidth(
                                                context, 1),
                                            height:
                                                Device.getDiviseScreenHeight(
                                                    context, 2.4),
                                            fit: BoxFit.cover),
                                        ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 4.0, sigmaY: 4.0),
                                            child: Container(
                                              width:
                                                  Device.getDiviseScreenWidth(
                                                      context, 1),
                                              height:
                                                  Device.getDiviseScreenHeight(
                                                      context, 2.4),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Image.memory(
                                            // eventLieuIndexed['events']
                                            //               [index]['event']
                                            //           ['image'],
                                              base64Decode(
                                                  eventLieuIndexed['events']
                                                          [index]['event']
                                                      ['image']),
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Device.getDiviseScreenHeight(context, 100),
                        horizontal: Device.getDiviseScreenHeight(context, 70),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: appColorProvider.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Device.getDiviseScreenHeight(
                                                  context, 100),
                                          vertical:
                                              Device.getDiviseScreenHeight(
                                                  context, 100),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
