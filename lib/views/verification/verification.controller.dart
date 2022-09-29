import 'dart:async';

import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

verify(context) {
  Provider.of<DefaultUserProvider>(context, listen: false).otpload();
  if (Provider.of<DefaultUserProvider>(context, listen: false).otp['loading']) {
    print("Envoie du code !");
    Provider.of<DefaultUserProvider>(context, listen: false).otpPurge();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/actions");
  }
}
