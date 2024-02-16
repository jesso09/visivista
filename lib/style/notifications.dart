import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'team_notification', // id
      'Team Notification', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: jsonEncode(message.toMap()),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            //      one that already exists in example app.
            icon: 'mipmap/logo',
          ),
        ),
      );
    }
  }

  initPushNotification() {
    firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  initNotification() async {
      final fcmToken = await firebaseMessaging.getToken();
      GlobalItem.deviceToken = fcmToken;
      await firebaseMessaging.requestPermission();
      // print("Token : $fcmToken");
      await setupFlutterNotifications();
      initLocalNotifications();
      initPushNotification();
  }

  Future<void> initLocalNotifications() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('mipmap/logo'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // print("notificationResponse : ${notificationResponse.payload}");
      },
    );
  }
}

//Local Notification
class NotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/logo');
    var initializeSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "VisiVista System",
      priority: Priority.high,
      importance: Importance.max,
    );

    var not = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, not);
  }

  static Future showInvitationNotification(
      {required String inviterName,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "invitationChannelId",
      "Invitation Channel",
      priority: Priority.high,
      importance: Importance.max,
    );

    var not = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Menampilkan notifikasi untuk undangan
    await flutterLocalNotificationsPlugin.show(
        5, 'Undangan Tim', '$inviterName mengundang Anda ke dalam tim.', not);
  }

  static Future<void> scheduleNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    List<Task> tasks,
    int jumlahTask,
    DateTime notificationTime,
  ) async {
    // Inisialisasi timezone
    tz.initializeTimeZones();

    for (final Task task in tasks) {
      if (isSameDay(task.end, notificationTime)) {
        // Konversi DateTime ke TZDateTime
        tz.TZDateTime scheduledDate =
            tz.TZDateTime.from(notificationTime, tz.local);

        // Cek apakah scheduledDate sudah di masa depan
        if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.zonedSchedule(
          3,
          'VisiVista',
          'Anda memiliki $jumlahTask tugas yang berakhir hari ini',
          scheduledDate,
          platformChannelSpecifics,
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  static Future<void> contentNotif(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    List<Content> contents,
    int jumlahContent,
    DateTime notificationTime,
  ) async {
    // Inisialisasi timezone
    tz.initializeTimeZones();

    for (final Content item in contents) {
      if (isSameDay(item.postScheduled, notificationTime)) {
        // Konversi DateTime ke TZDateTime
        tz.TZDateTime scheduledDate =
            tz.TZDateTime.from(notificationTime, tz.local);

        // Cek apakah scheduledDate sudah di masa depan
        if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'content_channel',
          'Content Notifications',
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
        );
        if (jumlahContent == 1) {
          String formattedTime =
              DateFormat('HH:mm').format(item.postScheduled ?? DateTime.now());
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            4,
            'Upload Konten Hari Ini',
            'Konten ${item.title} akan diupload hari ini pada $formattedTime',
            scheduledDate,
            platformChannelSpecifics,
            // ignore: deprecated_member_use
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } else if (jumlahContent > 1) {
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            4,
            'Upload Konten Hari Ini',
            '${item.title}, dan ${jumlahContent - 1} konten lainnya akan diupload hari ini',
            scheduledDate,
            platformChannelSpecifics,
            // ignore: deprecated_member_use
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    }
  }
}
