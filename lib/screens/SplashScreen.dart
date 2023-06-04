import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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