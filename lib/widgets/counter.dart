import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Counter extends StatefulWidget {
  var start;
  var current;
  var style;
  VoidCallback onRestart;
  Counter(
      {this.start,
      this.current,
      this.style,
      required this.onRestart,
      super.key});

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
    startDecount();
  }

  @override
  void dispose() {
    current = 0;
    countSeconde = 0;
    super.dispose();
  }

  startDecount() {
    setState(() {
      countSeconde--;
    });
    if (current == 0 && countSeconde == 0) {
      return;
    }
    if (countSeconde >= 0) {
      Timer(const Duration(seconds: 1), () {
        startDecount();
      });
    }
    if (current >= 1 && countSeconde < 0) {
      current--;
      countSeconde = 60;
      startDecount();
    } else if (current < 1 && countSeconde < 1) {
      current = 0;
      countSeconde = 0;
      return;
    }

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
