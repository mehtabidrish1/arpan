// import 'dart:async';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class ArpanNotification {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     final initializationSettings = InitializationSettings(
//         android: AndroidInitializationSettings('@drawable/logo'),
//         iOS: DarwinInitializationSettings(
//             onDidReceiveLocalNotification: onDidReceiveLocalNotification));

//     _notificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> displayNotification(String title, String body) async {
//     /*  try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       final notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription:'This channel is used for important notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );

//       await _notificationsPlugin.show(
//         id,
//         title,
//        body,
//         notificationDetails,
//       );
//     } on Exception catch (e) {
//       print(e);
//     }*/
//   }
//   void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//   }
// }
