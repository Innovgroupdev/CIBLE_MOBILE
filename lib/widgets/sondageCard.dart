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
      required this.questionNum,
      required this.question,
      required this.reponses,
      required this.onSonChanged})
      : super(key: key);
  String questionNum;
  String question;
  List<dynamic> reponses;
  final IntCallback onSonChanged;

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorProvider>(
        builder: (context, appColorProvider, child) {
      return Card(
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
                                    value: rep,
                                    groupValue: response,
                                    onChanged: ((value) {
                                      setState(() {
                                         if (groupValue == 'xxx') {
                                        groupValue = value;
                                              widget.onSonChanged();
                                        }
                                        response = value.toString();
                                      });
                                       
                                        
                                    }),
                                    title: Text(
                                      rep,
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
                                          value: rep['isSelected'],
                                          onChanged: ((value) {
                                            setState(() {
                                              if (groupValue == 'xxx') {
                                                groupValue = rep['response'];
                                                widget.onSonChanged();
                                              }
                                              groupValue =
                                                  rep['response'];
                                              rep['isSelected'] = value;
                                              if (value!) {
                                                unCheckAll = false;
                                              }
                                              if (!value) {
                                                checkAll = false;
                                              }
                                            });
                                          }),
                                        ),
                                        title: Text(rep['response'],
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
                                                      setState(() {
                                              if (groupValue == 'xxx') {
                                                groupValue = 'J’ai tout aimé';
                                                widget.onSonChanged();
                                              }
                                                        checkAll = value!;
                                                        value
                                                            ? widget.reponses
                                                                .forEach((rep) {
                                                                rep['isSelected'] =
                                                                    true;
                                                              })
                                                            : widget.reponses
                                                                .forEach((rep) {
                                                                rep['isSelected'] =
                                                                    false;
                                                              });
                                                        if (value) {
                                                          unCheckAll = false;
                                                        }
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
                                                         if (groupValue == 'xxx') {
                                                groupValue = 'Je n’ai rien aimé';
                                                widget.onSonChanged();
                                              }
                                                        unCheckAll = value!;
                                                        value == true
                                                            ? widget.reponses
                                                                .forEach((rep) {
                                                                rep['isSelected'] =
                                                                    false;
                                                              })
                                                            : null;
                                                        if (value) {
                                                          checkAll = false;
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
