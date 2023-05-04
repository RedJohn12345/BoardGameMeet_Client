import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DescriptionWidget extends StatefulWidget {

  final TextEditingController controller;
  const DescriptionWidget({
    Key? key,
    required this.controller}): super(key: key);

  @override
  _DescriptionWidgetState createState() {
    return _DescriptionWidgetState();
  }

}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    maxLength: 300,
    minLines: 4,
    maxLines: 4,
    decoration: InputDecoration(
      labelText: "Описание",
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
