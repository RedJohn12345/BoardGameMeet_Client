
import 'package:flutter/material.dart';
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
      },
    );
  }
}

