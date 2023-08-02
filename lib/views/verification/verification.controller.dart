import 'dart:async';

import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cible/constants/api.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

verify(context) async {
  Provider.of<DefaultUserProvider>(context, listen: false).otpload();
  if (Provider.of<DefaultUserProvider>(context, listen: false).otp['loading']) {
    print("Envoie du code !");
    if (await verificationCode(context)) {
      return true;
    } else {
      return false;
    }
  }
}

verificationCode(context) async {
  print(Provider.of<DefaultUserProvider>(context, listen: false).otpValue);
  print(Provider.of<AppManagerProvider>(context, listen: false)
      .forgetPasswd['email']);

  Map<String, String> data;

  bool isTypeEmail =
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth == 1;

  var type = isTypeEmail ? "email" : "phone";

  if (isTypeEmail) {
    data = {
      'email': Provider.of<DefaultUserProvider>(context, listen: false).email1,
      'code': Provider.of<DefaultUserProvider>(context, listen: false).otpValue,
    };
  } else {
    data = {
      'phone_number':
          Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 +
              Provider.of<DefaultUserProvider>(context, listen: false).tel1,
      'code': Provider.of<DefaultUserProvider>(context, listen: false).otpValue,
    };
  }

  var response = await http.post(
      Uri.parse('$baseApiUrl/approve_identity/part/$type'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      return true;
    }
    return false;
  }
  return false;
}
