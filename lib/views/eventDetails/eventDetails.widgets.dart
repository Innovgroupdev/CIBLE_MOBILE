import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:flutter/material.dart';

import '../../providers/appColorsProvider.dart';

class MarqueWidget extends StatelessWidget {
  final String libelle;
  final String description;

  const MarqueWidget(
      {super.key, required this.libelle, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Device.getDiviseScreenHeight(context, 50),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Device.getDiviseScreenHeight(context, 100),
        horizontal: Device.getDiviseScreenWidth(context, 5),
      ),
      decoration: BoxDecoration(
        color: AppColorProvider().primary,
        borderRadius: BorderRadius.all(
          Radius.circular(
            Device.getDiviseScreenHeight(context, 150),
          ),
        ),
      ),
      child: Column(
        children: [
          Text(libelle),
          Text(description),
        ],
      ),
    );
  }
}
