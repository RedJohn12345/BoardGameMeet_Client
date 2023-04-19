import 'package:flutter/material.dart';

enum Sex {
  MAN(title: "Мужской"),
  WOMAN(title: "Женский"),
  OTHER(title: "Другой"),
  NONE(title: "Не указывать");


  final String title;


  const Sex({required this.title});

}

class SexWidget extends StatefulWidget {

  Sex sex = Sex.NONE;
  String hintText = Sex.NONE.title;

  SexWidget({
    super.key,
  });

  @override
  State<SexWidget> createState() => _SexWidgetState();
}

class _SexWidgetState extends State<SexWidget> {


  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Color(0xff50bc55),
      value: widget.hintText,
      hint: Text(widget.hintText, style: TextStyle(color: Colors.white60),),
    items: <Sex>[Sex.NONE, Sex.MAN, Sex.WOMAN, Sex.OTHER].map((Sex value) {
    return DropdownMenuItem<String>(
          value: value.title,
          child: Text(value.title),
        );
      }).toList(),
      onChanged: (item) {
        widget.hintText = item!;
      },
    );
  }
}