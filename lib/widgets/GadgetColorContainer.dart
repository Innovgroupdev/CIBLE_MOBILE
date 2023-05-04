import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appColorsProvider.dart';

class GadgetColorContainer extends StatefulWidget {
  GadgetColorContainer({required this.color,required this.icon,Key? key}) : super(key: key);
  Color? color;
  Icon? icon;

  @override
  State<GadgetColorContainer> createState() => _GadgetColorContainerState();
}

class _GadgetColorContainerState extends State<GadgetColorContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return 
    Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        border: widget.color == Colors.white?
        Border.all(width: 2,color: appColorProvider.black45):null,
        borderRadius: BorderRadius.circular(1000),color: widget.color),
      child: widget.icon,
    );
  });
}}