import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AgeWidget extends StatefulWidget {

  final TextEditingController controller;
  const AgeWidget({
    Key? key,
    required this.controller,}): super(key: key);

  @override
  _AgeWidgetState createState() {
    return _AgeWidgetState();
  }

}

class _AgeWidgetState extends State<AgeWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly
    ],
    maxLength: 3,
    decoration: InputDecoration(
      labelText: "Возраст",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.white),
  );
}
