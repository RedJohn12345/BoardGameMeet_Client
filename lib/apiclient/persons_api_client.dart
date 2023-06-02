import 'dart:async';
import 'dart:convert';
import 'package:boardgm/model/Sex.dart';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/member.dart';

class PersonsApiClient {

  static const authorization = 'Authorization';
  static const bearer = 'Bearer_';
  static const contentType = 'Content-type';
  static const json = 'application/json';
  static const address = 'http://10.0.2.2:8080';

  Future fetchRegistration(Member member) async {
    var url = Uri.parse('http://10.0.2.2:8080/auth/registration');
    String gender = member.sex == Sex.MAN ? "MALE" : "FEMALE";
    final msg = jsonEncode({
      "name": member.name,
      "nickname": member.nickname,
      "password": member.password,
      "secretWord": member.secretWord,
      "gender": gender,
      "city": await YandexMapKitUtil.getCity(),
      "age": member.age
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
      "nickname": member.nickname,
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
      final role = body['role'] as String;
      await _saveToken(token);
      await _saveRole(role);
      return;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Member> fetchGetProfile(String userNickname) async {
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
    final token = await _getToken();

    var response = await http.delete(url,headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при удалении пользователя с кодом ${response.statusCode}');
    }
  }

  Future<List<MemberInEvent>> fetchGetMembers(int eventId) async {
    var url = Uri.parse('$address/getAllMembersIn/$eventId');
    final token = await _getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonMembers = jsonDecode(response.body);
      List<MemberInEvent> members = [];
      for (final jsonMember in jsonMembers) {
        members.add(MemberInEvent.fromJson(jsonMember));
      }
      return members;
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

  Future<bool> fetchValidateSecretWord(String nickname, String secretWord) async {
    var url = Uri.parse('$address/validateSecretWord');
    final msg = jsonEncode({
      "secretWord": secretWord,
      "nickname": nickname
    });

    var response = await http.post(url, body: msg,
      headers: {
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future fetchChangePassword(String password, String repeatPassword, String nickname) async {
    var url = Uri.parse('$address/changePassword');
    final msg = jsonEncode({
      "newPassword": password,
      "repeatPassword": repeatPassword,
      "nickname": nickname,
    });

    var response = await http.put(url, body: msg,
      headers: {
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при смене пароля с кодом ${response.statusCode}');
    }
  }

  Future<bool> fetchIsMyProfile(String nickname) async {
    var url = Uri.parse('$address/isProfileOf/$nickname');
    final token = await _getToken();

    var response = await http.get(url,
      headers: {
        authorization: bearer + token.toString()
      }
    );

    if (response.statusCode == 200) {
      final dynamic jsonStatus = jsonDecode(response.body);
      final status = jsonStatus['myProfile'] as bool;
      return status;
    } else {
      throw Exception('Ошибка при получении статуса профиля ${response.statusCode}');
    }
  }

  Future fetchDeleteItems(int? eventId) async {
    var url = Uri.parse('$address/deleteItemsIn/$eventId');
    final token = await _getToken();

    var response = await http.delete(url,
      headers: {
        authorization: bearer + token.toString()
      }
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при удалении итемов ${response.statusCode}');
    }
  }

  Future<bool> fetchVerifyToken() async {
    var url = Uri.parse('$address/verifyToken');
    final token = await _getToken();
    final nickname = await _getNickname();

    final msg = jsonEncode({
      "token": token.toString(),
      "nickname": nickname
    });

    var response = await http.post(url, body: msg,
      headers: {
        contentType: json
      }
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

  static Future _saveToken(String token) async {
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

  static Future _saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
  }

  static Future _saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nickname', nickname);
  }

  static Future<String?> _getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }

}