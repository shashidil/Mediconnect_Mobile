import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/ChatMessage.dart';
import '../../Model/ChatUser.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class ChatAPI{
  static Future<List<ChatUser>> fetchChats(int userId) async {
    final uri = Uri.parse('$baseUrl/api/chats?userId=$userId');
    final headers = await AuthHeader.getAuthHeader();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<List<ChatMessage>> fetchMessages(int senderId, int receiverId) async {
    final uri = Uri.parse('$baseUrl/api/chats/messages?senderId=$senderId&receiverId=$receiverId');
    final headers = await AuthHeader.getAuthHeader();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }


}


