

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../helpers/sharePreferenceHelper.dart';
import 'package:http/http.dart' as http;

sendSondageResponse(context,List finalResponsesList,int eventId) async {
  var status = false;
  var response;
  var token = await SharedPreferencesHelper.getValue('token');
    Map<String, dynamic> data = {
      'data': finalResponsesList,
    };
    
  print('brrrrrrrrrrrrr'+data.toString());
    response = await http.post(
        Uri.parse(
            '$baseApiUrl/survey-answers/events/${eventId}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));

    print(response.statusCode);
    print(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('fuckuuuuu Success');
      status = true;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, "/moncompte");
    } else {
      status = false;
    }
  return status;
}