import 'package:http/http.dart' as http;
// For HTTP status codes

class RegNumberAPI {
  final String baseUrl = 'http://localhost:8080/api/checkRegNumber';

  Future<bool> checkRegNumber(String regNumber) async {
    // Create query parameters
    final queryParams = {
      'regNumber': regNumber,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.contentLength! > 0) {
      return true;
    } else {
      throw Exception('Failed to validate registration number. Status: ${response.statusCode}');
    }
  }
}
