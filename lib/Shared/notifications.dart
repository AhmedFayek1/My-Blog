import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import 'package:http/http.dart' as http;

class MyNotifications
{
  BuildContext context;
  MyNotifications({required this.context});

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted Provisional Permission");
    } else {
      print("User declined or has no accepted Permission");
    }
  }

  void sendPushNotification(List<dynamic> users, String title, String body)
  {
    users.forEach((user) {
      pushNotification(BlogAppCubit.get(context).getUser(user)!.token!, title, body);
    });
  }

  void pushNotification(String token, String title, String body) async {
    getRequest();
    requestPermission();
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=AAAA397fxxk:APA91bG2d_GmsdIth1aNSmOlmOisYk94PBCwKt9Urjff4ylkmix-dtGzX6VsDCqLwCPtcZg_Z3jNWsXG8J_lkeNLnOK1QWoFYgZUYCxVDfuV9ivw1h1P4kj77LYX6fbsvzq3H43ySWSi',
        // Replace with your FCM server key
      };

      final data = <String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'body': body,
          'title': title,
        },
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
          'android_channel_id': 'dbfood', // Replace with your channel ID
        },
        'to': token,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification. Error: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void getRequest() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androidInitialice =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: androidInitialice);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          try {
            if (response.payload != null && response.payload!.isNotEmpty) {
            } else {}
          } catch (e)
          {}
          return;
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("ON MESSAGE");
      print(
          "onMessage: ${message.notification!.title}/${message.notification!.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('dbfood', 'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }
}
