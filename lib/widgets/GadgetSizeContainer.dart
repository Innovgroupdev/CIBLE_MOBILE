import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/textHelper.dart';
import '../providers/appColorsProvider.dart';
import 'package:google_fonts/google_fonts.dart';

class GadgetSizeContainer extends StatefulWidget {
   GadgetSizeContainer({required this.taille,required this.sizeBorder,required this.textColor,required this.fillColors,Key? key}) : super(key: key);
  String taille;
  Color? fillColors;
  Color? textColor;
  BoxBorder? sizeBorder;

  @override
  State<GadgetSizeContainer> createState() => _GadgetSizeContainerState();
}

class _GadgetSizeContainerState extends State<GadgetSizeContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Container(
        height: 30,
        width: 40,
        decoration: BoxDecoration(
          color: widget.fillColors,
          borderRadius: BorderRadius.circular(5),
          border: widget.sizeBorder,
        ),
        child: Center(
          child: Text(
            widget.taille,
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p3(context),
                color: widget.textColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }
}
