import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NameWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  NameWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _NameWidgetState createState() {
    return _NameWidgetState();
  }

}

class _NameWidgetState extends State<NameWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "Имя*" : "Имя",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.name,
    style: TextStyle(color: Colors.white),
    validator: (name) {
      if (name != null && name.isEmpty) {
        return 'Введите имя!';
      }
      return null;
    }
  );
}
