import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  String? city;
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
      maxLength: 100,
    decoration: InputDecoration(
      counterText: "",
      labelText: widget.withHelper ? "Адрес*" : "Адрес",
      fillColor:  Color(0xff171717),
      filled: true,
      labelStyle: TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ),
    keyboardType: TextInputType.name,
      onTap: () async {
        var result = await Navigator.pushNamed(context, '/map',
            arguments: false);
        if (result != null) {
          widget.controller.text = result as String;
        }

      },
    style: TextStyle(color: Colors.white),
      validator: (name) {
        if (name == null || name.isEmpty) {
          return 'Please enter a address';
        }

        return null;
      }
  );

}
