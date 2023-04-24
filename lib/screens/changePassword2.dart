import 'package:flutter/material.dart';

import '../widgets/LoginWidget.dart';

import '../widgets/PasswordWidget.dart';
import '../widgets/SecretWordWidget.dart';

class ChangePassword2Screen extends StatefulWidget {

  ChangePassword2Screen({super.key});

  @override
  State<ChangePassword2Screen> createState() => _ChangePassword2ScreenState();
}

class _ChangePassword2ScreenState extends State<ChangePassword2Screen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final repeatController = TextEditingController();


  @override
  void dispose() {
    passwordController.dispose();
    repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Восстановление пароля", style: TextStyle(fontSize: 24),),
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
              PasswordWidget(controller: passwordController, withHelper: true,),
              const SizedBox(height: 16,),
                PasswordWidget(controller: repeatController, withHelper: true, hintText: "Повторение пароля"),
              const SizedBox(height: 16,),
              Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      },
                        child: Text("Восстановить"),
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