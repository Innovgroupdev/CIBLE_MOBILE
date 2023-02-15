import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/models/Event.dart';
import 'package:cible/models/ticket.dart';
import 'package:http/http.dart' as http;

bool getCategorieIsMultiple(code) {
  List listMultiple = ['FOIR', 'FES', 'EXP'];
  return listMultiple.contains(code);
}

getCategorieIsCinema(code) {
  return code == 'CINE';
}

Future<bool> addLike(Event1 event) async {
  if (event.isLike) {
    event.like++;
    var response = await http.put(
      Uri.parse('$baseApiUrl/events/like/${event.id}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
  } else {
    event.like--;
  }
  return false;
}

Future<bool> addDisLike(Event1 event) async {
  if (event.isDislike) {
    event.dislike++;
    var response = await http.put(
      Uri.parse('$baseApiUrl/events/dislike/${event.id}'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
  } else {
    event.dislike--;
  }
  return false;
}

Future<List<Ticket>> getTicketsList(int id) async {
  List ticketsfromJSON = [];

  var response = await http.get(
    Uri.parse('$baseApiUrl/tickets/$id'),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  print(response.statusCode);
  print(jsonDecode(response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {
    ticketsfromJSON = jsonDecode(response.body)['data'] as List;
    final tickets = List<Ticket>.from(
      ticketsfromJSON.map(
        (e) => Ticket.fromJSON(e),
      ),
    );
    return tickets;
  }
  return [];
}
