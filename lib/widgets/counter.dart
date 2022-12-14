import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Counter extends StatefulWidget {
  var start;
  var current;
  var style;
  Counter({this.start, this.current, this.style, super.key});

  @override
  State<Counter> createState() =>
      _CounterState(start: start, current: current, style: style);
}

class _CounterState extends State<Counter> {
  var start;
  var current;
  var style;
  var countSeconde = 60;
  get minute => current - 1;
  _CounterState({this.start, this.current, this.style});
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      startDecount();
    });
  }

  @override
  void dispose() {
    current = 0;
    countSeconde = 0;
    super.dispose();
  }

  startDecount() {
    print(countSeconde);
    countSeconde--;
    if (current == 0 && countSeconde == 0) {
      return;
    }
    if (countSeconde > 1) {
      Timer(const Duration(seconds: 1), () {
        startDecount();
      });
    } else {
      if (current >= 1) {
        current--;
      } else if (current < 1 && countSeconde < 1) {
        current = 0;
        countSeconde = 0;
        return;
      } else {
        countSeconde = 60;
      }
    }
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$current min : $countSeconde s',
      style: style,
    );
  }
}
