import 'package:flutter/material.dart';

import '../widgets/LoginWidget.dart';

import '../widgets/SecretWordWidget.dart';

class ChangePasswordScreen extends StatefulWidget {

  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final secretWordController = TextEditingController();


  @override
  void dispose() {
    loginController.dispose();
    secretWordController.dispose();
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
              LoginWidget(controller: loginController, withHelper: true,),
              const SizedBox(height: 16,),
              SecretWordWidget(controller: secretWordController, withHelper: true,),
              const SizedBox(height: 16,),
              Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          Navigator.pushReplacementNamed(context, '/changePassword+');
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