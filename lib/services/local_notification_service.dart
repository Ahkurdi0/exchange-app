import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<LocalPushNotificationService> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    InitializationSettings? initializationSettings;
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      initializationSettings = const InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: DarwinInitializationSettings(),
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(notificationChannelMax());
    } else {
      initializationSettings = const InitializationSettings(
        // android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings(),
      );
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
            'did receive local notification response ${details.toString()}');
      },
    );

    return this;
  }

  AndroidNotificationChannel notificationChannelMax() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications', // title
      importance: Importance.max,
      description: 'This channel is used for important notifications.',
    );
    return channel;
  }

  void showNotification(ReceivedNotification notificationModel) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1001',
      'Exchange Request',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      channelShowBadge: true,
      color: Colors.blue,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    flutterLocalNotificationsPlugin.show(
      notificationModel.id,
      notificationModel.title,
      notificationModel.body,
      platformChannelSpecifics,
      payload: notificationModel.payload,
    );
  }
}

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? imageUrl;
  final String? payload;
  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.imageUrl,
    this.payload,
  });

  ReceivedNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? imageUrl,
    String? payload,
  }) {
    return ReceivedNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (title != null) {
      result.addAll({'title': title});
    }
    if (body != null) {
      result.addAll({'body': body});
    }
    if (imageUrl != null) {
      result.addAll({'imageUrl': imageUrl});
    }
    if (payload != null) {
      result.addAll({'payload': payload});
    }

    return result;
  }

  factory ReceivedNotification.fromMap(Map<String, dynamic> map) {
    return ReceivedNotification(
      id: map['id']?.toInt() ?? 0,
      title: map['title'],
      body: map['body'],
      imageUrl: map['imageUrl'],
      payload: map['payload'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceivedNotification.fromJson(String source) =>
      ReceivedNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RecivedNotification(id: $id, title: $title, body: $body, imageUrl: $imageUrl, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReceivedNotification &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.imageUrl == imageUrl &&
        other.payload == payload;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        imageUrl.hashCode ^
        payload.hashCode;
  }
}
