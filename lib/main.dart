import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/firebase_options.dart';
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
import 'package:boardgm/screens/mapScreen.dart';
import 'package:boardgm/screens/mapShowScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/MembersScreen.dart';
import 'screens/changePassword2.dart';
import 'screens/myEventsScreen.dart';
import 'screens/authorizationScreen.dart';
import 'screens/mainScreen.dart';
import 'screens/registration1Screen.dart';
import 'screens/registration2Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  // late int color;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> _initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
          10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();

  }
  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  // Future<void> _initAnalytics() async {
  //   await FirebaseAnalytics.instance
  //       .logBeginCheckout(
  //       value: 10.0,
  //       currency: 'USD',
  //       items: [
  //         AnalyticsEventItem(
  //             itemName: 'Socks',
  //             itemId: 'xjw73ndnw',
  //         ),
  //       ],
  //       coupon: '10PERCENTOFF'
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
    _initRemoteConfig();
    _initAppMetrica();
    // _initAnalytics();
  }

  Future<void> _initAppMetrica() async {
    await AppMetrica.activate(const AppMetricaConfig("7accc154-4b7f-4b08-976e-5423fbcca807"));
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
    // _remoteConfig.fetchAndActivate();
    bool condition = _remoteConfig.getBool("main_color");
    print("conditional is $condition");
    int color = condition ? 0xff50bc55 : Colors.deepOrange.value;
    if (isFirst == null)
      return CircularProgressIndicator();
    else {
      final String page = isFirst! ? '/welcome' : '/home';

      return MaterialApp(
        title: 'Board Game Meet',
        // navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: '/splash',
        routes: {
          '/home': (context) => MainScreen(color: color),
          '/my_events': (context) => MyEventsScreen(color: color),
          '/authorization': (context) => AuthorizationScreen(color: color),
          '/registration': (context) => Registration1Screen(color: color),
          '/registration+': (context) => Registration2Screen(color: color),
          '/changePassword': (context) => ChangePasswordScreen(color: color),
          '/changePassword+': (context) => ChangePassword2Screen(color: color),
          '/event': (context) => EventScreen(color: color),
          '/eventShow': (context) => EventScreenShow(color: color),
          '/members': (context) => MembersScreen(color: color),
          '/profile': (context) => ProfileScreen(color: color),
          '/profileEdit': (context) => ProfileEditScreen(color: color),
          '/avatarChoose': (context) => ChooseAvatar(color: color),
          '/editEvent': (context) => EditEventScreen(color: color),
          '/welcome': (context) => WelcomeScreen(color: color),
          '/items': (context) => ItemsScreen(color: color),
          '/chat': (context) => ChatScreen(color: color),
          '/splash': (context) => SplashScreen(route: page,),
          '/map': (context) => MapScreen(color: color),
          '/mapShow': (context) => MapShowScreen(color: color),
        },
      );
    }

  }
}

