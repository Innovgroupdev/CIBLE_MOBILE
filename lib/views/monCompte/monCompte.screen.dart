import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';

class MonCompte extends StatefulWidget {
  const MonCompte({Key? key}) : super(key: key);

  @override
  State<MonCompte> createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  // int _controller.index = 0;
  final _tabKey = GlobalKey<State>();
  @override
  void initState() {
    _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        backgroundColor: appColorProvider.defaultBg,
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
            "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p2(context),
                fontWeight: FontWeight.bold,
                color: appColorProvider.black54),
          ),
        ),
        body: Container(
            color: appColorProvider.defaultBg,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Device.getDiviseScreenWidth(context, 30),
                  ),
                  child: Card(
                    color: appColorProvider.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Device.getDiviseScreenWidth(context, 30),
                          vertical: Device.getDiviseScreenHeight(context, 50)),
                      child: Column(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'Image_Profile',
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Badge(
                                  toAnimate: true,
                                  badgeColor: Color.fromARGB(255, 93, 255, 28),
                                  shape: BadgeShape.circle,
                                  position: BadgePosition(bottom: 15, end: 15),
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: 100,
                                    width: 100,
                                    child: Provider.of<DefaultUserProvider>(
                                                    context,
                                                    listen: false)
                                                .image ==
                                            ''
                                        ? Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/logo_blanc.png"),
                                                  fit: BoxFit.cover,
                                                )),
                                            height: 50,
                                            width: 50,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                imageUrl: Provider.of<
                                                            DefaultUserProvider>(
                                                        context,
                                                        listen: false)
                                                    .image,
                                                height: 100,
                                                width: 100),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${Provider.of<DefaultUserProvider>(context, listen: false).prenom} ${Provider.of<DefaultUserProvider>(context, listen: false).nom}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontSize: AppText.p1(context),
                                fontWeight: FontWeight.w800,
                                color: Provider.of<AppColorProvider>(context,
                                        listen: false)
                                    .black54),
                          ),
                          Text(
                            "${Provider.of<DefaultUserProvider>(context, listen: false).email1}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                fontSize: AppText.p4(context),
                                fontWeight: FontWeight.w400,
                                color: Provider.of<AppColorProvider>(context,
                                        listen: false)
                                    .black38),
                          ),
                          SizedBox(
                            height: Device.getScreenHeight(context) / 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p1(context),
                                        fontWeight: FontWeight.w800,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black54),
                                  ),
                                  Text(
                                    "Tickets",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w400,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black38),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p1(context),
                                        fontWeight: FontWeight.w800,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black54),
                                  ),
                                  Text(
                                    "Notifications",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w400,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black38),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "0 F",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p1(context),
                                        fontWeight: FontWeight.w800,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black54),
                                  ),
                                  Text(
                                    "Solde",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p4(context),
                                        fontWeight: FontWeight.w400,
                                        color: Provider.of<AppColorProvider>(
                                                context,
                                                listen: false)
                                            .black38),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: Device.getScreenHeight(context) / 50,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: BorderSide(
                                        width: 0.7,
                                        color: appColorProvider.black26),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LineIcons.pen,
                                            color: appColorProvider.black87,
                                            size: AppText.p5(context)),
                                        SizedBox(width: 5),
                                        Text(
                                          "Modifier mon compte",
                                          style: GoogleFonts.poppins(
                                              color: appColorProvider.black87,
                                              fontSize: AppText.p5(context)),
                                        ),
                                      ]),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: RaisedButtonDecor(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  elevation: 0,
                                  color: appColorProvider.primaryColor,
                                  shape: BorderRadius.circular(5),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Mon portefeuil",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: AppText.p5(context)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Device.getScreenHeight(context) / 50,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Device.getDiviseScreenWidth(context, 20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _controller.animateTo(0,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                });
                              },
                              child: Container(
                                height: 30,
                                decoration: _controller.index == 0
                                    ? BoxDecoration(
                                        color: appColorProvider.darkMode
                                            ? appColorProvider.black12
                                            : appColorProvider.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)))
                                    : BoxDecoration(
                                        color: appColorProvider.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),

                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Catégories",
                                  style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: AppText.p3(context),
                                      fontWeight: _controller.index == 0
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      color: appColorProvider.black87),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // _tabKey.currentState.
                                setState(() {
                                  _controller.animateTo(1,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                });
                              },
                              child: Container(
                                  decoration: _controller.index == 1
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: _controller.index == 1
                                      ? const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20)
                                      : const EdgeInsets.all(0),
                                  child: Text(
                                    "Dates",
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p3(context),
                                        fontWeight: _controller.index == 1
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: appColorProvider.black87),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _controller.animateTo(2,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                });
                              },
                              child: Container(
                                  decoration: _controller.index == 2
                                      ? BoxDecoration(
                                          color: appColorProvider.darkMode
                                              ? appColorProvider.black12
                                              : appColorProvider.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)))
                                      : BoxDecoration(
                                          color: appColorProvider.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),

                                  // ignore: prefer_const_constructors
                                  padding: _controller.index == 2
                                      ? const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20)
                                      : const EdgeInsets.all(0),
                                  child: Text(
                                    "Lieux",
                                    style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontSize: AppText.p3(context),
                                        fontWeight: _controller.index == 2
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: appColorProvider.black87),
                                  )),
                            ),
                          ],
                        ),
                      )),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Expanded(
                        flex: 20,
                        child: Stack(
                          children: [
                            TabBarView(
                              physics: const BouncingScrollPhysics(),
                              controller: _controller,
                              key: _tabKey,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Expanded(
                                    child: Text('vide 1'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Expanded(
                                    child: Text('vide2'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Expanded(
                                    child: Text('vide3'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      );
    });
  }
}
