import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medi_connect/Sevices/Auth/AuthHeader.dart';

import '../../Model/MostSoldMedicineDTO.dart';
import '../../Model/OrderQuantityByMonthDTO.dart';
import '../../Utills/Constant/api_constants.dart';

class ReportAPI {


  Future<List<MostSoldMedicineDTO>> fetchTop5Medicines() async {
    final url = Uri.parse('$baseUrl/api/reports/top-medicines/month');
    final headers = await AuthHeader.getAuthHeader();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MostSoldMedicineDTO.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load top 5 medicines');
    }
  }

  Future<List<OrderQuantityByMonthDTO>> fetchOrderQuantitiesByLast12Months() async {
    final url = Uri.parse('$baseUrl/api/reports/order-quantities-month');
    final headers = await AuthHeader.getAuthHeader();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => OrderQuantityByMonthDTO.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load order quantities');
    }
  }
}




