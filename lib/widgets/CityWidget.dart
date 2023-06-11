import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CityWidget extends StatefulWidget {


  final TextEditingController controller;
  bool withHelper = false;
  String city;
  CityWidget({
    Key? key,
    required this.controller, this.withHelper = false, required this.city}): super(key: key);

  @override
  _CityWidgetState createState() {
    return _CityWidgetState();
  }


}

class _CityWidgetState extends State<CityWidget> {

  @override
  void initState() {
    widget.controller.text = widget.city;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    readOnly: true,
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
    onTap: () async {
      var result = await Navigator.pushNamed(context, '/map',
          arguments: true);
      if (result != null) {
        widget.controller.text = result as String;
      }

    },
    validator: (value) {
      if(value == null || value.isEmpty) {
        return "Введите город";
      }
      return null;
    },
  );


}


