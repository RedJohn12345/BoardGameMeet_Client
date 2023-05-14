import 'dart:async';
import 'dart:convert';
import 'package:boardgm/model/Sex.dart';
import 'package:http/http.dart' as http;

import '../model/event.dart';
import '../model/member.dart';

class PersonsApiClient {

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

  Future fetchRegistration(Member member) async {
    var url = Uri.parse('http://10.0.2.2:8080/auth/registration');
    String gender = member.sex == Sex.MAN ? "MALE" : "FEMALE";
    final msg = jsonEncode({
      "name": member.name,
      "nickname": member.login,
      "password": member.password,
      "secretWord": member.secretWord,
      "gender": gender,
      "city": member.city
    });

    var response = await http.post(url,
        body: msg,
      headers: {'Content-type':
        'application/json',}
    );

    if (response.statusCode == 200) {
      // Парсим JSON-ответ и преобразуем его в список событий
      return;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future fetchAuthorization(Member member) async {
    var url = Uri.parse('http://10.0.2.2:8080/auth/login');
    final msg = jsonEncode({
      "nickname": member.login,
      "password": member.password,
    });

    var response = await http.post(url,
        body: msg,
        headers: {'Content-type':
        'application/json',}
    );

    if (response.statusCode == 200) {
      print(response.body);
      return;
    } else {
      throw Exception(response.statusCode);
    }
  }
}