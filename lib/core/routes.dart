import 'package:cible/views/acceuil/acceuil.screen.dart';
import 'package:cible/views/auth/auth.screen.dart';
// import 'package:cible/views/auth/linkedinAuth.dart';
import 'package:cible/views/authActionChoix/authActionChoix.screen.dart';
import 'package:cible/views/authUserInfo/authUserInfo.screen.dart';
import 'package:cible/views/categorieEvents/categorieEvents.screen.dart';
import 'package:cible/views/eventDetails/eventDetails.screen.dart';
import 'package:cible/views/forgetPwd/emailVerification.dart';
import 'package:cible/views/forgetPwd/pwdConfirm.dart';
import 'package:cible/views/login/login.screen.dart';
import 'package:cible/views/modifieCompte/modifieCompte.screen.dart';
import 'package:cible/views/monCompte/monCompte.screen.dart';
import 'package:cible/views/parametre/parametre.screen.dart';
import 'package:cible/views/splash/splash.screen.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:cible/views/verificationRegister/verificationRegister.screen.dart';
import 'package:cible/views/welcome/welcome.screen.dart';
import 'package:flutter/material.dart';

import '../helpers/sharePreferenceHelper.dart';

var routes = {
  '/welcome': (context) => const Welcome(),
  '/splash': (context) => const Splash(),
  '/auth': (context) => const Auth(),
  '/acceuil': (context) => const Acceuil(),
};

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // settings.arguments
    switch (settings.name) {
      case "/welcome":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return new Welcome();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/splash":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return new Splash();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/auth":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return new Auth();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/login":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return new Login();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/emailVerification":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return EmailVerification();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
      case "/pwdVerification":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return PwdVerification();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
      case "/verification":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return Verification(data: settings.arguments as Map);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/verificationRegister":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return VerificationRegister(data: settings.arguments as Map);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/actions":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return AuthActionChoix(data: settings.arguments);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
      case "/authUserInfo":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return AuthUserInfo(data: settings.arguments);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
      case "/parametre":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return Parametre();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            });

      case "/moncompte":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return MonCompte();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.ease);
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
      case "/modifiecompte":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return ModifieCompte();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
      case "/eventDetails":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return EventDetails(data: settings.arguments as Map);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/categorieEvents":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return CategorieEvents(data: settings.arguments as Map);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      default:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return new Auth();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
    }
  }
}

setSharepreferencePagePosition(value) {
  SharedPreferencesHelper.setIntValue("pagePosition", value);
}

getSharepreferencePagePosition() {
  return SharedPreferencesHelper.getIntValue("pagePosition");
}
