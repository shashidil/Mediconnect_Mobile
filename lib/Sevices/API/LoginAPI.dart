import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/LoginDto.dart';
import '../../Model/UserDetailsDto.dart';
import '../../Model/UserUpdateRequest.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

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

  Future<UserDetailsDto> getUserDetails(String userId) async {
    final uri = Uri.parse('$baseUrl/api/auth/$userId');
    final headers = await AuthHeader.getAuthHeader();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return UserDetailsDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Future<bool> updateUser(String userId, UserUpdateRequest updateRequest) async {
    final uri = Uri.parse('$baseUrl/api/auth/$userId');

    final authHeaders = await AuthHeader.getAuthHeader();

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      ...authHeaders,
    };

    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(updateRequest.toJson()),
    );

    return response.statusCode == 200;
  }



}
