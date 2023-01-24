import 'dart:convert';
import 'dart:core';

import 'package:cible/models/Event.dart';
import 'package:cible/models/ticket.dart';

class TicketUser {
  Ticket _ticket;
  int _quantite;
  double _montant;
  Event1 _event;

  Ticket get ticket => _ticket;
  Event1 get event => _event;
  int get quantite => _quantite;
  double get montant => _montant;

  set ticket(Ticket ticket) {
    _ticket = ticket;
  }

  set quantite(int quantite) {
    _quantite = quantite;
  }

  set montant(double montant) {
    _montant = montant;
  }

  set event(Event1 event) {
    _event = event;
  }

  TicketUser(this._ticket, this._event, this._quantite, this._montant);

  factory TicketUser.fromMap(Map map) {
    var madDecode = json.decode(json.encode(map));

    var ticketCart = TicketUser(
      madDecode['ticket'],
      madDecode['event'],
      madDecode['quantite'],
      madDecode['montant'],
    );
    return ticketCart;
  }

  Map<String, dynamic> toMap() {
    return {
      'ticket': ticket.id,
      'evenement': event.id,
      'quantite': quantite,
      'montant': montant,
    };
  }
}
