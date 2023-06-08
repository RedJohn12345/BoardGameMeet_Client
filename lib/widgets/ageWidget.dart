import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AgeWidget extends StatefulWidget {

  final TextEditingController controller;
  TextEditingController? subController;
  String text;
  AgeWidget({
    Key? key,
    required this.controller, this.text = "Возраст", this.subController}): super(key: key);

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
      counterText: "",
      labelText: widget.text,
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.white),
      validator: (name) {
        if (widget.subController != null && name != null) {
          if (widget.subController!.text.isNotEmpty && name.isEmpty) {
            return "Поле не заполнено";
          }
        }
        return null;
      },
  );
}
