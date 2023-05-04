import 'package:cible/helpers/colorsHelper.dart';
import 'package:flutter/material.dart';
// import '../utils/constants.dart';

class RaisedButtonDecor extends StatefulWidget {
  final void Function() onPressed;
  Widget child = Text("");
  dynamic color = AppColor.primaryColor3;
  BorderRadius shape = BorderRadius.circular(10);
  EdgeInsetsGeometry padding = EdgeInsets.all(10);
  double elevation = 0;
  RaisedButtonDecor(
      {Key? key,
      required this.onPressed,
      required this.child,
      required this.color,
      required this.padding,
      required this.elevation,
      required this.shape})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<RaisedButtonDecor> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: widget.shape,
      ),
      color: widget.color,
      elevation: widget.elevation,
      padding: widget.padding,
      child: Container(alignment: Alignment.center, child: widget.child),
    );
  }
}
