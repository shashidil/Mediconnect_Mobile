import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/ResponseData.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class InvoiceAPI {
  static Future<String> sendInvoice(Map<String, dynamic> formData) async {
    final uri = Uri.parse('$baseUrl/api/invoices');

    // Get the authorization header with the JWT token
    final headers = await AuthHeader.getAuthHeader();
    headers['Content-Type'] = 'application/json'; // Add Content-Type to headers

    final body = jsonEncode(formData);

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to send invoice. Status: ${response.statusCode}');
    }
  }

  static Future<List<ResponseData>> fetchResponses(int userId) async {
    final uri = Uri.parse('$baseUrl/api/invoices/$userId');
    final headers = await AuthHeader.getAuthHeader();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => ResponseData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load responses');
    }
  }
}
