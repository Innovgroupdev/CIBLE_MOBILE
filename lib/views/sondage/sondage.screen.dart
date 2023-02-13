import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../database/notificationDBcontroller.dart';
import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../providers/appColorsProvider.dart';
import '../../providers/appManagerProvider.dart';
import '../../providers/defaultUser.dart';
import '../../widgets/formWidget.dart';
import '../../widgets/photoprofil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

import '../../widgets/raisedButtonDecor.dart';
import '../../widgets/sondageCard.dart';

class SondageScreen extends StatefulWidget {
  SondageScreen({Key? key}) : super(key: key);

  @override
  State<SondageScreen> createState() => _SondageScreenState();
}

class _SondageScreenState extends State<SondageScreen> {
  int levelNumber = 0;
  int questionLenght = 0;
  void upLevelNumber() {
    setState(() {
      levelNumber = levelNumber + 1;
    });
  }

  void downLevelNumber() {
    setState(() {
      levelNumber = levelNumber - 1;
    });
  }

    void changeListLenght() {
    setState(() {
      if(questionLenght == 6){
       questionLenght = questionLenght - 1;
      }else if(questionLenght == 5){
        questionLenght = questionLenght + 1;
      }
    });
  }

  List questions = [
    {
      'question':
          'Quelle note donnez-vous à l’organisateur de l’évènement ? (Choix unique)',
      'responses': ['*', '**', '***', '****', '*****']
    },
    {
      'question':
          'Qu’est ce qui résume le mieux votre sentiment par rapport à l’événement ?',
      'responses': [
        'Je regrette d’avoir participé',
        'Je recommanderai si c’était à refaire',
        'Je ne suis pas impressionné'
      ]
    },
    {
      'question':
          'Comment trouvez-vous le rapport qualité/prix de l’événement ?',
      'responses': ['Pas cher', 'Abordable', 'Assez cher', 'Très cher']
    },
    {
      'question': 'Qu’est ce qui a motivé votre décision d’achat du ticket ?',
      'responses': [
        'Les acteurs de l’événement',
        'Le thème de l’événement',
        'Proposition d’une connaissance (ami.e)',
        'Proposition d’une connaissance (conjoint.e)',
        'L’influence des parents/enfants',
        'L’influence d’un mentor/professeur',
        'S’évader/ s’amuser / se retrouver entre amis',
        'Apprendre / se cultiver / Découvrir',
        'Rencontrer de nouvelles personnes.'
      ]
    },
    {
      'question':
          'Qu’avez-vous aimé au cours de cet évènement ? (Choix multiple)',
      'responses': [
        {
          'response': 'Sonorisation',
          'isSelected': false,
        },
        {
          'response': 'Ambiance du concert',
          'isSelected': false,
        },
        {
          'response': 'Luminosité et jeux de lumière',
          'isSelected': false,
        },
        {
          'response': 'Gestion des entrées',
          'isSelected': false,
        },
        {
          'response': 'Gestion des sorties',
          'isSelected': false,
        },
        {
          'response': 'Le confort des sièges et le cadre',
          'isSelected': false,
        },
        {
          'response': 'Service de premier secours',
          'isSelected': false,
        },
        {
          'response': 'Le service d’accueil',
          'isSelected': false,
        },
        {
          'response': 'La prestation des artistes',
          'isSelected': false,
        },
        {
          'response': 'La prestation du modérateur',
          'isSelected': false,
        },
        {
          'response': 'Le service de stationnement (Parking)',
          'isSelected': false,
        },
        {
          'response': 'La gestion du temps',
          'isSelected': false,
        },
        {
          'response': 'La plage horaire allouée à l’évènement',
          'isSelected': false,
        },
        {
          'response': 'Le niveau de sécurité',
          'isSelected': false,
        },
        {
          'response': 'La communication autour de l’événement',
          'isSelected': false,
        },
      ]
    },
    {
      'question':
          'Qu’est-ce que vous n’avez pas aimé au cours de cet évènement ? (Choix multiple)',
      'responses': [
        {
          'response': 'Sonorisation',
          'isSelected': false,
        },
        {
          'response': 'Ambiance du concert',
          'isSelected': false,
        },
        {
          'response': 'Luminosité et jeux de lumière',
          'isSelected': false,
        },
        {
          'response': 'Gestion des entrées',
          'isSelected': false,
        },
        {
          'response': 'Gestion des sorties',
          'isSelected': false,
        },
        {
          'response': 'Le confort des sièges et le cadre',
          'isSelected': false,
        },
        {
          'response': 'Service de premier secours',
          'isSelected': false,
        },
        {
          'response': 'Le service d’accueil',
          'isSelected': false,
        },
        {
          'response': 'La prestation des artistes',
          'isSelected': false,
        },
        {
          'response': 'La prestation du modérateur',
          'isSelected': false,
        },
        {
          'response': 'Le service de stationnement (Parking)',
          'isSelected': false,
        },
        {
          'response': 'La gestion du temps',
          'isSelected': false,
        },
        {
          'response': 'La plage horaire allouée à l’évènement',
          'isSelected': false,
        },
        {
          'response': 'Le niveau de sécurité',
          'isSelected': false,
        },
        {
          'response': 'La communication autour de l’événement',
          'isSelected': false,
        },
      ]
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
      questionLenght = questions.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor:
              Provider.of<AppColorProvider>(context, listen: false).white,
          title: Text(
            "SONDAGE",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: AppText.p1(context),
                fontWeight: FontWeight.w800,
                color: Provider.of<AppColorProvider>(context, listen: false)
                    .white),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: appColorProvider.white,
              child: Column(
                children: [
                  const SizedBox(
                height: 10,
              ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: LinearProgressIndicator(
                        value: levelNumber / 6,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '$levelNumber/6',
                        style: TextStyle(
                          color: appColorProvider.black54,
                          fontSize: AppText.p2(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Les résultats de ce sondage sont destinés à l’organisateur pour le permettre d’évaluer son organisation afin de savoir ce qu’il faudrait améliorer les prochaines fois pour offrir aux participants le meilleur de chaque événement. Vos informations personnelles ne seront pas envoyées à l’organisateur',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: appColorProvider.black54,
                  fontSize: AppText.p2(context),
                ),
              ),
              Text(
                "Questions",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: AppText.p1(context),
                    fontWeight: FontWeight.w800,
                    color: Provider.of<AppColorProvider>(context, listen: false)
                        .black54),
              ),
              SizedBox(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: questionLenght,
                    itemBuilder: (context, index) {
                      return SondageCard(
                        questionNum: '0${index + 1}',
                        question: questions[index]['question'],
                        reponses: questions[index]['responses'],
                        //  groupValue: groupValue,
                        upLevelNumber: () {
                          upLevelNumber();
                        },
                        downLevelNumber: () {
                          downLevelNumber();
                        },
                        changeListLenght: () {
                          changeListLenght();
                        },
                      );
                    }),
              ),
              levelNumber != 6?
              const SizedBox():
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: RaisedButtonDecor(
                  onPressed: () {},
                  elevation: 3,
                  color: AppColor.primaryColor,
                  shape: BorderRadius.circular(10),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Envoyer",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: AppText.p2(context)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      );
    });
  }
}
