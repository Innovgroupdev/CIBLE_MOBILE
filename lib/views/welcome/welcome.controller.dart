import 'dart:ffi';

import 'package:cible/core/routes.dart';
import 'package:flutter/material.dart';

gotonextPage(context) async {
  var pagePosition = await getSharepreferencePagePosition();
  print(pagePosition);
  switch (pagePosition) {
    case 0:
      Navigator.pushReplacementNamed(context, '/splash');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/auth');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/actions', arguments: {});
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/authUserInfo', arguments: {});
      break;
    default:
      Navigator.pushReplacementNamed(context, '/splash');
  }
}
