import 'package:cible/constants/api.dart';
import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/services/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

updatePasswordFromAPI(context, password) async {
  Map<String, dynamic> data = {
    'email': Provider.of<AppManagerProvider>(context, listen: false)
        .forgetPasswd['email'],
    'password': password,
  };
  print(data);
  var response =
      await http.post(Uri.parse('$baseApiUrl/userparticulars/updatepassword'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(data));
  print(response.statusCode);
  print(jsonDecode(response.body));
  print('ggggggghhhh' +
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel
          .toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    Provider.of<DefaultUserProvider>(context, listen: false).password =
        password;
    await UserDBcontroller().update(
        Provider.of<DefaultUserProvider>(context, listen: false)
            .toDefaulUserModel);
    return true;
  } else {
    return false;
  }
}
