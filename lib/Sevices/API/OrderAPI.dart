import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/OrderDto.dart';
import '../../Model/updateOrderRequest.dart';
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


  static Future<List<Order>> fetchOrderHistory(int id, bool isPharmacist) async {
    // Determine the correct parameter key based on whether the user is a pharmacist or customer
    final String userType = isPharmacist ? 'pharmacistId' : 'customerId';

    // Build the URI with the correct query parameter
    final url = Uri.parse('$baseUrl/api/orders/history?$userType=$id');

    // Make the GET request with authorization headers
    final response = await http.get(
      url,
      headers: await AuthHeader.getAuthHeader(),
    );

    // Check for a successful response
    if (response.statusCode == 200) {
      // Decode the JSON response and map it to a list of Order objects
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      // Throw an exception if the request fails
      throw Exception('Failed to load order history');
    }
  }

  // Update order details (for pharmacists)
  static Future<void> updateOrder(int orderId,UpdateOrderRequest updateData) async {
    final url = Uri.parse('$baseUrl/api/orders/update/$orderId');
    final headers = await AuthHeader.getAuthHeader();
    headers['Content-Type'] = 'application/json';
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(updateData.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order');
    }
  }
}
