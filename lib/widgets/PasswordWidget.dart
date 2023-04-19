import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PasswordWidget extends StatefulWidget {

  final TextEditingController controller;

  bool withHelper = false;

  PasswordWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _PasswordWidgetState createState() {
    return _PasswordWidgetState();
  }

}

class _PasswordWidgetState extends State<PasswordWidget> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) => TextFormField(
      obscureText: isHidden,
      obscuringCharacter: "*",
      decoration: InputDecoration(
          labelText: widget.withHelper ? "Пароль*" : "Пароль",
          fillColor:  Color(0xff171717),
          filled: true,
          labelStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: IconButton(
            icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            onPressed: togglePasswordVisibility,
          )
      ),
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(color: Colors.white),
    controller: widget.controller,
    validator: (password) {
      if (password != null && password.length < 5) {
        return 'Минимальная длина 5 символов';
      }
      if (password != null && (password.contains(RegExp(r"[а-яА-Я]")))) {
        return "Разрешены только латинские буквы";
      }
      return null;
    }
  );

  void togglePasswordVisibility() => setState(() {
    isHidden = !isHidden;
  });
}
