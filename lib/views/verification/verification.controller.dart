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
    if (await VerificationCode(context)) {
      return true;
    } else {
      return false;
    }
  }
}

VerificationCode(context) async {
  print(Provider.of<DefaultUserProvider>(context, listen: false).otpValue);
  print(Provider.of<AppManagerProvider>(context, listen: false)
      .forgetPasswd['email']);
  Map<String, dynamic> data = {
    'email': Provider.of<AppManagerProvider>(context, listen: false)
        .forgetPasswd['email'],
    'code': Provider.of<DefaultUserProvider>(context, listen: false).otpValue,
  };
  var response = await http.post(Uri.parse('$baseApiUrl/validateemail/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.statusCode);
  // print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['status']) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
