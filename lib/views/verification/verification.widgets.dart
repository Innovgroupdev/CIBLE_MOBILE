import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:cible/views/verification/verification.controller.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:cible/widgets/formWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Widget inputOTP(context, valeur, first, last) {
  return Expanded(
    flex: 1,
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: TextFormField(
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            decoration: inputDecorationGrey("", Device.getScreenWidth(context)),
            validator: (val) => val.toString().isEmpty ? '' : null,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              if (val.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .otp
                    .addAll({'val$valeur': val.toString()});
              }
              if (val.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .otp
                    .removeWhere((key, value) => key.contains('val$valeur'));
              }
              if (val.length == 1 && !first && last) {
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .otp
                    .addAll({'val$valeur': val.toString()});
              }
              if (val.isEmpty && first && !last) {
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .otp
                    .removeWhere((key, value) => key.contains('val$valeur'));
              }
              //  verify(context);
            }),
      ),
    ),
  );
}
