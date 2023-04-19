import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SecretWordWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;

  SecretWordWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _SecretWordWidgetState createState() {
    return _SecretWordWidgetState();
  }

}

class _SecretWordWidgetState extends State<SecretWordWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "Секретное слово*" : "Секретное слово*",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.name,
    style: TextStyle(color: Colors.white),
    validator: (word) {
      if (word != null && word.length < 5) {
        return 'Минимальная длина 5 символов';
      }
      return null;
    }
  );
}
