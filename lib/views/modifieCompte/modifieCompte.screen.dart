import 'dart:io';
import 'dart:async';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/widgets/photoprofil.dart';
import 'package:flutter/foundation.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/acceuilCategories/acceuilCategories.screen.dart';
import 'package:cible/views/authUserInfo/authUserInfo.screen.dart';
import 'package:cible/views/modifieCompte/modifieCompte.controller.dart';
import 'package:cible/views/modifieCompte/modifieCompte.widgets.dart';
import 'package:cible/widgets/raisedButtonDecor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';

import '../authActionChoix/authActionChoix.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ModifieCompte extends StatefulWidget {
  const ModifieCompte({Key? key}) : super(key: key);

  @override
  State<ModifieCompte> createState() => _ModifieCompteState();
}

class _ModifieCompteState extends State<ModifieCompte>
    with SingleTickerProviderStateMixin {
  final _tabKey = GlobalKey<State>();
  bool _isloading = false;
  FToast fToast = FToast();
  @override
  void initState() {
    // _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    Provider.of<AppManagerProvider>(context, listen: false)
        .initprofilTabController(this);
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: () {
            Provider.of<AppManagerProvider>(context, listen: false).userTemp =
                {};
            Navigator.pop(context);
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: appColorProvider.white,
            appBar: AppBar(
              backgroundColor: appColorProvider.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: appColorProvider.black87,
                onPressed: () {
                  Provider.of<AppManagerProvider>(context, listen: false)
                      .userTemp = {};
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
                color: appColorProvider.white,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Device.getDiviseScreenWidth(context, 30),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'Image_Profile',
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: Device.getDiviseScreenHeight(
                                          context, 6),
                                      width: Device.getDiviseScreenHeight(
                                          context, 6),
                                      child: Provider.of<AppManagerProvider>(
                                                      context,
                                                      listen: false)
                                                  .userTemp['image'] ==
                                              null
                                          ? photoProfil(
                                              context,
                                              appColorProvider.primaryColor4,
                                              100)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Provider.of<
                                                              AppManagerProvider>(
                                                          context,
                                                          listen: false)
                                                      .userTemp
                                                      .containsKey('imageType')
                                                  ? Provider.of<AppManagerProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .userTemp[
                                                              'imageType'] ==
                                                          'FILE'
                                                      ? 
                                                      Provider.of<AppManagerProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .userTemp['image']
                                                              .toString()
                                                              .startsWith(
                                                                  "/data/")
                                                          ?
                                                      Image.file(
                                                          File(Provider.of<
                                                                      AppManagerProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .userTemp['image']),
                                                          fit: BoxFit.cover,
                                                        )
                                                        : Image.network(Provider.of<
                                                                          AppManagerProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .userTemp['image'],
                                                              fit: BoxFit.cover,
                                                            )
                                                      : CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          imageUrl: Provider.of<
                                                                      DefaultUserProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .image,
                                                        )
                                                  : photoProfil(
                                                      context,
                                                      appColorProvider
                                                          .primaryColor4,
                                                      100),
                                            ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: appColorProvider.primary,
                                          ),
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                showBottomCameraChoix();
                                              },
                                              icon: const Icon(
                                                LineIcons.camera,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                        ))
                                  ],
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
                        ],
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    TabBar(
                      padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: Device.getDiviseScreenWidth(context, 30)),
                      labelColor: appColorProvider.primary,
                      unselectedLabelColor: appColorProvider.black54,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: AppText.p3(context),
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: const [
                        Tab(text: 'Mon identité'),
                        Tab(text: 'Mes contacts'),
                        Tab(text: 'Ma position'),
                      ],
                    ),
                    SizedBox(
                      height: Device.getDiviseScreenHeight(context, 2),
                      child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Device.getDiviseScreenHeight(context, 40),
                                  horizontal:
                                      Device.getDiviseScreenWidth(context, 15)),
                              child: ModifieIdentite(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal:
                                      Device.getDiviseScreenWidth(context, 20)),
                              child: ModifieContact(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal:
                                      Device.getDiviseScreenWidth(context, 20)),
                              child: ModifiePosition(),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: Device.getScreenHeight(context) / 50,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: Device.getDiviseScreenWidth(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButtonDecor(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            elevation: 0,
                            color: Colors.blueGrey[50],
                            shape: BorderRadius.circular(10),
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Annuler",
                              style: GoogleFonts.poppins(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppText.p2(context)),
                            ),
                          ),
                          RaisedButtonDecor(
                            onPressed: () async {
                              await updateUserProfil();
                              setState(() {
                                _isloading = true;
                              });
                              if (await updateUser(context)) {
                                setState(() {
                                  _isloading = false;
                                  fToast.showToast(
                                      fadeDuration:
                                          const Duration(milliseconds: 500),
                                      child: toastsuccess(context,
                                          "Votre profil à été mis à jour ! "));
                                });
                              } else {
                                setState(() {
                                  _isloading = false;
                                  fToast.showToast(
                                      fadeDuration:
                                          const Duration(milliseconds: 500),
                                      child: toastError(context,
                                          "Un problème est survenu lors la mise à jour du profil ! "));
                                });
                              }
                            },
                            elevation: 3,
                            color: appColorProvider.primaryColor1,
                            shape: BorderRadius.circular(10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: _isloading
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          child: const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              LineIcons.check,
                                              size: AppText.p2(context),
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Valider",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize:
                                                      AppText.p2(context)),
                                            ),
                                          ],
                                        ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Device.getDiviseScreenHeight(context, 10),
                    )
                  ],
                )),
          ),
        ),
      );
    });
  }

  showBottomCameraChoix() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer<AppColorProvider>(
              builder: (context, appColorProvider, child) {
            return Container(
              color: appColorProvider.white,
              height: Device.getDiviseScreenHeight(context, 4),
              padding: EdgeInsets.symmetric(
                  horizontal: Device.getDiviseScreenWidth(context, 15),
                  vertical: Device.getDiviseScreenHeight(context, 100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Photo de profil",
                        style: GoogleFonts.poppins(
                            color: appColorProvider.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppText.p3(context)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appColorProvider.primaryColor4,
                        ),
                        child: IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await removeImage();
                            },
                            icon: Icon(
                              LineIcons.trash,
                              color: appColorProvider.primary,
                              size: 20,
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: appColorProvider.darkMode
                                  ? appColorProvider.black12
                                  : appColorProvider.grey4,
                            ),
                            child: IconButton(
                              icon: Icon(
                                LineIcons.camera,
                                color: appColorProvider.black87,
                              ),
                              color: appColorProvider.black87,
                              onPressed: () async {
                                Navigator.pop(context);
                                await getImage(ImageSource.camera);
                              },
                            ),
                          ),
                          Text(
                            "\nCamera",
                            style: GoogleFonts.poppins(
                                color: appColorProvider.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: AppText.p3(context)),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Device.getDiviseScreenWidth(context, 10),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: appColorProvider.darkMode
                                  ? appColorProvider.black12
                                  : appColorProvider.grey4,
                            ),
                            child: IconButton(
                              icon: Icon(
                                LineIcons.photoVideo,
                                color: appColorProvider.black87,
                              ),
                              color: appColorProvider.black87,
                              onPressed: () async {
                                Navigator.pop(context);
                                await getImage(ImageSource.gallery);
                              },
                            ),
                          ),
                          Text(
                            "\nGalerie",
                            style: GoogleFonts.poppins(
                                color: appColorProvider.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: AppText.p3(context)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  Future getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);
    setState(() {
      if (Provider.of<AppManagerProvider>(context, listen: false)
          .userTemp
          .containsKey('imageType')) {
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['imageType'] = 'FILE';
      } else {
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp
            .addAll({'imageType': 'FILE'});
      }

      if (Provider.of<AppManagerProvider>(context, listen: false)
          .userTemp
          .containsKey('image')) {
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp['image'] = photo!.path;
      } else {
        Provider.of<AppManagerProvider>(context, listen: false)
            .userTemp
            .addAll({'image': photo!.path});
      }
    });
  }

  Future removeImage() async {
    setState(() {
      Provider.of<DefaultUserProvider>(context, listen: false).image = '';
      Provider.of<DefaultUserProvider>(context, listen: false).imageType = '';
    });
    await UserDBcontroller().update(
        Provider.of<DefaultUserProvider>(context, listen: false)
            .toDefaulUserModel);
  }

  Future updateUserProfil() async {
    if (Provider.of<AppManagerProvider>(context, listen: false)
        .userTemp
        .containsKey('image')) {
      if (Provider.of<AppManagerProvider>(context, listen: false)
              .userTemp
              .containsKey('imageType') &&
          Provider.of<AppManagerProvider>(context, listen: false)
                  .userTemp['imageType'] ==
              'FILE') {
        await SharedPreferencesHelper.setValue("ppType", 'FILE');
      } else {
        await SharedPreferencesHelper.setValue("ppType", '');
      }
      setState(() {
        Provider.of<DefaultUserProvider>(context, listen: false).image =
            Provider.of<AppManagerProvider>(context, listen: false)
                .userTemp['image'];
        Provider.of<DefaultUserProvider>(context, listen: false).imageType =
            Provider.of<AppManagerProvider>(context, listen: false)
                .userTemp['imageType'];
      });
    }
  }
}
