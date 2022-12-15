import 'package:cible/constants/api.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

verifieEmailInApi(email) async {
  print('resau auth : ' + email);
  // var response = await http.post(
  //   Uri.parse("$baseApiUrl/verifyemailexists/$email/part"),
  //   headers: {"Accept": "application/json", "Content-Type": "application/json"},
  // );

  // Map data = {'user_email': email, 'verification_type': 'email'};
  // print('resau auth : ' + email);
  // var response = await http.post(Uri.parse("$baseApiUrl/verify/part"),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json"
  //     },
  //     body: jsonEncode(data));
  // print('resau auth : ' + response.statusCode.toString());
  // print(jsonDecode(response.body)['status']);

  var response = await http.post(
    Uri.parse('$baseApiUrl/verifyemailexists/$email/part'),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );
  print(response.statusCode.toString());
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == 'success') {
      return 0;
    } else if (responseBody['status'] == 'exists') {
      return 1;
    } else if (responseBody['status'] == 'error') {
      return 2;
    }
  } else {
    return 3;
  }
}

verifieNumberInApi(countryCode, number) async {
  Map data = {
    'user_phone_number': '$countryCode$number',
    'verification_type': 'sms'
  };
  print('resau auth : ' + '$countryCode$number');
  var response = await http.post(Uri.parse("$baseApiUrl/verify/part"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));
  print('resau auth : ' + response.statusCode.toString());
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body) as Map;

    if (responseBody['status'] == 'sucess') {
      return 0;
    } else if (responseBody['status'] == 'exists') {
      return 1;
    } else if (responseBody['status'] == 'error') {
      return 2;
    }
  } else {
    return 3;
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
    if (responseBody['Status'] == 'Found') {
      return 0;
    } else {
      return 1;
    }
  } else {
    return 2;
  }
}

connetUserReseauIfExists(context, user) async {
  if (await verifieEmailInApi(user.reseauCode == 'insta'
          ? '${user.userName}@cible.com'
          : user.email1) ==
      0) {
    if (await loginUserReseau(context, user.email1)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
