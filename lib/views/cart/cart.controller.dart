import 'package:cible/models/defaultUser.dart';
import 'package:cible/models/ticket.dart';
import 'package:cible/models/ticketUser.dart';
import 'package:http/http.dart' as http;
import 'package:cible/constants/api.dart';
import 'dart:convert';

// {
//     "total" : 3250,
//     "user" : 216,
//     "tickets" : [
//         {
//             "ticket": 2,
//             "evenement": 81,
//             "montant": 1500,
//             "quantite" : 4
//         },
//         {
//             "ticket": 1,
//             "evenement": 81,
//             "montant": 1500,
//             "quantite": 3
//         },
//         {
//             "ticket": 2,
//             "evenement": 80,
//             "montant": 1500,
//             "quantite" : 1
//         }
//     ]
// }

Future passerAchat(total, DefaultUser user, List<TicketUser> tickets) async {
  print('userrrrrrrrrrrrrrr');
  print(user.id);
  print(user.nom);
  print('start');
  Map data = {
    'total': total,
    'user': 237,
    'tickets': tickets.map((e) => e.toMap()).toList()
  };
  print('dataaaaaaa');
  print(data);

  print('ENCODEdataaaaaaa');
  print(jsonEncode(data));

  var response = await http.post(
    Uri.parse("$baseApiUrl/ticket/buy"),
    body: jsonEncode(data),
  );
  print(response.statusCode);
  print(response.body);
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
