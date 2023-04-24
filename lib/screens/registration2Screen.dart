import 'package:flutter/material.dart';
import '../widgets/SexWidget.dart';
import '../widgets/ageWidget.dart';

class Registration2Screen extends StatefulWidget {

  Registration2Screen({super.key});

  @override
  State<Registration2Screen> createState() => _Registration2ScreenState();
}

class _Registration2ScreenState extends State<Registration2Screen> {
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Регистрация", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: SexWidget()),
                  ],
                ),
                const SizedBox(height: 16,),
                AgeWidget(controller: ageController,),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        //Navigator.pushNamedAndRemoveUntil(context, '/registration+', (route) => false);
                        Navigator.pop(context);
                      },
                        child: Text("Продолжить"),
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                      ),
                    ),]
              ),

              const SizedBox(height: 16,),
                Row(
                    children: [
                      Expanded(
                        child: ElevatedButton( onPressed: () {
                        },
                          child: Text("Пропустить"),
                          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                        ),
                      ),]
                ),

                const SizedBox(height: 16,),
            ]),
          ),
        ),
      )

    );
  }
}