import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/payementProvider.dart';
import 'package:cible/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
    Uri.parse('$baseApiUrl/ticketuser/pay/$idCommande'),
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
            fadeDuration: 500,
            toastDuration: const Duration(seconds: 5),
            child: toastError(context,
                "Vous ne posseder pas assez de sous\nVeuillez recharger votre portefeuille"),
          );
        }
        break;
      case "error":
        {
          fToast.showToast(
            fadeDuration: 500,
            toastDuration: const Duration(seconds: 5),
            child: toastError(context,
                "Une erreur s'est produite.\nVeuillez réessayer plus tard"),
          );
        }
        break;
      case 201:
        {
          fToast.showToast(
            fadeDuration: 500,
            toastDuration: const Duration(seconds: 5),
            child: toastsuccess(context, "Paiement accepté !"),
          );
        }
        break;
      default:
        {
          fToast.showToast(
            fadeDuration: 500,
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
        fadeDuration: 500,
        toastDuration: const Duration(seconds: 5),
        child: toastError(context,
            "Une erreur s'est produite.\nVeuillez réessayer plus tard"),
      );
    }
  }

  // if (total > portefeuilleSolde) {
  //   fToast.showToast(
  //       fadeDuration: 500,
  //       toastDuration: const Duration(seconds: 5),
  //       child: toastError(context,
  //           "Vous ne posseder pas assez de sous\nVeuillez recharger votre portefeuille"));
  // } else {
  //   fToast.showToast(
  //       fadeDuration: 500,
  //       toastDuration: const Duration(seconds: 5),
  //       child: toastsuccess(context, "Paiement accepté !"));
  //   Provider.of<PortefeuilleProvider>(context, listen: false)
  //       .setSolde(portefeuilleSolde - total);
  //   Navigator.pushNamed(context, "/ticket");
  // }
}
