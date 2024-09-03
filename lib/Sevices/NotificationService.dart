import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medi_connect/Utills/Constant/api_constants.dart';

import 'Auth/AuthHeader.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request notification permissions (iOS only)
    await _firebaseMessaging.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Handle background and terminated notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Get the FCM token for this device
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Send the token to your backend
    await sendTokenToServer(token, "USER_ID_HERE"); // Replace with actual user ID

    // Listen for token refresh and update the backend with the new token
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("FCM Token refreshed: $newToken");
      sendTokenToServer(newToken, "USER_ID_HERE"); // Replace with actual user ID
    });
  }

  Future<void> sendTokenToServer(String? token, String userId) async {
    if (token != null) {
      final headers = await AuthHeader.getAuthHeader();
      final response = await http.post(
        Uri.parse('$baseUrl/api/userfcmtoken/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers,
        },
        body: jsonEncode({'fcmToken': token}),
      );

      if (response.statusCode == 200) {
        print('Token sent to server successfully.');
      } else {
        print('Failed to send token to server. Status code: ${response.statusCode}');
      }
    }
  }

  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['reminderTime'], // Pass additional data as payload
    );
  }

  void _handleMessage(RemoteMessage message) {
    // Handle the message when the app is opened from a notification
    if (message.data.containsKey('reminderTime')) {
      // Handle the reminderTime, for example, navigate to a specific screen
      print('Reminder Time: ${message.data['reminderTime']}');
    }
  }
}
