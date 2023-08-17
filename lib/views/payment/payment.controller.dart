import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/payementProvider.dart';
import 'package:cible/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../../providers/gadgetProvider.dart';
import '../../providers/ticketProvider.dart';

FToast fToast = FToast();

Future payement(context) async {
  var token = await SharedPreferencesHelper.getValue('token');
  var idCommande =
      Provider.of<PayementProvider>(context, listen: false).idCommande;
  var data = {
    "recap": Provider.of<PayementProvider>(context, listen: false).recap
  };

  print(jsonEncode(data));
  print(idCommande);
  print(token);

  var response = await http.post(
    Uri.parse('$baseApiUrl/orders/pay/$idCommande'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    print("gooddddd");
    print(responseBody["status"]);
    switch (responseBody["status"]) {
      case false:
        {
          fToast.showToast(
            fadeDuration: Duration(seconds: 500),
            toastDuration: const Duration(seconds: 5),
            child: toastError(context,
                "Vous ne posseder pas assez de sous\nVeuillez recharger votre portefeuille"),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/rechargercompte");
        }
        break;
      case "error":
        {
          fToast.showToast(
            fadeDuration: Duration(seconds: 500),
            toastDuration: const Duration(seconds: 5),
            child: toastError(context,
                "Une erreur s'est produite.\nVeuillez réessayer plus tard"),
          );
        }
        break;
      case 201:
        {
          fToast.showToast(
            fadeDuration: Duration(seconds: 500),
            toastDuration: const Duration(seconds: 5),
            child: toastsuccess(context, "Paiement accepté !"),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Provider.of<TicketProvider>(context, listen: false)
              .setTicketsList([]);
          Provider.of<ModelGadgetProvider>(context, listen: false)
              .setGadgetsList([]);
          Navigator.pushNamed(context, "/moncompte");
        }
        break;
      default:
        {
          fToast.showToast(
            fadeDuration: Duration(seconds: 500),
            toastDuration: const Duration(seconds: 5),
            child: toastError(context,
                "Une erreur s'est produite.\nVeuillez réessayer plus tard"),
          );
        }
        break;
    }
  } else {
    print("badddddd");

    {
      fToast.showToast(
        fadeDuration: Duration(seconds: 500),
        toastDuration: const Duration(seconds: 5),
        child: toastError(context,
            "Une erreur s'est produite.\nVeuillez réessayer plus tard"),
      );
    }
  }
}
