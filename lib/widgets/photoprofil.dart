import 'dart:io';

import 'package:cible/providers/defaultUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';

photoProfil(context, Color bg, double radius) {
  return Consumer<DefaultUserProvider>(
      builder: (context, defaultUserProvider, child) {
    print(defaultUserProvider.imageType);
    return defaultUserProvider.image.isEmpty ||
            defaultUserProvider.imageType.isEmpty
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                image: DecorationImage(
                  image: AssetImage(defaultUserProvider.sexe == 'Homme'
                      ? "assets/images/avatar1.png"
                      : "assets/images/avatar2.png"),
                  fit: BoxFit.cover,
                )),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              color: bg,
              child: defaultUserProvider.imageType == 'FILE'
                  ? Image.file(
                      File(defaultUserProvider.image),
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl: defaultUserProvider.image,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
          );
  });
}
