import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController controller = PageController();

    int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = (controller.page ?? 0.0).round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: controller,
          children: [
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("BoardGameMeet", style: TextStyle(fontSize: 24),),
                centerTitle: true,
                backgroundColor: Color(0xff50bc55),
              ),
              backgroundColor: Color(0xff292929),
              body:Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/welcome1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("BoardGameMeet", style: TextStyle(fontSize: 24),),
                centerTitle: true,
                backgroundColor: Color(0xff50bc55),
              ),
              backgroundColor: Color(0xff292929),
              body: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/welcome2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("BoardGameMeet", style: TextStyle(fontSize: 24),),
                centerTitle: true,
                backgroundColor: Color(0xff50bc55),
              ),
              backgroundColor: Color(0xff292929),
              body: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/welcome3.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("BoardGameMeet", style: TextStyle(fontSize: 24),),
                centerTitle: true,
                backgroundColor: Color(0xff50bc55),
              ),
              backgroundColor: Color(0xff292929),
              body: Container(
                padding: EdgeInsets.all(40),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton( onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                          },
                            child: Text("Начать"),
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/welcome4.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 10.0,
          left: 0.0,
          right: 0.0,
          child: DotsIndicator(
            dotsCount: 4,
            position: currentPage.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
            ),
          ),
        ),
        ],
      ),
    );
  }
}