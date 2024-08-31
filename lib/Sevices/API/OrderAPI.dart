import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class OrderAPI {
  static Future<Map<String, dynamic>> processOrderPayment(
      int invoiceId, String orderNumber, int pharmacistId, int customerId, String paymentMethod, double? total, String paymentMethodId) async {
    final url = Uri.parse('$baseUrl/api/orders/process-payment');

    final headers = await AuthHeader.getAuthHeader();
    final body = jsonEncode({
      'invoiceId': invoiceId,
      'orderNumber': orderNumber,
      'pharmacistId': pharmacistId,
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'total': total,
      'paymentMethodId': paymentMethodId,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process payment');
    }
  }
}
