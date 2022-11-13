import 'package:cible/models/Event.dart';
import 'package:flutter/widgets.dart';

class FavorisProvider with ChangeNotifier {
  final List<Event> _favoris = [];

  List<Event> get favoris => _favoris;

  void addFavoris(Event event) {
    print(favoris.length);
    _favoris.add(event);
    notifyListeners();
  }

  void removeFavoris(Event event) {
    _favoris.removeWhere((element) => element == event);
    notifyListeners();
  }
}
