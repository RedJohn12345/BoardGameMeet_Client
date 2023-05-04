import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimeWidget extends StatefulWidget {

  DateTime selectedDate = DateTime.now();
  final TextEditingController controller;
  bool withHelper = false;

  DateTimeWidget({
    Key? key,
    this.withHelper = false, required this.controller}): super(key: key);

  @override
  _DateTimeWidgetState createState() {
    return _DateTimeWidgetState();
  }

}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: widget.controller,
      decoration: InputDecoration(
          labelText: widget.withHelper ? 'Дата и время*' : 'Дата и время',
          fillColor:  Color(0xff171717),
          filled: true,
          labelStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(color: Colors.white),
      onTap: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          currentTime: widget.selectedDate,
          onConfirm: (date) {
            setState(() {
              widget.selectedDate = date;
              widget.controller.text = DateFormat('yyyy-MM-dd kk:mm').format(date);
            });
          },
          locale: LocaleType.ru,
        );
      },
        validator: (date) {
          if (date != null && date.isEmpty) {
            return 'Введите дату!';
          }

          if (date != null && DateTime.parse(date).isBefore(DateTime.now())) {
            return 'Дата не может быть раньше текущей!';
          }
          return null;
        }
    );
  }
}
