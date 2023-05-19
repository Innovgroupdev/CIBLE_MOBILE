import 'dart:convert';

import 'package:cible/views/sondage/sondage.controller.dart';
import 'package:flutter/material.dart';

import '../../constants/api.dart';
import '../../database/notificationDBcontroller.dart';
import '../../database/userDBcontroller.dart';
import '../../helpers/colorsHelper.dart';
import '../../helpers/screenSizeHelper.dart';
import '../../helpers/textHelper.dart';
import '../../models/Event.dart';
import '../../models/question.dart';
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
  SondageScreen({required this.data, Key? key}) : super(key: key);
  Event1 data;

  @override
  State<SondageScreen> createState() => _SondageScreenState();
}

class _SondageScreenState extends State<SondageScreen> {
  int levelNumber = 0;
  int questionLenght = 0;
  List<Question> questions = [];
  List responseDataList= [];
  bool isLoading = false;
  bool isUpSpecial = false;

   @override
  void initState() {
    super.initState();
    getQuestionsFromAPI().then((value) {
      questions = value;
      questionLenght = questions.length;
    });
  }
  void upLevelNumber(response) {
    setState(() {
      levelNumber = levelNumber + 1;
      //responseDataList.add(response);
    });
      //print('tandammmmmmmmmm'+responseDataList.toString());
  }

  void downLevelNumber(response) {
    setState(() {
      levelNumber = levelNumber - 1;
      //.remove(response);
    });
     // print('tandammmmmmmmmm'+responseDataList.toString());
  }

    void changeListLenght() {
      print('errrrrrrrrrr1'+questionLenght.toString());
    setState(() {
      if(questionLenght == 6){
       questionLenght = questionLenght - 1;
      }else if(questionLenght == 5){
        questionLenght = questionLenght + 1;
      }
    });
    print('errrrrrrrrrr2'+questionLenght.toString());
  }

  addResponseData(response) {
    
    setState(() {
      responseDataList.add(response);
    });
    print('tandammmmmmmmmm1'+responseDataList.toString());
  }

  void updateState(responseToUpdate,questionNum) {
    bool notExist = false;
    List responsesTp = [];
    
    setState(() {
    if(questionNum == 5){
      
      questions[5].responses.forEach((res) {
if(responseToUpdate.response == res.response){
  
  questions[5].responses.remove(res);
   print('wxcvbbbbbbbbbb1' +questions[5].responses.length.toString());
  notExist = true;
}

     });
     if(!notExist){
questions[5].responses.add(responseToUpdate);
 print('wxcvbbbbbbbbbb1' +questions[5].responses.length.toString());
     }
    }else if(questionNum == 6){
      
      questions[4].responses.forEach((res) {
if(responseToUpdate.response == res.response){
  questions[4].responses.remove(res);
  notExist = true;
  
      print('wxcvbbbbbbbbbb2' +questions[4].responses.length.toString());
      
   print('wxcvbbbbbbbbbb1' +questions[5].responses.length.toString());
   questions[4].responses.forEach((rep) {
      responsesTp.add(rep.response); 
     });
     if(responsesTp.contains("J'ai tout aimé") 
          && responsesTp.contains("Je n'ai rien aimé")
          && responsesTp.length == 2){
            levelNumber = levelNumber + 1;
            isUpSpecial = true;
          }else if(isUpSpecial ==true){
            isUpSpecial = false;
            levelNumber = levelNumber - 1;
          }
}
     });
     
            print('vbnnnnnnnnnnnnnn'+questions[4].responses.length.toString());
     if(!notExist){
questions[4].responses.add(responseToUpdate);
      print('wxcvbbbbbbbbbb2' +questions[4].responses.length.toString());
   print('wxcvbbbbbbbbbb1' +questions[5].responses.length.toString());
questions[4].responses.forEach((rep) {
      responsesTp.add(rep.response); 
     });
     if(responsesTp.contains("J'ai tout aimé") 
          && responsesTp.contains("Je n'ai rien aimé")
          && responsesTp.length == 2){
            levelNumber = levelNumber + 1;
            isUpSpecial = true;
          }else if(isUpSpecial ==true){
            isUpSpecial = false;
            levelNumber = levelNumber - 1;
          }
     }
     
     
     
    }
    });
  }

  updateResponseData(response,questionId,questionNumber) {
    var oldResponseId;
    print('boooooob'+responseDataList.toString());
    setState(() {
      if(questionNumber<5){
    print('questionIdfffffff'+questionNumber.toString());
        responseDataList.removeWhere((response) {
        return response['question_id'] == questionId;
      });
      responseDataList.add(response);
      }
      else{
        if(responseDataList.isEmpty){
            responseDataList.add(response);
           print('bbbbbbbbbbb1'+responseDataList.toString());
        }else{
        responseDataList.removeWhere((response) {
          for(var i in responseDataList){
            if(response['question_id'] == questionId){
              oldResponseId = response['answer_ids'];
            }
          }
        return response['question_id'] == questionId;
      });
     // print('bbbbbbbbbbb'+(oldResponseId+response['answer_ids']).toString());
      print('bbbbbbbbbbbpreuve'+response['answer_ids'].toString());
      if(oldResponseId==null || response['rep'] == "J'ai tout aimé" || response['rep'] == "Je n'ai rien aimé"){
        print("rfffffffffff"+response['answer_ids'].toString());
        responseDataList.add({"question_id": questionId,"answer_ids": ([]+response['answer_ids'])});
      }else{

        responseDataList.add({"question_id": questionId,"answer_ids": (oldResponseId+response['answer_ids'])});
      }
            

        }
      }
    });
    print('tandammmmmmmmmm2'+responseDataList.toString());
  }

