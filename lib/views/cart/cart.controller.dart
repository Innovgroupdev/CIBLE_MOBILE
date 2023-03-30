import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/modelGadgetUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:cible/providers/payementProvider.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cible/constants/api.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

FToast fToast = FToast();

Future passerAchat(
    context, total, DefaultUser user, List<TicketUser> tickets,List<ModelGadgetUser> gadgets) async {
  var token = await SharedPreferencesHelper.getValue('token');
  var userId;

  var responseUser = await http.get(
    Uri.parse("$baseApiUrl/particular/profile"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  if (responseUser.statusCode == 200 || responseUser.statusCode == 201) {
    var responseUserBody = jsonDecode(responseUser.body);
    userId = responseUserBody["data"]["id"];
  }

  Map data = {
    'total': total,
    'user': userId,
    'tickets': tickets.map((e) => e.toMap()).toList(),
    "gadgetsdata":gadgets.map((e) => e.toMap()).toList(),
  };
  print('loicccccccccc'+data.toString());

  var response = await http.post(
    Uri.parse("$baseApiUrl/orders"),
    body: jsonEncode(data),
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    Provider.of<PayementProvider>(context, listen: false)
        .setRecap(responseBody["recap"]);
    Provider.of<PayementProvider>(context, listen: false)
        .setIdCommande(responseBody["current_commande"]);
        Navigator.of(context).pop();
    Navigator.pushNamed(context, "/payment");
  } else {
    fToast.showToast(
      fadeDuration: Duration(seconds: 500),
      toastDuration: const Duration(seconds: 5),
      child: toastError(context, "Une erreur est survenue lors de l'achat"),
    );
  }
}
