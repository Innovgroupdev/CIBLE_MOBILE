import 'dart:async';

import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:provider/provider.dart';

verify(context) {
  Provider.of<DefaultUserProvider>(context, listen: false).otpload();
}
