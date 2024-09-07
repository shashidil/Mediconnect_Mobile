import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../Model/ChatMessage.dart';

class ChatService {
  StompClient? _stompClient;
  Function(ChatMessage)? _onMessageReceivedCallback;


  void connect(Function(ChatMessage) onMessageReceived) {
    _onMessageReceivedCallback = onMessageReceived;

    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://192.168.0.103:8080/ws', // Change this to your actual server URL
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


  void disconnect() {
    _stompClient?.deactivate();
  }
}
