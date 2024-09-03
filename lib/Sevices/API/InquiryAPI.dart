import 'dart:convert';
import '../../Model/InquiryRequestDTO.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';
import 'package:http/http.dart' as http;

class InquiryAPI {

  static Future<bool> createInquiry(InquiryRequestDTO inquiryRequest) async {
    final url = Uri.parse('$baseUrl/api/inquiries/create');
    final headers = await AuthHeader.getAuthHeader();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        ...headers,
      },
      body: jsonEncode(inquiryRequest.toJson()),
    );

    return response.statusCode == 200;
  }
}