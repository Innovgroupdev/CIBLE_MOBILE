import 'dart:ui';

import 'package:cible/helpers/colorsHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/raisedButtonDecor.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/textHelper.dart';

typedef void IntCallback();

class SondageCard extends StatefulWidget {
  SondageCard(
      {Key? key,
      required this.questionId,
      required this.questionNum,
      required this.question,
      required this.reponses,
      required this.upLevelNumber,
      required this.downLevelNumber,
      required this.changeListLenght,
      required this.addResponseData,
      required this.updateResponseData,
      required this.updateRemoveResponseData,
      required this.likeAllResponseData,
      required this.dislikeAllResponseData
      })
      : super(key: key);
  int questionId;
  String questionNum;
  String question;
  List<dynamic> reponses;
  Function(dynamic) upLevelNumber;
  Function(dynamic) downLevelNumber;
  final IntCallback changeListLenght;
  Function(dynamic) addResponseData;
  Function(dynamic,dynamic) updateResponseData;
  Function(dynamic,dynamic) updateRemoveResponseData;
  Function(dynamic,dynamic) likeAllResponseData;
  Function(dynamic) dislikeAllResponseData;

  @override
  State<SondageCard> createState() => _SondageCardState();
}




class _SondageCardState extends State<SondageCard> {
  String? response;
  bool isExpand = true;
  bool isSelected = false;
  bool checkAll = false;
  bool unCheckAll = false;
  dynamic groupValue = 'xxx';
  List questionFiveTable = [];
  List questionSixTable = [];


  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return 
      Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: ExpansionPanelList(
              elevation: 0,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isExpand = !isExpand;
                });
              },
              children: [
                ExpansionPanel(
                    isExpanded: isExpand,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: appColorProvider.primary),
                            child: Center(
                              child: Text(
                                widget.questionNum,
                                style: TextStyle(
                                    color: appColorProvider.white,
                                    fontSize: AppText.p1(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.question,
                              style: TextStyle(
                                  color: appColorProvider.black54,
                                  fontSize: AppText.p1(context),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                    body: SizedBox(
                      child: Column(
                        children: [
                          for (var rep in widget.reponses) ...[
                            int.parse(widget.questionNum) < 5
                                ? RadioListTile<dynamic>(
                                    value: rep.response,
                                    groupValue: response,
                                    onChanged: ((value) {
                                      setState(() {
                                         if (groupValue == 'xxx') {
                                        groupValue = value;
                                              widget.upLevelNumber(
                                                {
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                },);
                                                widget.addResponseData(
                                                {
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                },);
                                              //widget.updateResponseData(rep.id);
                                        }else{
                                          widget.updateResponseData(
                                                {
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                },widget.questionId);
                                        }
                                        response = value.toString();
                                      });
                                       
                                        
                                    }),
                                    title: Text(
                                      rep.response,
                                      style: TextStyle(
                                        color: appColorProvider.black54,
                                        fontSize: AppText.p2(context),
                                        //  fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      ListTile(
                                        leading: Checkbox(
                                          value: rep.isSelected,
                                          onChanged: ((value) {
                                            setState(() {
                                              if (questionFiveTable.length==0) {
                                                groupValue = rep.response;
                                                widget.upLevelNumber({
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                });
                                              }
                                              groupValue =
                                                  rep.response;
                                              rep.isSelected = value;
                                              if (value!) {
                                                widget.updateResponseData(
                                                {
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                },widget.questionId);
                                                if(unCheckAll){
                                                          widget.changeListLenght();
                                                          questionFiveTable.clear();
                                                          }
                                                questionFiveTable.add(rep.response);
                                                unCheckAll = false;

                                              }

                                              if (!value) {
                                                widget.updateRemoveResponseData(
                                                {
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                },widget.questionId);
                                                questionFiveTable.remove(rep.response);
                                                if(questionFiveTable.isEmpty){
                                                  widget.downLevelNumber(widget.questionId);
                                                }
                                                checkAll = false;

                                              }
                                            });
                                          }),
                                        ),
                                        title: Text(rep.response,
                                            style: TextStyle(
                                              color: appColorProvider.black54,
                                              fontSize: AppText.p2(context),
                                            )),
                                      ),
                                      widget.reponses.indexOf(rep) ==
                                                  widget.reponses.length - 1 &&
                                              int.parse(widget.questionNum) == 5
                                          ? Column(
                                              children: [
                                                ListTile(
                                                  leading: Checkbox(
                                                    value: checkAll,
                                                    onChanged: ((value) {
                                                      List listAnswers = [];
                                                      
                                                      widget.reponses.forEach((e) {
                                                      listAnswers.add(e.id);
                                                      });
                                                      setState(() {
                                              if (questionFiveTable.length==0) {
                                                groupValue = 'J’ai tout aimé';
                                                widget.upLevelNumber({
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                });
                                              }
                                                        checkAll = value!;
                                                        if(value){
                                                          questionFiveTable.clear();
                                                          widget.reponses
                                                                .forEach((rep) {
                                                                rep.isSelected =
                                                                    true;
                                                                    questionFiveTable.add(rep.response);
                                                              });
                                                              widget.likeAllResponseData(
                                                                listAnswers,widget.questionId);
                                                        }else{
                                                          widget.reponses
                                                                .forEach((rep) {
                                                                rep.isSelected=
                                                                    false;
                                                              });
                                                              questionFiveTable.clear();
                                                              print('questionFiveTableeeeeeeeee'+questionFiveTable.toString());
                                                        }
                                                        if (value) {
                                                          print('questionFiveTableeeeeeeeee'+questionFiveTable.toString());
                                                          //questionFiveTable.add(rep.response);
                                                          if(unCheckAll){
                                                          widget.changeListLenght();
                                                          }
                                                          unCheckAll = false;
                                                        }else{
                                                          questionFiveTable.remove(rep.response);
                                                          if(questionFiveTable.isEmpty){
                                                  widget.downLevelNumber(widget.questionId);
                                                }
                                                        }
                                                        print('questionFiveTableeeeeeeeee'+questionFiveTable.toString());
                                                      });
                                                    }),
                                                  ),
                                                  title: Text('J’ai tout aimé',
                                                      style: TextStyle(
                                                          color:
                                                              appColorProvider
                                                                  .black54,
                                                          fontSize: AppText.p2(
                                                              context),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                ListTile(
                                                    leading: Checkbox(
                                                    value: unCheckAll,
                                                    onChanged: ((value) {
                                                      setState(() {
                                                         if (questionFiveTable.length==0) {
                                                groupValue = 'Je n’ai rien aimé';
                                                widget.upLevelNumber({
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                });
                                                widget.upLevelNumber({
                                                  "question_id": widget.questionId,
                                                  "answer_ids": [rep.id]
                                                });
                                              }
                                                        unCheckAll = value!;
                                                        if(value){
                                                          widget.dislikeAllResponseData(widget.questionId);
                                                          widget.reponses
                                                                .forEach((rep) {
                                                                rep.isSelected =
                                                                    false;
                                                              });
                                                              questionFiveTable.clear();
                                                        }
                                                        if (value) {
                                                          questionFiveTable.add(rep.response);
                                                          //print('questionFiveTableeeeeeeeee'+questionFiveTable.toString());
                                                          checkAll = false;
                                                        widget.changeListLenght();}else if(!value){
                                                          questionFiveTable.remove(rep.response);
                                                          if(questionFiveTable.isEmpty){
                                                  widget.downLevelNumber(widget.questionId);
                                                  widget.downLevelNumber(widget.questionId);
                                                }
                                                          widget.changeListLenght();
                                                        }
                                                      });
                                                    }),
                                                  ),
                                                  title: Text(
                                                      'Je n’ai rien aimé',
                                                      style: TextStyle(
                                                          color:
                                                              appColorProvider
                                                                  .black54,
                                                          fontSize: AppText.p2(
                                                              context),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                          ]
                        ],
                      ),
                    )),
              ]),
        ),
      );
    });
  }
}
