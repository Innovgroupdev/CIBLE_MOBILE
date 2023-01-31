import 'package:cible/helpers/sharePreferenceHelper.dart';

Future payement() async {
  var token = await SharedPreferencesHelper.getValue('token');

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
