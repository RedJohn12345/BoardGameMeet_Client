
import 'package:flutter/material.dart';
import 'package:untitled/screens/changePassword.dart';
import 'package:untitled/screens/eventScreen.dart';
import 'package:untitled/screens/eventScreenShow.dart';
import 'screens/MembersScreen.dart';
import 'screens/changePassword2.dart';
import 'screens/myEventsScreen.dart';
import 'screens/authorizationScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/registration1Screen.dart';
import 'screens/registration2Screen.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Game Meet',
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/my_events': (context) => MyEventsScreen(),
        '/authorization': (context) => AuthorizationScreen(),
        '/registration': (context) => Registration1Screen(),
        '/registration+': (context) => Registration2Screen(),
        '/changePassword': (context) => ChangePasswordScreen(),
        '/changePassword+': (context) => ChangePassword2Screen(),
        '/event': (context) => EventScreen(),
        '/eventShow': (context) => EventScreenShow(),
        '/members': (context) => MembersScreen(),
      },
    );
  }
}

