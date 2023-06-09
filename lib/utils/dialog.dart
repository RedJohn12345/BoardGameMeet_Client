import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class DialogUtil {
  static Future showErrorDialog(BuildContext context, String text) async {
    await showDialog(
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

    // static Future showErrorUnauthorizedDialog(BuildContext context) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text("Ошибка авторизации"),
    //         children: <Widget>[
    //           SimpleDialogOption(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: Center(child: Text('ОК')),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    //
    // static Future showErrorEventNotFoundDialog(BuildContext context, String text) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text(text),
    //         children: <Widget>[
    //           SimpleDialogOption(
    //             onPressed: () {
    //               Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //             },
    //             child: Center(child: Text('ОК')),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    //
    // static Future showServerErrorDialog(BuildContext context, String text) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text(text),
    //         children: <Widget>[
    //           SimpleDialogOption(
    //             onPressed: () {
    //               Restart.restartApp();
    //             },
    //             child: Center(child: Text('ОК')),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    //
    // static Future showErrorPersonNotFoundDialog(BuildContext context, String text) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text(text),
    //         children: <Widget>[
    //           SimpleDialogOption(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: Center(child: Text('ОК')),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    //
    // static Future showErrorKickFromEventDialog(BuildContext context, String text) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text(text),
    //         children: <Widget>[
    //           SimpleDialogOption(
    //             onPressed: () async {
    //               Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //             },
    //             child: Center(child: Text('ОК')),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}