import 'package:cible/constants/api.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

verifieEmailInApi(email) async {
  print('resau auth : ' + email);
   Map data = {'user_type': "part", 'email': email};

  var response = await http.post(
    Uri.parse('$baseApiUrl/check'),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
    body: jsonEncode(data)
  );
  print(response.statusCode.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == false) {
      return 0;
    } else {
      return 1;
    }
  } else {
    return 2;
  }
}
verifieNumberInApi(countryCode, number) async {
  Map data = {'user_type': "part", 'phone_number': '${countryCode}${number}'};
  print('resau auth : ' + '$countryCode$number');
  var response = await http.post(Uri.parse("$baseApiUrl/check"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print('resau auth : ' + response.statusCode.toString());
  print(jsonDecode(response.body).toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body) as Map;

    if (responseBody['status'] == false) {
      return 0;
    } else{
      return 1;
    }
  } else {
    return 2;
  }
}

verifieEmailInApiAndSendMail(email) async {
  var response = await http.post(
    Uri.parse('$baseApiUrl/sendcodetomail/$email/part'),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );
  print(response.statusCode.toString());
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['Status'] != 'Found') {
      print('Fuckkkk0');
      return 0;
    } else {
      print('Fuckkkk${responseBody['Status']}');
      return 1;
    }
  } else {
    return 2;
  }
}

connetUserReseauIfExists(context, user) async {
  if (await verifieEmailInApi(user.reseauCode == 'insta'
          ? '${user.userName}@cible.com'
          : user.email) ==
      0) {
    if (await loginUserReseau(context, user.email)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
