import 'package:cible/models/Event.dart';
import 'package:cible/models/favoris.dart';

List<Event> events = [
  Event(
      'CLACHOU -- Sex Symbol',
      'https://soutenir.gnadoe.com/wp-content/uploads/2022/06/WhatsApp-Image-2022-06-24-at-20.07.56.jpeg',
      {
        'nom': 'Moov Africa',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRX1w6Z3xzFpJ2U_t7i_OgDpMifkot_7wENklBbPp0Y2e5KokU-tNpKpyLx_hbJq8qEEqg&usqp=CAU'
      },
      false),
  Event(
      'Gnadoe magazine spécial 3 ans',
      'https://i0.wp.com/gnadoemedia.com/wp-content/uploads/2021/06/GNADOE-MAGAZINE-SPECIAL-3ANS.jpg?fit=1748%2C2480&ssl=1',
      {
        'nom': 'Togocom',
        'image':
            'https://togocom.tg/wp-content/uploads/2022/02/Icone-Togocom@2x.png'
      },
      false),
];

List<Favoris> favoris = [
  Favoris('Concerts', 'Concert', events),
];
