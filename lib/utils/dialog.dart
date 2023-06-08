import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
   static Future showErrorDialog(BuildContext context, String text) {
     return showDialog(
       context: context,
       builder: (BuildContext context) {
         return SimpleDialog(
           title: Text(text),
           children: <Widget>[
             SimpleDialogOption(
               onPressed: () {
                 Navigator.pop(context);
               },
               child: Center(child: Text('ОК')),
             ),
           ],
         );
       },
     );
   }

   static Future showErrorUnauthorizedDialog(BuildContext context) {
     return showDialog(
       context: context,
       builder: (BuildContext context) {
         return SimpleDialog(
           title: Text("Ошибка авторизации"),
           children: <Widget>[
             SimpleDialogOption(
               onPressed: () {
                 Navigator.pop(context);
               },
               child: Center(child: Text('ОК')),
             ),
           ],
         );
       },
     );
   }

   static Future showErrorEventNotFoundDialog(BuildContext context, String text) {
     return showDialog(
       context: context,
       builder: (BuildContext context) {
         return SimpleDialog(
           title: Text(text),
           children: <Widget>[
             SimpleDialogOption(
               onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
               },
               child: Center(child: Text('ОК')),
             ),
           ],
         );
       },
     );
   }
}