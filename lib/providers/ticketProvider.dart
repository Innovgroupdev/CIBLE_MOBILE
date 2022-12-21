import 'package:cible/models/ticket.dart';
import 'package:flutter/widgets.dart';

class TicketProvider extends ChangeNotifier {
  List<Ticket> _ticketsList = [];
  double _total = 0;

  List<Ticket> get ticketsList => _ticketsList;
  double get total => _total;

  void setTotal(double newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void setTicketsList(List<Ticket> newTicketsList) {
    _ticketsList = newTicketsList;
    notifyListeners();
  }
}
// Provider.of<UserProvider>(context, listen: false)
//         .setNom(SharedPreferencesHelper.getNom() ?? '');

// Provider.of<UserProvider>(context).nom