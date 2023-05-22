import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:boardgm/model/Sex.dart';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
import '../model/member.dart';

class PersonsApiClient {

  static const authorization = 'Authorization';
  static const bearer = 'Bearer_';
  static const contentType = 'Content-type';
  static const json = 'application/json';
  static const address = 'http://10.0.2.2:8080';

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
      final body = jsonDecode(response.body);
      final token = body['token'];
      await _saveToken(token);
      return;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Member> fetchGetProfile(String userNickname) async {
    print("zxc1");
    var url = Uri.parse('$address/profile/$userNickname');
    final token = await Preference.getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonProfile = jsonDecode(response.body);
      return Member.fromJson(jsonProfile);
    } else {
      throw Exception('Error while get profile wile code ${response.statusCode}');
    }
  }

  Future fetchExitProfile() async {
    var url = Uri.parse('$address/exit');
    final token = await _getToken();

    var response = await http.post(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      await _deleteToken();
      return;
    } else {
      throw Exception('Error while exit profile with code ${response.statusCode}');
    }
  }

  Future<Member> fetchGetOwnProfile() async {
    print("zxc");
    var url = Uri.parse('$address/ownProfile');
    final token = await _getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonProfile = jsonDecode(response.body);
      return Member.fromJson(jsonProfile);
    } else {
      throw Exception('Error while get profile wile code ${response.statusCode}');
    }
  }

  Future fetchUpdatePerson(UpdatePersonRequest request) async {
    var url = Uri.parse('$address/updatePerson');
    final token = await _getToken();
    String gender = request.gender == Sex.MAN ? "MALE" : "FEMALE";
    final msg = jsonEncode({
      "name": request.name,
      "nickname": request.nickname,
      "city": request.city,
      "age": request.age,
      "gender": gender,
      "avatarId": request.avatarId
    });

    var response = await http.put(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      print(response.body);
      final body = jsonDecode(response.body);
      final token = body['token'];
      await _saveToken(token);
      return;
    } else {
      throw Exception('Error while update person with code ${response.statusCode}');
    }
  }

  Future fetchDeletePerson(String userNickname) async {
    var url = Uri.parse('$address/admin/deletePerson/$userNickname');
    final token = _getToken();

    var response = await http.delete(url,headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при удалении пользователя с кодом ${response.statusCode}');
    }
  }

  Future<List> fetchGetMembers(Long eventId) async {
    var url = Uri.parse('$address/getAllMembersIn/$eventId');
    final token = _getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonMembers = jsonDecode(response.body);
      return jsonMembers.map((json) => MemberInEvent.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка при получении всех участников мероприятия '
          'с кодом ${response.statusCode}');
    }
  }

  Future fetchJoinToEvent(int? eventId) async {
    var url = Uri.parse('$address/joinEvent/$eventId');
    final token = await _getToken();

    var response = await http.post(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при добавлении участника в мероприятие с кодом'
                                                      '${response.statusCode}');
    }
  }

  Future fetchLeaveFromEvent(int? eventId) async {
    var url = Uri.parse('$address/leaveEvent/$eventId');
    final token = await _getToken();

    var response = await http.post(url, headers: {
      authorization: bearer + token.toString()
    });
    //await _deleteToken();
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при выходе из мероприятия с кодом '
                                                      '${response.statusCode}');
    }
  }

  Future<bool> fetchValidateSecretWord(String secretWord) async {
    var url = Uri.parse('$address/validateSecretWord');
    final token = _getToken();
    final msg = jsonEncode({
      "secretWord": secretWord
    });

    var response = await http.post(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future fetchChangePassword(String password, String repeatPassword) async {
    var url = Uri.parse('$address/changePassword');
    final token = _getToken();
    final msg = jsonEncode({
      "newPassword": password,
      "repeatPassword": repeatPassword
    });

    var response = await http.put(url, body: msg,
      headers: {
        authorization: bearer + token.toString(),
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при смене пароля с кодом ${response.statusCode}');
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

}