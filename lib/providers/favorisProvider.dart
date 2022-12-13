import 'package:cible/models/Event.dart';
import 'package:flutter/widgets.dart';

class FavorisProvider with ChangeNotifier {
  final List<Event> _favoris = [];

  List<Event> get favoris =>
      _favoris.where((element) => element.like == true).toList();

  void addFavoris(Event event) {
    _favoris.add(event);

    notifyListeners();
  }

  void removeFavoris(Event event) {
    _favoris.removeWhere((element) => element == event);
    notifyListeners();
  }
}
