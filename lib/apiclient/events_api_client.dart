import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';

class EventsApiClient {

  static const authorization = 'Authorization';
  static const bearer = 'Bearer_';

  Future<List> fetchMyEvents(int page) async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/myEvents?page=$page&size=20');
    final token = await _getToken();
    var response = await http.get(url,
        headers: {authorization:
        bearer + token.toString()},);

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      final List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при загрузке событий');
    }
  }

  Future<List> fetchEvents(String city, String? search, int page) async {
    //final String url = '$_baseUrl/';
    var url = Uri.parse('http://10.0.2.2:8080/events?city=$city&search=$search&page=$page&size=20');
    final token = await _checkToken() ? await _getToken(): null;
    var response;
    if (token != null) {
      response = await http.get(url,
          headers: {authorization:
          bearer + token.toString(),}
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

  Future<Event> fetchEvent(Long eventId) async {
    var url = Uri.parse('http://10.0.2.2:8080/event/$eventId');
    final token = await _getToken();
    var response = await http.get(url,
        headers: {authorization:
        bearer + token.toString(),});

    if (response.statusCode == 200) {
      final dynamic eventJson = jsonDecode(response.body);
      return eventJson.map((json) => Event.fromJson(json));
    } else {
      throw Exception("Ошибка при загрузке ивента с id=$eventId");
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