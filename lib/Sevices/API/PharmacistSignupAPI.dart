import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medi_connect/Model/SignupDto.dart';
import '../../Utills/Constant/api_constants.dart';

class PharmacistSignupAPI {
  final String signupUrl = "$baseUrl/api/auth/signup"; // Common signup endpoint

  Future<http.Response> signup(SignupDto signupDto) async {
    final response = await http.post(
      Uri.parse(signupUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(signupDto.toJson()), // Convert SignupDto to JSON
    );

    return response; // Return response for handling
  }
}
