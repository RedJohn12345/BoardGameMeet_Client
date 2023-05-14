import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/event.dart';

class EventsApiClient {

  Future<List> fetchMyEvents() async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/myEvents');
    var response = await http.get(url,
        headers: {'Authorization':
        'Bearer_eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkb3JvNGthIiwicm9sZXMiOltdLCJpYXQiOjE2ODQyNTIwMTEsImV4cCI6MTY4NDI1NTYxMX0.03454E6LyXS4SnThbZDRt5HHCnKwUF73TCDqq2QP44c',}
    );

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }

  Future<List> fetchEvents() async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/events');
    var response = await http.get(url,
        headers: {'Authorization':
        'Bearer_eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkb3JvNGthIiwicm9sZXMiOltdLCJpYXQiOjE2ODQyNDg4MDIsImV4cCI6MTY4NDI1MjQwMn0.PYLNIWZiuWTWW6FgGBIq-xF6wIs0cZMwF1crOZfj72Q',}
    );

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }
}