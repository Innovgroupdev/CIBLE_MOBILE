import 'dart:convert';

import 'package:cible/constants/api.dart';
import 'package:cible/helpers/sharePreferenceHelper.dart';
import 'package:cible/models/notification.dart';
import 'package:http/http.dart' as http;

Future<List<NotificationModel>> fetchNotifications() async {
  var token = await SharedPreferencesHelper.getValue('token');

  var response = await http.get(
    Uri.parse('$baseApiUrl/notifications'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return getNotificationsFromMap(jsonDecode(response.body)['data']);
  }
  return [];
}

List<NotificationModel> getNotificationsFromMap(List notificationsFromMap) {
  List<NotificationModel> notifications = [];
  for (var element in notificationsFromMap) {
    NotificationModel notificationModel = NotificationModel.fromMap(element);
    notifications.add(notificationModel);
  }
  return notifications;
}
