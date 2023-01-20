import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:http/http.dart' as http;
import 'package:cible/constants/api.dart';
import 'dart:convert';

Future passerAchat(total, DefaultUser user, List<TicketUser> tickets) async {
  // Map data = {'total': total, 'user': user, 'tickets': tickets};
  Map ticketsMap = {};
  print('start');
  Map data = {
    'total': total,
    'user': user.toMap(),
    'tickets': tickets.map((e) => e.toMap()).toList()
    // 'tickets': tickets
    // 'tickets': tickets.map((e) {
    //   e.toMap();
    // }).toList()
  };

  tickets.forEach(
    (element) {
      print(element.montant);
    },
  );

  print(jsonEncode(data));

  var response = await http.post(Uri.parse("$baseApiUrl/ticket/buy"),
      body: jsonEncode(data));
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    var responseBody = jsonDecode(response.body);

    print(responseBody);
  } else if (response.statusCode == 500) {
    print(response.body);
  } else {
    print(response.body);
    print('ohoooo');
  }
}
