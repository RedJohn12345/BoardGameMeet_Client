import 'package:boardgm/model/member.dart';
import 'package:flutter/material.dart';

import '../widgets/LoginWidget.dart';
import '../widgets/NameWidget.dart';
import '../widgets/PasswordWidget.dart';
import '../widgets/SecretWordWidget.dart';

class Registration1Screen extends StatefulWidget {

  Registration1Screen({super.key});

  @override
  State<Registration1Screen> createState() => _Registration1ScreenState();
}

class _Registration1ScreenState extends State<Registration1Screen> {
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final secretWordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    secretWordController.dispose();
    nameController.dispose();
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
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
              NameWidget(controller: nameController, withHelper: true,),
              const SizedBox(height: 16,),
              LoginWidget(controller: loginController, withHelper: true,),
              const SizedBox(height: 16,),
              PasswordWidget(controller: passwordController, withHelper: true,),
              const SizedBox(height: 16,),
              SecretWordWidget(controller: secretWordController, withHelper: true,),
              const SizedBox(height: 16,),
              Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          Member member = Member(name: nameController.text, login: loginController.text,
                              password: passwordController.text, secretWord: secretWordController.text);
                          Navigator.pushReplacementNamed(context, '/registration+', arguments: member);
                        }
                      },
                        child: Text("Продолжить"),
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