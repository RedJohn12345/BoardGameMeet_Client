import 'package:flutter/material.dart';

import '../widgets/LoginWidget.dart';
import '../widgets/PasswordWidget.dart';

class AuthorizationScreen extends StatefulWidget {

  AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {

  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Авторизация", style: TextStyle(fontSize: 24),),
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
                LoginWidget(controller: loginController),
                const SizedBox(height: 16,),
                PasswordWidget(controller: passwordController,),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {

                        }
                      },
                        child: Text("Войти"),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                      ),
                    ),]
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        Navigator.pushReplacementNamed(context, '/registration');
                      },
                        child: Text("Зарегистрироваться"),
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                      ),
                    ),]
                ),
                const SizedBox(height: 16,),
                TextButton(
                  child: Text("Восстановление пароля", style: TextStyle(fontSize: 21, color: Colors.blue,), textAlign: TextAlign.center,),
                  onPressed: () {},
                ),
                const SizedBox(height: 16,),
            ]),
          ),
        ),
      ),
    );
  }
}


/*
Expanded(
flex: 1,
child: Row(
children: [
Expanded(
child: ElevatedButton(
child: Padding(padding: EdgeInsets.all(5), child: Text("Войти", style: TextStyle(fontSize: 21),)),
style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
onPressed: () {},
),
),]
),
),
Expanded(
flex: 1,
child: Row(
children: [
Expanded(
child: ElevatedButton(
child: Padding(padding: EdgeInsets.all(5), child: Text("Регистрация", style: TextStyle(fontSize: 21),)),
style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
onPressed: () {
Navigator.pushNamed(context, '/registration');
},
),
),]
),
),
Expanded(
flex: 1,
child: TextButton(
child: Text("Восстановление пароля", style: TextStyle(fontSize: 21, color: Colors.blue,), textAlign: TextAlign.center,),
onPressed: () {},
),
),*/
