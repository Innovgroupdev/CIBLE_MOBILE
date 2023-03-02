import 'dart:convert';

import 'package:cible/models/response.dart';

class Question{
  String _question;
  String get question => _question;

  set question(String question) {
    _question = question;
  }

  int _id = 0;
  int get id => _id;

  set id(int id) {
    _id = id;
  }

  List<Response> _responses;
  List<Response> get responses => _responses;

  set responses(List<Response> responses) {
    _responses = responses;
  }

  

  Question(
    this._id,
      this._question,
      this._responses,);

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'question': question,
      'responses': responses,
    };
  }

  factory Question.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    var answers = madDecode['answers'] as List;
    if (madDecode == null) {
      return Question(0,'',[]);
    }

  List<Response> getAnswerFromMap(answerListFromAPI) {
  var madDecode = jsonDecode(jsonEncode(answerListFromAPI));
  
  final List<Response> tagObjs = [];
  for (var element in madDecode) {
    var answer = Response.fromMap(element);
    tagObjs.add(answer);
  }
  return tagObjs;
}

    var question = Question(
      madDecode['id']??0,
      madDecode['text']??'',
      getAnswerFromMap(madDecode['answers'])
      ,
    );
    return question;
  }


}
