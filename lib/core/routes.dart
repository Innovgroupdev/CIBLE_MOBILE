import 'package:cible/views/acceuil/acceuil.screen.dart';
import 'package:cible/views/auth/auth.screen.dart';
// import 'package:cible/views/auth/linkedinAuth.dart';
import 'package:cible/views/authActionChoix/authActionChoix.screen.dart';
import 'package:cible/views/authUserInfo/authUserInfo.screen.dart';
import 'package:cible/views/cart/cart.screen.dart';
import 'package:cible/views/categorieEvents/categorieEvents.screen.dart';
import 'package:cible/views/evenements/evenement.screen.dart';
import 'package:cible/views/eventDetails/eventDetails.screen.dart';
import 'package:cible/views/gadgets/gadgets.screen.dart';
import 'package:cible/views/lieuEvents/lieuEvents.screen.dart';
import 'package:cible/views/payment/payment.screen.dart';
import 'package:cible/views/forgetPwd/emailVerification.dart';
import 'package:cible/views/forgetPwd/pwdConfirm.dart';
import 'package:cible/views/login/login.screen.dart';
import 'package:cible/views/modifieCompte/modifieCompte.screen.dart';
import 'package:cible/views/monCompte/monCompte.screen.dart';
import 'package:cible/views/parametre/parametre.screen.dart';
import 'package:cible/views/portefeuille/portefeuille.screen.dart';
import 'package:cible/views/sondage/sondage.screen.dart';
import 'package:cible/views/splash/splash.screen.dart';
import 'package:cible/views/ticket/ticket.screen.dart';
import 'package:cible/views/verification/verification.screen.dart';
import 'package:cible/views/verificationRegister/verificationRegister.screen.dart';
import 'package:cible/views/wallet/wallet.screen.dart';
import 'package:cible/views/welcome/welcome.screen.dart';
import 'package:cible/widgets/facture.dart';
import 'package:cible/widgets/parametrage.dart';
import 'package:flutter/material.dart';

import '../helpers/sharePreferenceHelper.dart';
import '../miseAJourFonctionnalite/miseAJourFonc.screen.dart';
import '../models/Event.dart';
import '../models/ticket.dart';
import '../views/gadgetCart/gadgetCart.screen.dart';
import '../views/notifications/notifications.screen.dart';
import '../views/rechargerCompte/cinetPayWebView.screen.dart';
import '../views/rechargerCompte/rechargerCompte.screen.dart';
import '../views/termesEtConditions/termesEtConditions.screen.dart';
import '../views/ticketsPayes/ticketsPayes.screen.dart';
import '../widgets/facturePdfPage.dart';
import '../widgets/ticketPdfPage.dart';

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
              return Parametre(etat: settings.arguments,);
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
            case "/termesEtConditions":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return TermesEtConditions(etat: settings.arguments,);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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

      // case "/evenement":
      //   return PageRouteBuilder(
      //       fullscreenDialog: true,
      //       pageBuilder: (context, animation, secondaryAnimation) {
      //         return const Evenement();
      //       },
      //       transitionsBuilder:
      //           (context, animation, secondaryAnimation, child) {
      //         animation =
      //             CurvedAnimation(parent: animation, curve: Curves.ease);
      //         return FadeTransition(
      //           opacity: animation,
      //           child: child,
      //         );
      //       });

            case "/sondage":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return SondageScreen(data: settings.arguments as Event1);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
        case "/gadgets":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return GadgetsScreen(eventsIdList: settings.arguments as List);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

      case "/cart":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return CartScreen();
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
        case "/gadgetcart":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return GadgetCartScreen();
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
            

      case "/payment":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return PaymentScreen();
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

      case "/ticket":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return TicketScreen();
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

      case "/portefeuille":
        return PageRouteBuilder(
            fullscreenDialog: true,
            pageBuilder: (context, animation, secondaryAnimation) {
              return PortefeuilleScreen();
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
      case "/wallet":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return Wallet();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/notifications":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return Notifications();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/rechargercompte":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return RechargerCompte();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

        case "/mafacture":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return MaFacture(data: settings.arguments as List<Ticket>);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

case "/parametrage":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return Parametrage();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

      case "/miseajourfonc":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return MiseAJourFonc(data: settings.arguments);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
      case "/ticketspayes":
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return TicketsPayes(eventId: settings.arguments as int);
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.ease);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

      case "/lieuEvents":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return LieuEvents(data: settings.arguments as Map);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.ease);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case "/ticketpdfpage":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return TicketPdfPage(map: settings.arguments as Map);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.ease);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

case "/facturepdfpage":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FacturePdfPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.ease);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

        
        case "/cinetPayWebView":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CinetPayWebView(url: settings.arguments as String);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.ease);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

        

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
