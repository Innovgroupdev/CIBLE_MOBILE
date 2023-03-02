import 'dart:convert';

class Response{
  String _response;
  String get response => _response;

  set response(String response) {
    _response = response;
  }

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  set isSelected(bool isSelected) {
    _isSelected = isSelected;
  }

    int _id = 0;
  int get id => _id;

  set id(int id) {
    _id = id;
  }

  

  Response(
    this._id,
      this._response,);

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'response': response,
    };
  }

  factory Response.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));

    var question = Response(
      madDecode['id']??0,
      madDecode['text']??'',
    );
    return question;
  }
}
