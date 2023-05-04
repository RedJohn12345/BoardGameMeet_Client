import 'package:boardgm/screens/ChooseAvatarScreen.dart';
import 'package:boardgm/screens/MapCity.dart';
import 'package:boardgm/screens/ProfileEditScreen.dart';
import 'package:boardgm/screens/ProfileScreen.dart';
import 'package:boardgm/screens/WelcomeScreen.dart';
import 'package:boardgm/screens/changePassword.dart';
import 'package:boardgm/screens/editEventScreen.dart';
import 'package:boardgm/screens/eventScreen.dart';
import 'package:boardgm/screens/eventScreenShow.dart';
import 'package:flutter/material.dart';
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
      initialRoute: '/welcome',
      routes: {
        '/home': (context) => MainScreen(),
        '/my_events': (context) => MyEventsScreen(userId: 1,),
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

      },
    );
  }
}

