import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../model/event.dart';

class EventsApiClient {
  final _baseUrl = 'http://localhost:8080';
  Future<List<dynamic>> fetchEvents(int userId) async {
    final response = await http.get('$_baseUrl/events?userId=$userId' as Uri);
    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }
}