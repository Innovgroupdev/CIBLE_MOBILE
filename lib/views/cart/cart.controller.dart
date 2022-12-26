import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketCart.dart';
import 'package:http/http.dart' as http;
import 'package:cible/constants/api.dart';
import 'dart:convert';

passerAchat(total, DefaultUser user, List<TicketCart> tickets) async {
  // Map data = {'total': total, 'user': user, 'tickets': tickets};
  Map data = {
    'total': total,
    'user': user.toMap(),
    'tickets': tickets.map((e) => e.toMap())
  };
  print('start');
  var response = await http.post(Uri.parse("$baseApiUrl/ticket/buy"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: data.toString());
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);
    print(responseBody);
  } else if (response.statusCode == 500) {
    print(500);
  } else {
    print('ohoooo');
  }
}
