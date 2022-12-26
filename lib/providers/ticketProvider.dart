import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketCart.dart';
import 'package:flutter/widgets.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketCart> _ticketsList = [];
  double _total = 0;

  List<TicketCart> get ticketsList => _ticketsList;
  double get total => _total;

  void setTotal(double newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void setTicketsList(List<TicketCart> newTicketsList) {
    _ticketsList = newTicketsList;
    notifyListeners();
  }

  void addTickcet(TicketCart newTicket) {
    _ticketsList.add(newTicket);
    notifyListeners();
  }

  void removeTicket(TicketCart oldTicket) {
    _ticketsList.remove(oldTicket);
    notifyListeners();
  }
}
