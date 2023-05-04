import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:flutter/widgets.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketUser> _ticketsList = [];
  double _total = 0;

  List<TicketUser> get ticketsList => _ticketsList;
  double get total => _total;

  void setTotal(double newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void setTicketsList(List<TicketUser> newTicketsList) {
    _ticketsList = newTicketsList;
    notifyListeners();
  }

  void addTicket(TicketUser newTicket) {
    for (var t in ticketsList) {
      if (identical(newTicket.ticket, t.ticket)) {
        newTicket.quantite = newTicket.quantite + t.quantite;
        _ticketsList.add(newTicket);
        removeTicket(t);
        return;
      }
    }
    _ticketsList.add(newTicket);
    notifyListeners();
  }

  void removeTicket(TicketUser oldTicket) {
    _ticketsList.remove(oldTicket);
    notifyListeners();
  }
}
