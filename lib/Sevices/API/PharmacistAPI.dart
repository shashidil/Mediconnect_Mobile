import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class PharmacistAPI {


  // Get pharmacist data by state
  Future<List<Map<String, dynamic>>> getPharmacistsByState(String state) async {
    final uri = Uri.parse('$baseUrl/api/pharmacists/state/$state'); // Endpoint for pharmacists by state

    // Get the authentication header
    final headers = await AuthHeader.getAuthHeader();

    final response = await http.get(uri, headers: headers); // Include the headers with the token

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList(); // Convert to list of maps
    } else {
      throw Exception('Failed to fetch pharmacists by state. Status: ${response.statusCode}');
    }
  }

  // Get pharmacist data by city
  Future<List<Map<String, dynamic>>> getPharmacistsByCity(String city) async {
    final uri = Uri.parse('$baseUrl/api/pharmacists/city/$city'); // Endpoint for pharmacists by city

    final headers = await AuthHeader.getAuthHeader();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList(); // Convert to list of maps
    } else {
      throw Exception('Failed to fetch pharmacists by city. Status: ${response.statusCode}');
    }
  }
}
