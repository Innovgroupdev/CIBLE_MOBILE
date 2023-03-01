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

  

  Response(
      this._response,);

  Map<String, dynamic> toMap() {
    return {
      'response': response,
    };
  }

  factory Response.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));

    var question = Response(
      madDecode['text']??'',
    );
    return question;
  }
}
