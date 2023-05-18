import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';

class EventsApiClient {

  Future<List> fetchMyEvents(int page) async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/myEvents?page=$page&size=20');
    final token = await _getToken();
    var response = await http.get(url,
        headers: {'Authorization':
        'Bearer_$token'},);

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }

  Future<List> fetchEvents(String city, String search, int page) async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/events?city=$city&search=$search&page=$page&size=20');
    final token = await _checkToken() ? await _getToken(): null;
    var response;
    if (token != null) {
      response = await http.get(url,
          headers: {'Authorization':
          'Bearer_$token',}
      );
    } else {
     response = await http.get(url);
    }

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future fetchCreateEvent(Event event) async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/createEvent');
    final token = await _getToken();

    final msg = jsonEncode({
    "name": event.name,
    "game": event.game,
    "city": event.city,
    "address": event.location,
    "date": event.date.toString(),
    "maxPersonCount": event.maxNumberPlayers,
    "minAge": event.minAge,
    "maxAge": event.maxAge,
    "description": event.description
    });

    var response = await http.post(url, body: msg,
        headers: {'Authorization':
        'Bearer_$token', 'Content-type':
        'application/json'}
    );


    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      return;
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}