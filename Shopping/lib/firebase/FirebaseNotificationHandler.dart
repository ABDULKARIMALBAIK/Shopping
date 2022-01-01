

import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shopping_app/firebase/NotificationHandler.dart';

class FirebaseNotification{

  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  void setupFirebase(BuildContext context){

    myContext = context;
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessagingListener(context);
  }

  void firebaseCloudMessagingListener(BuildContext context) async{

    //Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    print('settings: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    _messaging.getToken().then((token) => print('Token: $token'));


    //For background messages

    //For foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      //Check Notification for Android/IOS OS
      if(Platform.isAndroid){
        showNotification(message.data['title'] , message.data['body']);
      }
      else if(Platform.isIOS){
        showNotification(message.notification!.title , message.notification!.body);
      }

    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context){
            if(Platform.isAndroid){
              return AlertDialog(
                title: Text(remoteMessage.notification!.title.toString()),
                content: Text(remoteMessage.notification!.body.toString()),
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
                title: Text(remoteMessage.notification!.title.toString()),
                content: Text(remoteMessage.notification!.body.toString()),
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
          }

      );
    });

  }

  void showNotification(title, content) async{  //com.abdulkarimalbaik.flutter_shopping_app
    
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.abdulkarimalbaik.flutter_shopping_app',
      'Flutter Shopping App',
      'Description',
      autoCancel: false,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high);

    var iosPlatformSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics , iOS: iosPlatformSpecifics);

    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000),
        title,
        content,
        platformChannelSpecifics,
        payload: 'Payload');
  }

 }