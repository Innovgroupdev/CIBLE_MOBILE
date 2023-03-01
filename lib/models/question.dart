import 'dart:convert';

import 'package:cible/models/response.dart';

class Question{
  String _question;
  String get question => _question;

  set question(String question) {
    _question = question;
  }

  List<Response> _responses;
  List<Response> get responses => _responses;

  set responses(List<Response> responses) {
    _responses = responses;
  }

  

  Question(
      this._question,
      this._responses,);

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'responses': responses,
    };
  }

  factory Question.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));
    var answers = madDecode['answers'] as List;
    if (madDecode == null) {
      return Question('',[]);
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
      madDecode['text']??'',
      getAnswerFromMap(madDecode['answers'])
      ,
    );
    return question;
  }


}
