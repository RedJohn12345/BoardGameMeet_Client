import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CityWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  CityWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _CityWidgetState createState() {
    return _CityWidgetState();
  }

}

class _CityWidgetState extends State<CityWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "Город*" : "Город",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.name,
    style: TextStyle(color: Colors.white),
  );
}
