import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CountPlayersWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper;
  CountPlayersWidget({
    Key? key,
    required this.controller,
  this.withHelper = false}): super(key: key);

  @override
  _CountPlayersWidgetState createState() {
    return _CountPlayersWidgetState();
  }

}

class _CountPlayersWidgetState extends State<CountPlayersWidget> {
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly
    ],
    maxLength: 2,
    decoration: InputDecoration(
      counterText: "",
      labelText: widget.withHelper ? "Количество игроков*" : "Количество игроков",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.white),
      validator: (count) {
        if (count != null && count.isEmpty) {
          return 'Введите количество игроков!';
        }
        return null;
      }
  );
}
