import 'package:flutter/cupertino.dart';

class EventsProvider extends ChangeNotifier {
  List _eventsLieux = [];

  List get eventsLieux => _eventsLieux;

  void setEventsLieux(List newEventsLieux) {
    _eventsLieux = newEventsLieux;
    notifyListeners();
  }
}
