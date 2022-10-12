import 'package:cible/constants/api.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

verifieEmailInApi(email) async {
  print('resau auth : ' + email);
  var response = await http.post(
    Uri.parse("$baseApiUrl/verifyemailexists/$email/part"),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );
  print('resau auth : ' + response.statusCode.toString());
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    if (responseBody['Status']) {
      return 0;
    } else {
      return 1;
    }
  } else {
    return 2;
  }
}

verifieEmailInApiAndSendMail(email) async {
  var response = await http.get(
    Uri.parse('$baseApiUrl/finduser/$email/part'),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );
  print(response.statusCode);
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
