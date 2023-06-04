import 'package:boardgm/screens/ChooseAvatarScreen.dart';
import 'package:boardgm/screens/ProfileEditScreen.dart';
import 'package:boardgm/screens/ProfileScreen.dart';
import 'package:boardgm/screens/SplashScreen.dart';
import 'package:boardgm/screens/WelcomeScreen.dart';
import 'package:boardgm/screens/changePassword.dart';
import 'package:boardgm/screens/chatScreen.dart';
import 'package:boardgm/screens/editEventScreen.dart';
import 'package:boardgm/screens/eventScreen.dart';
import 'package:boardgm/screens/eventScreenShow.dart';
import 'package:boardgm/screens/itemsScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/MembersScreen.dart';
import 'screens/changePassword2.dart';
import 'screens/myEventsScreen.dart';
import 'screens/authorizationScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/registration1Screen.dart';
import 'screens/registration2Screen.dart';

void main() {
  runApp(FlutterApp());
}

class FlutterApp extends StatefulWidget {
  const FlutterApp({super.key});

  @override
  State<FlutterApp> createState() => _FlutterAppState();

  static Future<void> _setFirst() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first', false);
  }

}

class _FlutterAppState extends State<FlutterApp> {
  bool? isFirst;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first') ?? true;

    setState(() {
      isFirst = isFirstTime;
    });

    if (isFirstTime) {
      await prefs.setBool('first', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst == null)
      return CircularProgressIndicator();
    else {
      final String page = isFirst! ? '/welcome' : '/home';

      return MaterialApp(
        title: 'Board Game Meet',
        initialRoute: '/splash',
        routes: {
          '/home': (context) => MainScreen(),
          '/my_events': (context) => MyEventsScreen(),
          '/authorization': (context) => AuthorizationScreen(),
          '/registration': (context) => Registration1Screen(),
          '/registration+': (context) => Registration2Screen(),
          '/changePassword': (context) => ChangePasswordScreen(),
          '/changePassword+': (context) => ChangePassword2Screen(),
          '/event': (context) => EventScreen(),
          '/eventShow': (context) => EventScreenShow(),
          '/members': (context) => MembersScreen(),
          '/profile': (context) => ProfileScreen(),
          '/profileEdit': (context) => ProfileEditScreen(),
          '/avatarChoose': (context) => ChooseAvatar(),
          '/editEvent': (context) => EditEventScreen(),
          '/welcome': (context) => WelcomeScreen(),
          '/items': (context) => ItemsScreen(),
          '/chat': (context) => ChatScreen(),
          '/splash': (context) => SplashScreen(route: page,),
        },
      );
    }

  }
}

