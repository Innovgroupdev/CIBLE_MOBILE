import 'package:cible/constants/api.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

updatePasswordFromAPI(context, password) async {
  Map<String, String> data;

  bool isTypeEmail =
      Provider.of<AppManagerProvider>(context, listen: false).typeAuth == 1;

  var type = isTypeEmail ? "email" : "phone";

  if (isTypeEmail) {
    data = {
      'email': Provider.of<DefaultUserProvider>(context, listen: false).email1,
      'password': password,
    };
  } else {
    data = {
      'phone_number':
          Provider.of<DefaultUserProvider>(context, listen: false).codeTel1 +
              Provider.of<DefaultUserProvider>(context, listen: false).tel1,
      'password': password,
    };
  }

  print(data);
  var response =
      await http.post(Uri.parse('$baseApiUrl/user/part/resetpassword/$type'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    Provider.of<DefaultUserProvider>(context, listen: false).password =
        password;

    return true;
  } else {
    return false;
  }
}