    updateRemoveResponseData(response,questionId,questionNumber) {
    var listAnswers;
    
    setState(() {
      if(response['rep'] == "J'ai tout aimé" || response['rep'] == "Je n'ai rien aimé"){
        responseDataList.removeWhere((element) => element['question_id'] == questionId);
      }else{
         for(var i in responseDataList){
        if(i['question_id'] == questionId){
          print('pfffffff1');
          listAnswers = i['answer_ids'];
          responseDataList.removeWhere((element) => element['question_id'] == questionId);
          break;
        }
      };
        listAnswers.removeWhere((response1) {
        return response['answer_ids'][0] == response1;
      });
      responseDataList.add({
        'question_id':questionId,
        'answer_ids':listAnswers
      });
      }
     
      
      print('responseDataList'+responseDataList.toString());
    });
  }

      likeAllResponseData(listAnswers,questionId) {
    setState(() {
      for(var i in responseDataList){
        if(i['question_id'] == questionId){
          responseDataList.removeWhere((element) => element['question_id'] == questionId);
          break;
        }
      };
      responseDataList.add({
        'question_id':questionId,
        'answer_ids':listAnswers
      });
    });
  }
       dislikeAllResponseData(questionId) {
        List listAnswers = [];
    questions[5].responses.forEach((element) {
      listAnswers.add(element.id);
    });
    print('fuckkkkkkkkkk1'+listAnswers.toString());
    setState(() {
      if(responseDataList != []){
for(var i in responseDataList){
        if(i['question_id'] == 6){
          responseDataList.removeWhere((element) => element['question_id'] == 6);
          break;
        }
      };
      }
      
      responseDataList.add({
        'question_id':6,
        'answer_ids':listAnswers
      });
      
    print('fuckkkkkkkkkk2'+responseDataList.toString());
    });
  }

    Future<dynamic> getQuestionsFromAPI() async {
      
      print("sssssssssssss ${widget.data.id}");
    var response = await http.get(
      Uri.parse('$baseApiUrl/questions/events/${widget.data.id}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        questions = getQuestionsFromMap(jsonDecode(response.body)['data'] as List);
      });
      return questions;
    }
  }

  getQuestionsFromMap(List questionsListFromAPI) {
    final List<Question> tagObjs = [];
    for (var element in questionsListFromAPI) {
      var question = Question.fromMap(element);
      if (question != null) {
        tagObjs.add(question);
      }
    }
    return tagObjs;
  }

  List questions1 = [
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
        body: questions.isEmpty
        ? Center(child: CircularProgressIndicator())
        :
        Container(
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
                        updateState: (responseToUpdate,questionNum){updateState(responseToUpdate,questionNum);},
                        questionNum: '0${index + 1}',
                        question: questions[index].question,
                        reponses: questions[index].responses,
                        questionId:questions[index].id,
                        //  groupValue: groupValue,
                        upLevelNumber: (response) {
                          upLevelNumber(response);
                        },
                        downLevelNumber: (response) {
                          downLevelNumber(response);
                        },
                        changeListLenght: () {
                          changeListLenght();
                        },
                        addResponseData: (response){
                          addResponseData(response);
                          },
                        updateResponseData: (response,questionId,questionNumber){
                          updateResponseData(response,questionId,questionNumber);
                          },
                          updateRemoveResponseData: (response,questionId,questionNumber){
                          updateRemoveResponseData(response,questionId,questionNumber);
                          },
                          likeAllResponseData: (listAnswers, questionId) {
                            likeAllResponseData(listAnswers, questionId);
                          },
                          dislikeAllResponseData: (questionId) {
                            dislikeAllResponseData(questionId);
                          },
                      );
                    }),
              ),
              levelNumber != 6?
              const SizedBox():
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: RaisedButtonDecor(
                  onPressed: 
                  isLoading?
                  (){}:
                  () async{
                   isLoading = await sendSondageResponse(context,responseDataList,widget.data.id);
                 // isLoading ? 
                  // Navigator.pushNamed(context, "/evenement"):null;
                  },
                  elevation: 3,
                  color: AppColor.primaryColor,
                  shape: BorderRadius.circular(10),
                  padding: const EdgeInsets.all(15),
                  child: 
                  isLoading ?
                  Container(height: 20,width: 20,child: CircularProgressIndicator(),):
                  Text(
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
