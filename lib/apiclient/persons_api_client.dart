import 'dart:async';
import 'dart:convert';
import 'package:boardgm/model/Sex.dart';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:http/http.dart' as http;

import '../model/member.dart';

class PersonsApiClient {

  static const authorization = 'Authorization';
  static const bearer = 'Bearer_';
  static const contentType = 'Content-type';
  static const json = 'application/json';
  static const address = 'https://board-game-meet-dunad4n.cloud.okteto.net';

  Future fetchRegistration(Member member) async {
    var url = Uri.parse('$address/auth/registration');
    String gender = member.sex == Sex.MAN ? "MALE" : (member.sex == Sex.WOMAN ? "FEMALE" : "BLANK");
    final msg =  jsonEncode({
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
      throw Exception(response.body);
    }
  }

  Future fetchAuthorization(Member member) async {
    var url = Uri.parse('$address/auth/login');
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
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final token = body['token'];
      final role = body['role'] as String;
      print(role);
      final nickname = body['nickname'] as String;

      await Preference.saveToken(token);
      await Preference.saveRole(role);
      await Preference.saveNickname(nickname);
      Member member = await fetchGetOwnProfile();
      await Preference.saveAvatar(member.getAvatar());
      return;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Member> fetchGetProfile(String userNickname) async {
    var url = Uri.parse('$address/profile/$userNickname');
    final token = await Preference.getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> jsonProfile = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonProfile);
      return Member.fromJson(jsonProfile);
    } else {
      throw Exception('Error while get profile wile code ${response.statusCode}');
    }
  }

  Future fetchExitProfile() async {
    var url = Uri.parse('$address/exit');
    final token = await Preference.getToken();

    var response = await http.post(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      await Preference.deleteToken();
      return;
    } else {
      throw Exception('Error while exit profile with code ${response.statusCode}');
    }
  }

  Future<Member> fetchGetOwnProfile() async {
    var url = Uri.parse('$address/ownProfile');
    final token = await Preference.getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonProfile = jsonDecode(utf8.decode(response.bodyBytes));
      return Member.fromJson(jsonProfile);
    } else {
      throw Exception('Error while get profile wile code ${response.statusCode}');
    }
  }

  Future fetchUpdatePerson(UpdatePersonRequest request) async {
    var url = Uri.parse('$address/updatePerson');
    final token = await Preference.getToken();
    String gender = request.gender == Sex.MAN ? "MALE" : (request.gender == Sex.WOMAN ? "FEMALE" : "BLANK");
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
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final token = body['token'];
      final nickname = body['nickname'];

      await Preference.saveToken(token);
      await Preference.saveNickname(nickname);
      await Preference.saveAvatar("assets/images/${request.avatarId}.jpg");
      return;
    } else if (response.statusCode == 409) {
      throw Exception(response.body);
    } else {
      throw Exception('Error while update person with code ${response.statusCode}');
    }
  }

  Future fetchDeletePerson(String userNickname) async {
    var url = Uri.parse('$address/admin/deletePerson/$userNickname');
    final token = await Preference.getToken();

    var response = await http.delete(url,headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Ошибка при удалении пользователя с кодом ${response.statusCode}');
    }
  }

  Future<List<MemberInEvent>> fetchGetMembers(int eventId, int page) async {
    var url = Uri.parse('$address/getAllMembersIn/$eventId?page=$page&size=10');
    final token = await Preference.getToken();

    var response = await http.get(url, headers: {
      authorization: bearer + token.toString()
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonMembers = jsonDecode(utf8.decode(response.bodyBytes));
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
    final token = await Preference.getToken();

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
    final token = await Preference.getToken();

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
      "repeatNewPassword": repeatPassword,
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
    final token = await Preference.getToken();

    var response = await http.get(url,
      headers: {
        authorization: bearer + token.toString()
      }
    );

    if (response.statusCode == 200) {
      final dynamic jsonStatus = jsonDecode(utf8.decode(response.bodyBytes));
      final status = jsonStatus['myProfile'] as bool;
      return status;
    } else {
      throw Exception('Ошибка при получении статуса профиля ${response.statusCode}');
    }
  }

  Future fetchDeleteItems(int? eventId) async {
    var url = Uri.parse('$address/deleteItemsIn/$eventId');
    final token = await Preference.getToken();

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

  Future<bool> fetchVerifyToken(String token) async {
    var url = Uri.parse('$address/verifyToken');
    final nickname = await Preference.getNickname();

    final msg = jsonEncode({
      "token": token,
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



}