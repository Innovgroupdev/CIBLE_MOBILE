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
    if (await verifyCodeSend(context)) {
      return true;
    } else {
      return false;
    }
  }
}

verifyCodeSend(context) async {
  // print(Provider.of<AppManagerProvider>(context, listen: false).typeAuth);
  var temp =
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth == 1
          ? await VerificationCode(context)
          : await VerificationNumCode(context);
  print(temp);
  return temp;
}

VerificationCode(context) async {
  print(Provider.of<DefaultUserProvider>(context, listen: false).otpValue);
  print(Provider.of<DefaultUserProvider>(context, listen: false).email1);
  Map<String, dynamic> data = {
    'email': Provider.of<DefaultUserProvider>(context, listen: false).email1,
    'validation_type': 'email',
    'code': Provider.of<DefaultUserProvider>(context, listen: false).otpValue,
  };
  var response = await http.post(Uri.parse('$baseApiUrl/validate/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.statusCode);
  // print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    print(responseBody['status']);
    print(responseBody['message']);
    if (responseBody['status']) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

VerificationNumCode(context) async {
  print(Provider.of<DefaultUserProvider>(context, listen: false).otpValue);
  print(Provider.of<DefaultUserProvider>(context, listen: false).email1);
  Map<String, dynamic> data = {
    'telephone':
        '${Provider.of<DefaultUserProvider>(context, listen: false).codeTel1}${Provider.of<DefaultUserProvider>(context, listen: false).tel1}',
    'validation_type': 'sms',
    'code': Provider.of<DefaultUserProvider>(context, listen: false).otpValue,
  };
  var response = await http.post(Uri.parse('$baseApiUrl/validate/part'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print(response.statusCode);
  print(jsonDecode(response.body));
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
