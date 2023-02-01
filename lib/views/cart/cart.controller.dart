import 'package:cible/models/defaultUser.dart';
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
    context, total, DefaultUser user, List<TicketUser> tickets) async {
  print('userrrrrrrrrrrrrrr');
  print(user.id);
  print(user.nom);
  print('start');
  Map data = {
    'total': total,
    'user': 192,
    'tickets': tickets.map((e) => e.toMap()).toList()
  };
  print('dataaaaaa');
  print(jsonEncode(data));
  var response = await http.post(
    Uri.parse("$baseApiUrl/ticket/buy"),
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
    Navigator.pushNamed(context, "/payment");
  } else {
    fToast.showToast(
        fadeDuration: 500,
        toastDuration: const Duration(seconds: 5),
        child: toastError(context, "Une erreur est survenue lors de l'achat"));
  }
}
