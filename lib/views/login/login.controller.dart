import 'package:cible/constants/api.dart';
import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:cible/services/login.dart';
import 'package:cible/services/register.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cible/constants/instagramApi.dart' as instagramApi;
import 'package:cible/constants/linkedinApi.dart' as linkedinAPi;
import 'dart:convert';
import 'package:cible/providers/defaultUser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

Future<void> showInstagramAuthDialog(context) async {
  // bool etat = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Device.getDiviseScreenHeight(context, 8),
            horizontal: Device.getDiviseScreenWidth(context, 20)),
        child: Center(
          child: WebView(
            initialUrl: instagramApi.initialUrl,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(instagramApi.redirectUri)) {
                print("url insta redi: -- " + request.url);
                if (request.url.contains('error')) {
                  print('the url error');
                }

                var startIndex = request.url.indexOf('code=');
                var endIndex = request.url.lastIndexOf('#');
                var code = request.url.substring(startIndex + 5, endIndex);
                _logIn(context, code.toString());
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url) => print("Page started " + url),
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onPageFinished: (url) => instagramApi.stackIndex = 0,
          ),
        ),
      );
    },
  );
}

Future<void> _logIn(context, String code) async {
  () => instagramApi.stackIndex = 2;

  try {
    // Step 1. Get user's short token using facebook developers account information
    // Http post to Instagram access token URL.
    final http.Response response = await http
        .post(Uri.parse("https://api.instagram.com/oauth/access_token"), body: {
      "client_id": instagramApi.appId,
      "redirect_uri": instagramApi.redirectUri,
      "client_secret": instagramApi.appSecret,
      "code": code,
      "grant_type": "authorization_code"
    });
    // print(json.decode(response.body));

    // Step 2. Change Instagram Short Access Token -> Long Access Token.
    final http.Response responseLongAccessToken = await http.get(Uri.parse(
        'https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=${instagramApi.appSecret}&access_token=${json.decode(response.body)['access_token']}'));
    // print(json.decode(responseLongAccessToken.body));
    // Step 3. Take User's Instagram Information using LongAccessToken
    final http.Response responseUserData = await http.get(Uri.parse(
        'https://graph.instagram.com/${json.decode(response.body)['user_id'].toString()}?fields=id,username,email,account_type,media_count&access_token=${json.decode(responseLongAccessToken.body)['access_token']}'));
    print(responseUserData.statusCode);
    print(json.decode(responseUserData.body));
    Provider.of<DefaultUserProvider>(context, listen: false).clear();
    Provider.of<DefaultUserProvider>(context, listen: false).reseauCode =
        'insta';
    Provider.of<DefaultUserProvider>(context, listen: false).userName =
        json.decode(responseUserData.body)['username'];

    Provider.of<DefaultUserProvider>(context, listen: false).reseauInfo =
        json.decode(responseUserData.body);
    Navigator.pop(context);

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        // user must tap button!
        builder: (BuildContext context) {
          connectIfLoginAvailable(context);
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // Step 4. Making Custom Token For Firebase Authentication using Firebase Function.
    // final http.Response responseCustomToken = await http.get(
    //      Uri.parse('$authFunctionUrl?instagramToken=${json.decode(responseUserData.body)['id']}'));

  } catch (e) {
    print(e.toString());
  }
}

Future<void> showLinkedinAuthDialog(context) async {
  // bool etat = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Device.getDiviseScreenHeight(context, 8),
            horizontal: Device.getDiviseScreenWidth(context, 20)),
        child: Center(
          child: LinkedInUserWidget(
            redirectUrl: linkedinAPi.redirectUrl,
            clientId: linkedinAPi.clientId,
            clientSecret: linkedinAPi.clientSecret,
            projection: const [
              ProjectionParameters.id,
              ProjectionParameters.localizedFirstName,
              ProjectionParameters.localizedLastName,
              ProjectionParameters.firstName,
              ProjectionParameters.lastName,
              ProjectionParameters.profilePicture,
            ],
            onGetUserProfile: (UserSucceededAction linkedInUser) async {
              // print(
              //     'image LN : ${linkedInUser.user.profilePicture?.displayImageContent?.elements![0].identifiers![0].identifier}');
              // ignore: unnecessary_null_comparison

              try {
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .clear();
                Provider.of<DefaultUserProvider>(context, listen: false)
                        .email1 =
                    '${linkedInUser.user.email?.elements![0].handleDeep?.emailAddress!}';
                Provider.of<DefaultUserProvider>(context, listen: false).nom =
                    '${linkedInUser.user.localizedLastName}';
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .prenom = '${linkedInUser.user.localizedFirstName}';
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .image = linkedInUser
                            .user
                            .profilePicture
                            ?.displayImageContent
                            ?.elements![0]
                            .identifiers![0]
                            .identifier !=
                        null
                    ? '${linkedInUser.user.profilePicture?.displayImageContent?.elements![0].identifiers![0].identifier}'
                    : '';
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .reseauCode = 'link';
                Provider.of<DefaultUserProvider>(context, listen: false)
                    .reseauInfo = {
                  'email':
                      '${linkedInUser.user.email?.elements![0].handleDeep?.emailAddress!}',
                  'nom': '${linkedInUser.user.localizedLastName}',
                  'prenom': '${linkedInUser.user.localizedFirstName}',
                  'image': linkedInUser.user.profilePicture?.displayImageContent
                              ?.elements![0].identifiers![0].identifier !=
                          null
                      ? '${linkedInUser.user.profilePicture?.displayImageContent?.elements![0].identifiers![0].identifier}'
                      : '',
                  'id': '${linkedInUser.user.userId}',
                  'token': '${linkedInUser.user.token.accessToken}'
                };
              } catch (e) {
                print(e);
              }

              Navigator.pop(context);

              showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  // user must tap button!
                  builder: (BuildContext context) {
                    connectIfLoginAvailable(context);
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            },
            onError: (UserFailedAction e) {
              print('Error: ${e.toString()}');
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );
}

Future<void> showFacebookAuthDialog(context) async {
  FacebookAuth.instance.login(
      permissions: ["public_profile", "email"],
      loginBehavior: LoginBehavior.dialogOnly).then((value) {
    FacebookAuth.instance.getUserData().then((userData) async {
      print(userData);
      Provider.of<DefaultUserProvider>(context, listen: false).clear();
      Provider.of<DefaultUserProvider>(context, listen: false).email1 =
          userData['email'];
      Provider.of<DefaultUserProvider>(context, listen: false).nom =
          userData['name'].toString().split(' ')[1];
      Provider.of<DefaultUserProvider>(context, listen: false).prenom =
          userData['name'].toString().split(' ')[0];
      Provider.of<DefaultUserProvider>(context, listen: false).image =
          userData['picture']['data']['url'];
      Provider.of<DefaultUserProvider>(context, listen: false).reseauCode =
          'face';
      Provider.of<DefaultUserProvider>(context, listen: false).reseauInfo =
          userData;
      connectIfLoginAvailable(context);
    });
  });

  // FacebookAuth.instance.expressLogin();
}

connectIfLoginAvailable(context) async {
  if (!await connetUserReseauIfExists(
      context, Provider.of<DefaultUserProvider>(context, listen: false))) {
    await SharedPreferencesHelper.setBoolValue('RegisterSMSType', false);
    Provider.of<AppManagerProvider>(context, listen: false).typeAuth = 1;
    Navigator.pop(context);
    Navigator.pushNamed(context, "/actions");
  }
}
