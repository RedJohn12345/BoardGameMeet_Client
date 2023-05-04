import 'package:flutter/material.dart';

import '../model/Sex.dart';

class SexWidget extends StatefulWidget {

  Sex sex;

  SexWidget({
    super.key,
    this.sex = Sex.NONE
  });

  @override
  State<SexWidget> createState() => _SexWidgetState();
}

class _SexWidgetState extends State<SexWidget> {

  String? hintText;

  @override
  Widget build(BuildContext context) {
    hintText = widget.sex == Sex.NONE ? null : widget.sex.title;
    return Container(
      padding: EdgeInsets.fromLTRB(15,5,15,5),
      decoration: BoxDecoration(
          color: Color(0xff171717),
          borderRadius: BorderRadius.circular(20)),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text("Пол", style: TextStyle(color: Colors.white60),),
        style: TextStyle(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Color(0xff50bc55),
        value: hintText,
      items: <int>[Sex.NONE.index, Sex.MAN.index, Sex.WOMAN.index, ].map((int value) {
      return DropdownMenuItem<String>(
            value: Sex.values[value].title,
            child: Text(Sex.values[value].title),
          );
        }).toList(),
        onChanged: (item) {
          setState(() {
            if (item! == "Мужской") {
              widget.sex = Sex.MAN;
            } else if (item== "Женский") {
              widget.sex = Sex.WOMAN;
            } else {
              widget.sex = Sex.NONE;
            }
            /*hintText = item;
            if (hintText == "Не указывать") {
              hintText = null;
            }*/
          });
        },
      ),
    );
  }
}