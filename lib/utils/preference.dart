import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiclient/persons_api_client.dart';

class Preference {

  static Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final api = PersonsApiClient();
    if (await api.fetchVerifyToken(token.toString())) {
      return token;
    } else {
      deleteToken();
      Restart.restartApp();
    }
    return null;
  }

  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  static Future saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
  }

  static Future saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nickname', nickname);
  }

  static Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }

}