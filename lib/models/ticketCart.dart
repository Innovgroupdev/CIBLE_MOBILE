import 'dart:convert';
import 'dart:core';

import 'package:cible/models/Event.dart';
import 'package:cible/models/ticket.dart';

class TicketCart {
  Ticket _ticket;
  int _quantite;
  Event1 _event;

  Ticket get ticket => _ticket;
  Event1 get event => _event;
  int get quantite => _quantite;

  set ticket(Ticket ticket) {
    _ticket = ticket;
  }

  set quantite(int quantite) {
    _quantite = quantite;
  }

  set event(Event1 event) {
    _event = event;
  }

  TicketCart(this._ticket, this._event, this._quantite);

  Map<String, dynamic> toMap() {
    return {
      'ticket': ticket,
      'event': event,
      'quantite': quantite,
    };
  }
}
