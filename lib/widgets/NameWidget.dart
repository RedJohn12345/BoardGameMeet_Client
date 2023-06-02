import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NameWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  String text;
  NameWidget({
    Key? key,
    required this.controller, this.withHelper = false,
  this.text = "Имя"}): super(key: key);

  @override
  _NameWidgetState createState() {
    return _NameWidgetState();
  }

}

class _NameWidgetState extends State<NameWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    maxLength: 30,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "${widget.text}*" : widget.text,
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
        return 'Введите ${widget.text}!';
      }
      return null;
    }
  );
}
