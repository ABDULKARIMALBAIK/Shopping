import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {

  static final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  static late BuildContext myContext;


  static void initNotification(BuildContext context){
    myContext = context;
    var initAndroid = AndroidInitializationSettings("..................");
    var initIos = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting = InitializationSettings(android: initAndroid , iOS: initIos);
    flutterLocalNotificationPlugin.initialize(initSetting,onSelectNotification: onSelectNotification);

  }

  static Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async{
    showDialog<void>(
      context: myContext,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {

        if(Platform.isAndroid){
          return AlertDialog(
            title: Text(title!),
            content: Text(body!),
            actions: <Widget>[
              FlatButton(
                child: Text('buttonText'),
                onPressed: () {
                  Navigator.of(context,rootNavigator: true).pop();
                },
              ),
            ],
          );
        }
        else{
          return CupertinoAlertDialog(
            title: Text(title!),
            content: Text(body!),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                  child: Text("OK"))
            ],

          );
        }

      },
    );
  }

  static Future onSelectNotification(String? payload) async{
    if(payload != null)
      print("Notification payload $payload");
  }
}