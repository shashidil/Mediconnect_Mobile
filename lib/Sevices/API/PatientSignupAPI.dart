import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/SignupDto.dart';
import '../../Utills/Constant/api_constants.dart';


class SignupAPI {
  final String patientSignupUrl = "$baseUrl/api/auth/signup"; // Sign-up endpoint for patients

  Future<http.Response> signupPatient(SignupDto signupDto) async {
    final response = await http.post(
      Uri.parse(patientSignupUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(signupDto.toJson()), // Convert DTO to JSON

    );

    return response; // Return the response for handling
  }
}
