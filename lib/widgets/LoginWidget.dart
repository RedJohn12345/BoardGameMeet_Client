import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LoginWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;

  LoginWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _LoginWidgetState createState() {
    return _LoginWidgetState();
  }

}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
      maxLength: 30,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "Никнейм*" : "Никнейм",
      labelStyle: TextStyle(color: Colors.white60),
      fillColor:  Color(0xff171717),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.name,
    style: TextStyle(color: Colors.white),
    validator: (login) {
      if (login != null && login.length < 5) {
        return 'Минимальная длина 5 символов';
      }
      if (login != null && (login.contains(RegExp(r"[/W]")) || login.contains(RegExp(r"[а-яА-Я]")))) {
        return "Разрешены только латинские буквы, цифры \n и нижнее подчеркивание";
      }
      return null;
    }
  );
}
