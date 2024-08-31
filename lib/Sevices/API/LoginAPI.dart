import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/LoginDto.dart';
import '../../Utills/Constant/api_constants.dart';

class LoginAPI {
  final String loginUrl = "$baseUrl/api/auth/signin";

  Future<http.Response> login(LoginDto loginDto) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': loginDto.username,
        'password': loginDto.password,
      }),
    );

    return response;

  }
}
