import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../Model/ChatMessage.dart';

class ChatService {
  StompClient? _stompClient;
  Function(ChatMessage)? _onMessageReceivedCallback;

  // // Initialize the FlutterLocalNotificationsPlugin
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  // ChatService() {
  //   // Initialization settings for local notifications
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   final InitializationSettings initializationSettings =
  //   InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: DarwinInitializationSettings());
  //
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  void connect(Function(ChatMessage) onMessageReceived) {
    _onMessageReceivedCallback = onMessageReceived;

    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://localhost:8080/ws', // Change this to your actual server URL
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
      ),
    );

    _stompClient?.activate();
  }

  void _onConnect(StompFrame frame) {
    // Subscription for private messages
    _stompClient?.subscribe(
      destination: '/user/queue/private-messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final data = json.decode(frame.body!);
          final message = ChatMessage.fromJson(data);
          if (_onMessageReceivedCallback != null) {
            _onMessageReceivedCallback!(message);
          }
        }
      },
    );

    // // Subscription for notifications
    // _stompClient?.subscribe(
    //   destination: '/user/queue/notifications',
    //   callback: (StompFrame frame) {
    //     if (frame.body != null) {
    //       final data = json.decode(frame.body!);
    //       _showLocalNotification(data['title'], data['content']);
    //     }
    //   },
    // );
  }

  void sendMessage(String content, int senderId, int receiverId) {
    final message = {
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
    };
    _stompClient?.send(
      destination: '/app/chat.sendMessage',
      body: json.encode(message),
    );
  }

  // void _showLocalNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //       'your_channel_id', 'your_channel_name',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker');
  //
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //       0, title, body, platformChannelSpecifics,
  //       payload: 'notification_payload');
  // }

  void disconnect() {
    _stompClient?.deactivate();
  }
}