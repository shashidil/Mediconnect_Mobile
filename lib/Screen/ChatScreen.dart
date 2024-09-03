import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/API/ChatAPI.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';

import '../Model/ChatMessage.dart';
import '../Model/ChatUser.dart';
import '../Sevices/ChatService.dart';


class ChatScreen extends StatefulWidget {
  final int? receiverId;
  final String? receiverName;

  ChatScreen({required this.receiverId, required this.receiverName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [];
  late int senderId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      senderId = int.parse(await UserSession.getUserId() ?? '0');
      if (senderId == 0) {
        throw Exception('Invalid sender ID');
      }
      _chatService.connect((ChatMessage message) {
        if (message.senderId == widget.receiverId || message.receiverId == widget.receiverId) {
          setState(() {
            _messages.add(message);
          });
        }
      });
      if (widget.receiverId != null) {
        _loadMessages(widget.receiverId!);
      }
    } catch (e) {
      print('Error initializing chat: $e');
      // Optionally show an error message to the user
    }
  }

  void _loadMessages(int receiverId) async {
    try {
      final messages = await ChatAPI.fetchMessages(senderId, receiverId);
      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  void _sendMessage() {
    if (widget.receiverId != null) {
      String messageContent = _controller.text;
      int receiverId = widget.receiverId!;

      _chatService.sendMessage(messageContent, senderId, receiverId);
      setState(() {
        _messages.add(ChatMessage(
          id: _messages.length + 1, // Temporary ID, replace with actual ID from backend
          content: messageContent,
          timestamp: DateTime.now().toString(),
          sender: ChatUser(id: senderId, name: 'You'),
          receiver: ChatUser(id: receiverId, name: widget.receiverName!),
        ));
        _controller.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No recipient selected for this message.')),
      );
    }
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    widget.receiverName![0],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Chat with ${widget.receiverName}',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == senderId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.content,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          message.timestamp,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 10)],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                    backgroundColor: Colors.blue,
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

