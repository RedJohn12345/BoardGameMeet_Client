import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AddressWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  AddressWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _AddressWidgetState createState() {
    return _AddressWidgetState();
  }

}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
      maxLength: 30,
    decoration: InputDecoration(
      labelText: widget.withHelper ? "Адрес*" : "Адрес",
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
          return 'Введите адрес!';
        }
        return null;
      }
  );
}
