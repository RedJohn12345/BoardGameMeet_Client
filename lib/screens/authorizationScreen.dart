import 'package:flutter/material.dart';

class AuthorizationScreen extends StatelessWidget {

  AuthorizationScreen({super.key});

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
      body:
      Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(child: SizedBox(), flex: 1,),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox(), flex: 2,),
                  Expanded(
                    flex: 1,
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "Введите логин",
                          fillColor:  Color(0xff171717),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white60)
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "Введите пароль",
                          fillColor:  Color(0xff171717),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white60)
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text("Войти", style: TextStyle(fontSize: 21),),
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
                              child: Text("Регистрация", style: TextStyle(fontSize: 21),),
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                              onPressed: () {},
                            ),
                          ),]
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text("Забыли пароль?", style: TextStyle(fontSize: 21, color: Colors.blue,), textAlign: TextAlign.center,),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(child: SizedBox(), flex: 3,),
                ]),
            ),
            Expanded(child: SizedBox(), flex: 1,),
        ]),
      ),
    );
  }
}