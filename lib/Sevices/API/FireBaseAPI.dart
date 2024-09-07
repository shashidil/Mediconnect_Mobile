import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medi_connect/Sevices/API/LoginAPI.dart';


class FireBaseAPI {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications and background message handler
  Future<void> initNotification() async {
    // Request notification permissions (this is required for iOS and recommended for Android)
    await FirebaseMessaging.instance.requestPermission();

    // Get the FCM token and save it to the backend
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null) {
    //   await LoginAPI().saveTokenToBackend();  // Save the token if required
    // }

    // Register the background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Initialize local notifications for displaying notifications in the foreground
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        // Handle notification tap when the app is terminated
        print("Notification clicked when app is terminated");
        // You can add additional logic here to navigate to specific screens based on the notification payload
      },
    );

    // Create a default notification channel for Android
    const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
      'default_channel_id',   // ID specified in AndroidManifest.xml
      'Default Notifications',  // Name for the channel
      importance: Importance.max,  // Max importance for important notifications
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    print('Notification channel created');
  }


  // Handle background messages (called when the app is in the background or terminated)
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // Custom logic to handle background notifications
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    Map<String, dynamic> data = message.data;

    // You can implement logic here to handle the notification data
    // For example: store it locally, update UI, trigger actions based on payload data
    await processNotification(title, body, data);
  }

  // Process the notification data (can update UI, show dialogs, etc.)
  Future<void> processNotification(String? title, String? body, Map<String, dynamic> data) async {
    // Custom logic to process notification
    // Example: store the notification in the local database or display a dialog
    if (title != null && body != null) {
      // Add your custom notification handling logic here (e.g., storing in database)
      // Example: print for demonstration (remove in production)
      print('Processing Notification - Title: $title, Body: $body, Data: $data');
    }
  }

  // Function to show a notification when the app is in the foreground
  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel_id',  // Same channel ID as created earlier
      'Default Notifications',  // Channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,  // Notification ID
      message.notification?.title,  // Notification title
      message.notification?.body,  // Notification body
      platformChannelSpecifics,
      payload: 'data',  // Additional data if required
    );
  }

}
