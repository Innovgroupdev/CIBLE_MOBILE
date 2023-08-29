import 'package:cible/constants/api.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountriesService {
  Future<List<Map<String, String>>> getCountryAvailableOnAPi() async {
    List<Map<String, String>> countries = [];
    List<Map<String, String>> finalCountries = [];
    List data;

    var response = await http.get(
      Uri.parse('$baseApiUrl/pays'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['data'] != null) {
        data = responseBody['data'] as List;
        for (var item in data) {
          Map<String, String> country = {};
          country['id'] = item['id'].toString();
          country['libelle'] = item['libelle'] as String;
          country['code_pays'] = item['code_pays'] as String;
          country['dial_code'] = item['dial_code'] as String;
          country['phone_number_regex'] = item['phone_number_regex'] as String;
          countries.add(country);
        }
      }
      for (var countrie in countries) {
        finalCountries.add(
          {
            "id": countrie['id']!,
            "name": countrie['libelle']!,
            "code": countrie['code_pays']!,
            "dial_code": countrie['dial_code']!,
            "regex": countrie['phone_number_regex']!,
          },
        );
      }
      return finalCountries;
    } else {
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchCountries(BuildContext context) async {
    if (Provider.of<AppManagerProvider>(context, listen: false)
        .countries
        .isEmpty) {
      List<Map<String, String>> countries =
          await CountriesService().getCountryAvailableOnAPi();

      Provider.of<AppManagerProvider>(context, listen: false).countries =
          countries;
      return countries;
    }
    return Provider.of<AppManagerProvider>(context, listen: false).countries;
  }
}
