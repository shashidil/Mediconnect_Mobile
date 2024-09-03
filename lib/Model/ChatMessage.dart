import 'ChatUser.dart';

class ChatMessage {
  final int id;
  final String content;
  final String timestamp;
  final ChatUser sender;
  final ChatUser receiver;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    required this.receiver,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      timestamp: json['timestamp'],
      sender: ChatUser.fromJson(json['sender']),
      receiver: ChatUser.fromJson(json['receiver']),
    );
  }

  int get senderId => sender.id;
  int get receiverId => receiver.id;
}
