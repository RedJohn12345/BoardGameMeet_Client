import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/utils/analytics.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  final String route;

  const SplashScreen({super.key, required this.route});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    _navigate();
    AppMetrica.reportEvent('Splash screen');
  }

  void _navigate() async {
    await Future.delayed(Duration(seconds: 3)); // Задержка в 3 секунды
    Navigator.pushReplacementNamed(context, widget.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff292929),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
          child: Image(image: AssetImage('assets/images/splash.jpg'),),
      ),
        ),
    );
  }
}