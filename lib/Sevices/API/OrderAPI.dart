import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/OrderDto.dart';
import '../../Model/updateOrderRequest.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class OrderAPI {
  static Future<Map<String, dynamic>> processOrderPayment(
      int Id, String orderNumber, int? pharmacistId, int customerId, String paymentMethod, double? total) async {
    final url = Uri.parse('$baseUrl/api/orders/process-payment');

    final headers = await AuthHeader.getAuthHeader();
    headers['Content-Type'] = 'application/json';
    final body = jsonEncode({
      'invoiceId': Id,
      'orderNumber': orderNumber,
      'pharmacistId': pharmacistId,
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'amount': total,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process payment');
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      int invoiceId, double? total) async {
    final url = Uri.parse('$baseUrl/api/orders/create-payment-intent');

    final headers = await AuthHeader.getAuthHeader();

    final header = {
      'Content-Type': 'application/json',
      ...headers,
    };
    final body = jsonEncode({
      'amount': total != null ? (total * 100).toInt() : 0, // Stripe expects amounts in cents
    });

    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // This should contain the client_secret and other data
    } else {
      throw Exception('Failed to create payment intent');
    }
  }

  static Future<List<Order>> fetchOrderHistory(int id, bool isPharmacist) async {
    final String userType = isPharmacist ? 'pharmacistId' : 'customerId';
    final url = Uri.parse('$baseUrl/api/orders/history?$userType=$id');
    final response = await http.get(
      url,
      headers: await AuthHeader.getAuthHeader(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
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
