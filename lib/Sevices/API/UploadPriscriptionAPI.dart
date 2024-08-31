
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import '../../Utills/Constant/api_constants.dart';
import '../Auth/AuthHeader.dart';

class UploadPrescriptionAPI {

  Future<String> uploadPrescription(File file, int userId, List<int> pharmacistIds) async {
    final uri = Uri.parse('$baseUrl/api/medicine-requests/uploadPrescription/$userId');

    var request = http.MultipartRequest('POST', uri)
      ..fields['pharmacistIds'] = jsonEncode(pharmacistIds) // Convert pharmacistIds to JSON
      ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(lookupMimeType(file.path)!)
      ));

    final headers = await AuthHeader.getAuthHeader();
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      return "File uploaded successfully";
    } else {
      throw Exception('Failed to upload file. Status: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPrescriptions(int pharmacistId) async {
    final uri = Uri.parse('$baseUrl/api/medicine-requests/$pharmacistId');

    final headers = await AuthHeader.getAuthHeader(); // Get the authorization header with JWT token

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch prescriptions. Status: ${response.statusCode}');
    }
  }


}
