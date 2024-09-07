import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/API/ChatAPI.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';
import '../Model/ChatUser.dart';
import '../Sevices/ChatService.dart';
import 'ChatScreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();
  final List<ChatUser> _chats = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    setState(() {
      _loading = true;
    });

    try {
      final userIdString = await UserSession.getUserId();
      if (userIdString == null || userIdString.isEmpty) {
        throw Exception('User ID is null or empty');
      }

      final userId = int.parse(userIdString);
      print(userId);

      if (userId == 0) {
        throw Exception('Invalid User ID');
      }

      final chats = await ChatAPI.fetchChats(userId);

      setState(() {
        _chats.addAll(chats);
        _loading = false;
      });
    } catch (e) {
      print('Error loading chats: $e');
      setState(() {
        _loading = false;
      });
      // Optionally show an error message to the user
    }
  }

  void _openChat(ChatUser chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: chat.id, receiverName: chat.name),
      ),
    ).then((_) {
      _chatService.disconnect(); // Disconnect WebSocket when ChatScreen is closed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    chat.name[0], // Display the first letter of the name
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  chat.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () => _openChat(chat),
              ),
            ),
          );
        },
      ),
    );
  }
}
