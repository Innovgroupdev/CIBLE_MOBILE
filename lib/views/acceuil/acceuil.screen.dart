import 'dart:async';

import 'package:cible/constants/localPath.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/acceuil/acceuil.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connecté !"),
        actions: [
          Hero(
            tag: "Image_Profile",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl:
                      Provider.of<DefaultUserProvider>(context, listen: false)
                          .image,
                  height: 20,
                  width: 60),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: UserDBcontroller().liste(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List users = snapshot.data as List;
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Text(users[index].email1);
                  });
            } else {
              return Center(
                child: Text("Aucune données"),
              );
            }
          }),
    );
  }
}
