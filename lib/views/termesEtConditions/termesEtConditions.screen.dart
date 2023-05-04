import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../helpers/screenSizeHelper.dart';

class TermesEtConditions extends StatefulWidget {
  TermesEtConditions({required this.etat, Key? key}) : super(key: key);
  var etat;

  @override
  State<TermesEtConditions> createState() => _TermesEtConditionsState();
}

class _TermesEtConditionsState extends State<TermesEtConditions> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Termes et conditions",
            style: GoogleFonts.poppins(
                fontSize: AppText.p4(context), fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
          color: appColorProvider.defaultBg,
          child: Padding(
             padding: EdgeInsets.all(Device.getDiviseScreenWidth(context, 20),),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                widget.etat != null && !widget.etat ?
              SizedBox():
            Text(
  
                        """POLITIQUE DE CONFIDENTIALITE

Nous respectons la vie privée de nos utilisateurs ainsi que celle des visiteurs de notre site Web. Nous traitons donc vos données personnelles avec soin. Par le biais de cette politique de confidentialité, nous tenons à vous informer comment nous traitons vos données personnelles lorsque vous utilisez cette application ou visitez le site web.

Préambule

Cette politique de confidentialité s'applique au site web www.cible-app.com et aux applications CIBLE, CIBLE PRO et CIBLE SCAN
La présente politique de confidentialité a pour but d'exposer aux utilisateurs :
-La manière dont sont collectées et traitées leurs données à caractère personnel
-Les droits des utilisateurs concernant leurs données
-A qui ces données sont transmises
-La politique du site en matière de fichiers "cookies"
Cette politique de confidentialité complète les mentions légales et les Conditions générales d'utilisation que les utilisateurs peuvent consulter à l'adresse ci-après : www.cible-app.com/cgu 

1.Collecte de l’information

Nous recueillons des informations lorsque vous vous inscrivez sur notre application, lorsque vous vous connectez à votre compte, faites un achat, participez à un jeu de tirage au sort ou tout autre type de jeu ou lorsque vous vous déconnectez. Les informations recueillies incluent votre nom, votre adresse e-mail, numéro de téléphone, votre adresse, votre genre, votre date de naissance pour les comptes particuliers et incluent la raison sociale, le numéro RCCM, le NIF, la date de création de l’entreprise, la personne physique responsable de l’entreprise et ses coordonnées, et des documents justificatifs. En outre, nous recevons et enregistrons automatiquement des informations à partir de votre ordinateur/téléphone et navigateur, y compris votre adresse IP et les pages que vous demandez.
Le responsable du traitement conservera dans les systèmes informatiques de l’application et dans des conditions raisonnables de sécurité l'ensemble des données collectées pour une durée de 5 ans renouvelable automatiquement si vous ne manifestez votre intérêt à ce que vos données ne soient pas conservées. 

2. Utilisation des informations

Toutes les informations que nous recueillons auprès de vous peuvent être utilisées pour :
- Personnaliser votre expérience utilisateur et répondre à vos besoins individuels
- Améliorer notre application et notre site web pour continuellement s’adapter à vos attentes
- Améliorer le service client et vos besoins de prise en charge
- Vous contacter par e-mail ou sms pour passer un message dans l’intérêt des deux parties
- Administrer un jeu, une promotion, ou une enquête de satisfaction
- Vous notifier de ce qui vous concerne ou peut vous intéresser
- Régler les litiges entre acteurs utilisant l’application
- Assurer la modération sur l’application
- Vérifier la véracité et la conformité des comptes utilisateurs sur l’application
- Permettre aux professionnels qui offrent des services et vendent des articles de proposer le meilleur service et les meilleurs produits aux particuliers

3. Confidentialité du commerce en ligne

Nous sommes les seuls propriétaires des informations recueillies sur ce site. Vos informations personnelles ne seront pas vendues, échangées, transférées, ou données à une autre société pour n’importe quelle raison, sans votre consentement, en dehors de ce qui est nécessaire pour répondre à une demande et / ou une transaction, comme par exemple pour expédier une commande.
Les données bancaires ou mobiles money ne sont pas traitées par nous directement ; mais par notre partenaire CinetPay dont nous utilisons l’API.

4. Divulgation à des tiers

Nous ne vendons, n’échangeons et ne transférons pas vos informations personnelles identifiables à des tiers. Cela ne comprend pas les tierce parties de confiance qui nous aident à exploiter notre site Web ou à mener nos affaires, tant que ces parties conviennent de garder ces informations confidentielles.
Nous pensons qu’il est nécessaire de partager des informations afin d’enquêter, de prévenir ou de prendre des mesures concernant des activités illégales, fraudes présumées, situations impliquant des menaces potentielles à la sécurité physique de toute personne, violations de nos conditions d’utilisation, ou quand la loi nous y contraint.
Les informations non-privées, cependant, peuvent être fournies à d’autres parties pour le marketing, la publicité, ou d’autres utilisations.

5. Protection des informations

Nous mettons en œuvre une variété de mesures de sécurité pour préserver la sécurité de vos informations personnelles. Nous utilisons un cryptage à la pointe de la technologie pour protéger les informations sensibles transmises en ligne. Nous protégeons également vos informations hors ligne. Seuls les employés qui ont besoin d’effectuer un travail spécifique (par exemple, la facturation ou le service à la clientèle) ont accès aux informations personnelles identifiables. Les ordinateurs et serveurs utilisés pour stocker des informations personnelles identifiables sont conservés dans un environnement sécurisé.
L’application web www.cible-app.com  est hébergée par : PlanetHoster, dont le siège est situé à l'adresse ci-après : PlanetHoster 4416 Louis-B.-Mayer Laval, Québec Canada H7P 0G1. L'hébergeur peut être contacté au numéro de téléphone suivant : CA: +1 855 774-4678 / FR: +33 1 76 60 41 43. Les données collectées et traitées par le site sont hébergées entre les Datalefts dans les pays suivant(s) : Canada, France. L’application mobile est hébergée sur Play store et App Store.

Est-ce que nous utilisons des cookies ?
Nos cookies améliorent l’accès à notre site et identifient les visiteurs réguliers. En outre, nos cookies améliorent l’expérience d’utilisateur grâce au suivi et au ciblage de ses intérêts. Cependant, cette utilisation des cookies n’est en aucune façon liée à des informations personnelles identifiables sur notre site.
6. Se désabonner / Supprimer son compte

Nous utilisons l’adresse e-mail que vous fournissez pour vous envoyer des informations et mises à jour relatives à votre commande, des nouvelles de l’entreprise de façon occasionnelle, des informations sur des produits liés, etc. Si à n’importe quel moment vous souhaitez-vous désinscrire et ne plus recevoir d’e-mails, des instructions de désabonnement détaillées sont incluses en bas de chaque e-mail.
Vous pouvez aussi à tout moment supprimer votre compte depuis votre espace utilisateur. La suppression des comptes prend effet à l’instant et ne nous donne plus accès à vos informations. Vos données sont donc supprimées de la base de données également.

7. Consentement
En utilisant notre site web et notre application, vous consentez à notre politique de confidentialité.

8. Conditions de modification de la politique de confidentialité
La présente politique de confidentialité peut être consultée à tout moment à l'adresse ci-après indiquée : https://cible-app.com/confidentialité .
L'éditeur du site se réserve le droit de la modifier afin de garantir sa conformité avec le droit en vigueur. Par conséquent, l'utilisateur est invité à venir consulter régulièrement cette politique de confidentialité afin de se tenir informé des derniers changements qui lui seront apportés.
Toutefois, en cas de modification substantielle de cette politique, l'utilisateur en sera informé de la manière suivante : par mail à l'adresse communiquée par l'utilisateur.
Il est porté à la connaissance de l'utilisateur que la dernière mise à jour de la présente politique de confidentialité est intervenue le 13 Avril 2023. 
""",
  textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
  
                            fontSize: AppText.p5(context),
  
                            fontWeight: FontWeight.w500,
  
                            color: appColorProvider.black),
  
                      ),
                  SizedBox(height: Device.getDiviseScreenWidth(context, 20)),
                Text(
  
                        """CONDITIONS GENERALES D’UTILISATION DE CIBLE 
Article 1 : Objet
Les présentes Conditions Générales d’Utilisation encadrent juridiquement l’utilisation des services du site web www.cible-app.com et des applications mobiles CIBLE, CIBLE PRO et CIBLE SCAN (ci-après dénommé « le site »).
Constituant le contrat entre la société DIGITAL INNOV GROUP, l’Utilisateur, l’accès au site doit être précédé de l’acceptation de ces CGU. L’accès à cette plateforme signifie l’acceptation des présentes CGU.
Article 2 : Mentions légales
L’édition de la plateforme CIBLE est assurée par la société DIGITAL INNOV GROUP SARL inscrite au RCCM sous le numéro TG-LFW-01-2022-B12-00493, avec un capital de 1 000 000 FCFA, dont le siège social est localisé au boulevard de la CEDEAO, Agoè Légbassito, Lomé, TOGO
L’hébergeur du site www.cible-app.com  est la société PlanetHoster, dont le siège est situé à l'adresse ci-après : PlanetHoster 4416 Louis-B.-Mayer Laval, Québec Canada H7P 0G1. L'hébergeur peut être contacté au numéro de téléphone suivant : CA: +1 855 774-4678 / FR: +33 1 76 60 41 43. Les applications mobiles sont hébergées sur Play store et App Store.
Article 3 : Accès au site
Le site CIBLE permet d’accéder gratuitement aux services suivants :
•	Annonce des événements
•	Vente de tickets événementiels 
•	Vente de gadgets événementiels
•	Enquêtes de satisfaction
Le site est accessible gratuitement depuis n’importe où, par tout utilisateur disposant d’un accès à Internet. Tous les frais nécessaires pour l’accès aux services (matériel informatique, connexion Internet…) sont à la charge de l’utilisateur.
Pour des raisons de maintenance ou autres, l’accès au site peut être interrompu ou suspendu par l’éditeur sans préavis ni justification.
Article 4 : Collecte des données
Pour la création du compte de l’Utilisateur, la collecte des informations au moment de l’inscription sur le site est nécessaire et obligatoire. Conformément à la loi n°78-17 du 6 janvier relative à l’informatique, aux fichiers et aux libertés, la collecte et le traitement d’informations personnelles s’effectuent dans le respect de la vie privée.
Suivant la loi Informatique et Libertés en date du 6 janvier 1978, articles 39 et 40, l’Utilisateur dispose du droit d’accéder, de rectifier, de supprimer et d’opposer ses données personnelles. L’exercice de ce droit s’effectue par :
•	Le formulaire de contact ;
•	Son espace client.
Article 5 : Propriété intellectuelle
Les marques, logos ainsi que les contenus du site CIBLE (illustrations graphiques, textes…) sont protégés par le Code de la propriété intellectuelle et par le droit d’auteur.
La reproduction et la copie des contenus par l’Utilisateur requièrent une autorisation préalable du site. Dans ce cas, toute utilisation à des usages commerciaux ou à des fins publicitaires est proscrite.
Article 6 : Responsabilité
Bien que les informations publiées sur le site soient réputées fiables, le site se réserve la faculté d’une non-garantie de la fiabilité des sources.
Les informations diffusées sur le site CIBLE sont présentées à titre purement informatif et sont sans valeur contractuelle. En dépit des mises à jour régulières, la responsabilité du site ne peut être engagée en cas de modification des dispositions administratives et juridiques apparaissant après la publication. Il en est de même pour l’utilisation et l’interprétation des informations communiquées sur la plateforme.
Le site décline toute responsabilité concernant les éventuels virus pouvant infecter le matériel informatique de l’Utilisateur après l’utilisation ou l’accès à ce site.
Le site ne peut être tenu pour responsable en cas de force majeure ou du fait imprévisible et insurmontable d’un tiers.
La garantie totale de la sécurité et la confidentialité des données n’est pas assurée par le site. Cependant, le site s’engage à mettre en œuvre toutes les méthodes requises pour le faire au mieux.
Article 7 : Liens hypertextes
Le site peut être constitué de liens hypertextes. En cliquant sur ces derniers, l’Utilisateur sortira de la plateforme. Cette dernière n’a pas de contrôle et ne peut pas être tenue responsable du contenu des pages web relatives à ces liens.
Article 8 : Cookies
Lors des visites sur le site, l’installation automatique d’un cookie sur le logiciel de navigation de l’Utilisateur peut survenir.
Les cookies correspondent à de petits fichiers déposés temporairement sur le disque dur de l’ordinateur de l’Utilisateur. Ces cookies sont nécessaires pour assurer l’accessibilité et la navigation sur le site. Ces fichiers ne comportent pas d’informations personnelles et ne peuvent pas être utilisés pour l’identification d’une personne.
L’information présente dans les cookies est utilisée pour améliorer les performances de navigation sur le site www.cible-app.com 
En naviguant sur le site, l’Utilisateur accepte les cookies. Leur désactivation peut s’effectuer via les paramètres du logiciel de navigation.
Article 9 : Publication par l’Utilisateur
Le site CIBLE permet aux membres de publier des événements et de faire des commentaires en lien avec les articles publiés sur le blog du site.
Dans ses publications d’événements, l’organisateur est tenu de respecter les règles de la Netiquette ainsi que les règles de droit en vigueur.
Le site dispose du droit d’exercer une modération à priori sur les publications d’événements et peut refuser leur mise en ligne en envoyant une justification à l’auteur de la publication. Nous nous réservons le droit de corriger les fautes qui seront dans les publications sans altérer le sens du message véhiculé et sans notification à l’auteur de la publication.
Le membre garde l’intégralité de ses droits de propriété intellectuelle. Toutefois, toute publication sur le site implique la délégation du droit non exclusif et gratuit à la société détentrice du site de représenter, reproduire, modifier, adapter, distribuer et diffuser la publication n’importe où et sur n’importe quel support pour la durée de la propriété intellectuelle. Cela peut se faire directement ou par l’intermédiaire d’un tiers autorisé. Cela concerne notamment le droit d’utilisation de la publication sur le web et sur les réseaux de téléphonie mobile.
À chaque utilisation, l’éditeur s’engage à mentionner le nom du membre à proximité de la publication ; c’est-à-dire le nom de l’organisateur, l’adresse et les contacts utiles afin de donner la paternité au contenu et de permettre aux internautes de pouvoir entrer en contact avec lui.
L’Organisateur est tenu responsable de tout contenu qu’il met en ligne. L’Organisateur s’engage à ne pas publier de contenus susceptibles de porter atteinte aux intérêts de tierces personnes. Toutes procédures engagées en justice par un tiers lésé à l’encontre du site devront être prises en charge par l’Organisateur s’il s’agit d’un contenu publié par ce dernier. Cependant pour des contenus relevant de la société détentrice du site, la société assumera l’entière responsabilité.
Article 10 : Promo
Nous faisons de temps en temps des publicités sur les réseaux sociaux (Facebook, LinkedIn, Tik Tok, Instagram, YouTube, Google Ads) pour avoir plus d’utilisateurs. Il est donc souvent proposé aux internautes de s’inscrire à la plateforme entre une date 1 et une date 2 pour profiter d’une réduction sur leur prochain ticket 30 jours après leur inscription (condition valable pour tout argent gagné peu importe le type de promotion). 
Notre entreprise couvre les frais de sponsoring de ces publicités mais les réductions appliquées aux acheteurs de tickets seront supportées par les organisateurs en tant que Co-bénéficiaires des retombées de ces publicités étant donné que plus nous avons d’utilisateurs, plus vite ils pourront vendre leurs tickets à chaque événement grâce au système de notifications.
Article 11 : Jeux de recommandation
Chaque utilisateur gagne de l’argent qu’on reverse sur son portefeuille lorsqu’il participe à un programme de recommandations et qu’il sort vainqueur. Cet argent gagné est utilisable 15 jours après le gain. Si avant les 15 jours, des utilisateurs auxquels il aurait recommandé l’application la désinstallent, le nombre de personnes recommandées diminue. Et si le nombre est en dessous du cota pour gagner, ce dernier perd automatiquement son gain.
Un utilisateur qui a été recommandé une fois et qui désinstalle l’application après ne peut s’inscrire de nouveau par recommandation.
Article 12 : Notifications
Nous permettons à chaque utilisateur de paramétrer les événements pour lesquels il aimerait être informé lors de la publication. Une fois ces paramètres choisis, toute publication correspondant à son paramétrage lui est notifié. Il peut changer de paramétrage à tout moment. 
Au cas où il n’aurait choisi aucun paramétrage, nous nous réservons le droit de lui notifier les publications que nous jugeons intéressant pour lui suivant la technologie push et il pourra consulter cette notification en cliquant sur la cloche dans depuis son application mobile.
Article 13 : Commission & frais de transaction 
Pour continuer à développer les fonctionnalités de l’application et assurer les services offerts via la plateforme web et l’application mobile, nous prélevons des commissions sur chaque ticket vendu. 
Nous prélevons 5% de commission sur chaque ticket vendu.
Des frais de transaction sont prélevés à l’acheteur au moment de l’achat du ticket. L’organisateur nous reverse donc juste notre commission et ne supporte pas par conséquent les frais de transaction.
Article 14 : Versement
Le jour J de l’événement, nous nous assurons que l’événement a effectivement eu lieu. 48H après chaque événement, l’Organisateur à l’argent de ses tickets vendus sur son compte bancaire ou son compte mobile money renseigné. Il se peut que ça prenne jusqu’à 72h pour des raisons techniques. AU-DELA de ce délais, l’Organisateur pourra émettre une réclamation en écrivant à l’adresse suivante : reclame@cible-app.com 
Article 15 : Annulation & Remboursement
L’Organisateur peut annuler un événement qu’il a publié à tout moment. Seulement, pour chaque événement annulé, nous remboursons automatiquement chaque acheteur en reversant leur argent sur leur portefeuille CIBLE. Ils ne pourront pas retirer l’argent en question mais pourront acheter d’autres tickets avec cet argent remboursé.


Article 16 : Modification, Report et Remboursement
L’organisateur peut modifier à tout moment la date, l’horaire ou encore le lieu de l’événement à tout moment. Une notification sera automatiquement envoyée aux participants et ces derniers pourront annuler leurs achats si les modifications apporter ne leur conviennent pas. Le coût du ticket sera remboursé à chaque participant. Cependant les frais de transaction ne seront pas remboursés. L’argent remboursé sera sur leurs portefeuilles et ils pourront l’utiliser pour acheter un autre ticket.
Article 17 : Rétraction du participant à un événement
Tout participant ayant acheté son ticket via l’application mobile ne pourra pas annuler son achat si l’événement n’a pas été reporté. C’est seulement en cas de report que le participant a le droit d’annuler son achat.

Article 18 : Complémentarité Mobile et Web
L’application est la version complète du projet et l’application web est une version simplifiée de l’application mobile. Par conséquent, toutes les fonctionnalités présentes au niveau de l’application mobile comme l’annulation, le remboursement, les recommandations, le portefeuille électronique (…) ne sont pas sur la version web. Ce qui fait que les acheteurs de tickets ne pourront être remboursé en cas d’annulation de l’événement mais pourront être notifiés par mail. 
Nous recommandons aux acheteurs de faire usage de l’application mobile pour l’achat de leurs tickets afin de jouir de toutes les fonctionnalités développées par la société pour le confort et le bonheur des utilisateurs. En cas d’utilisation de la version web pour acheter son ticket, la société se décharge de toutes les limites que celle-ci comporte.
Article 19 : Solde du portefeuille & Suppression du compte
Avant de pouvoir acheter un ticket sur l’application mobile, il faut disposer de l’argent sur son portefeuille. Chaque utilisateur a la possibilité de recharger son portefeuille depuis un compte mobile money ou compte bancaire. Tout remboursement se fait sur le portefeuille de l’utilisateur et non sur son compte mobile money ou compte bancaire.
En cas de suppression de son compte, le solde disponible ne peut être remboursé et le portefeuille est initialisé à 0. En cas de création d’un nouveau compte, l’utilisateur ne peut récupérer le solde de son ancien compte. 
Mais au cas où le compte ne serait pas supprimé, mais que l’utilisateur aurait installé juste l’application sur un autre téléphone, il aura toujours son solde sur son portefeuille. 
Toute somme créditée sur le portefeuille de l’utilisateur par une promotion ou le gain d’un jeu lancé par la société ne peut être utilisée si l’utilisateur désinstalle l’application dans les 30 jours qui suivent le dépôt sur son portefeuille. Le solde du portefeuille sera remis à 0 dans ce cas.
Article 20 : Durée du contrat
Le présent contrat est valable pour une durée indéterminée. Le début de l’utilisation des services du site marque l’application du contrat à l’égard de l’Utilisateur. 

Article 21 : Droit applicable et juridiction compétente
Le présent contrat est soumis à la législation de l’OHADA. L’absence de résolution à l’amiable des cas de litige entre les parties implique le recours aux tribunaux compétents de ladite instance pour régler le contentieux.

Toutefois, en cas de modification substantielle de cette politique, l'utilisateur en sera informé de la manière suivante : par mail à l'adresse communiquée par l'utilisateur.
Il est porté à la connaissance de l'utilisateur que la dernière mise à jour de la présente politique de confidentialité est intervenue le 13 Avril 2023. 
""",
  textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
  
                            fontSize: AppText.p5(context),
  
                            fontWeight: FontWeight.w500,
  
                            color: appColorProvider.black),
  
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
