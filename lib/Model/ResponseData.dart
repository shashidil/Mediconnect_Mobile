import 'Medication.dart';

class ResponseData {
  final int id;
  final String pharmacistName;  // Nullable String
  final String invoiceNumber;    // Nullable String
  final List<Medication> medications;
  final double distance;
  final double? total;            // Nullable Double
  final int? pharmacistId;        // Nullable Integer
  final int prescriptionId;        // Nullable Integer
  final double pharmacistLatitude;
  final double pharmacistLongitude;
  final double customerLatitude;
  final double customerLongitude;

  ResponseData({
    required this.id,
    required this.pharmacistName,  // Nullable
    required this.invoiceNumber,   // Nullable
    required this.medications,
    required this.distance,
    this.total,           // Nullable
    this.pharmacistId,    // Nullable
    required this.prescriptionId,    // Nullable
    required this.pharmacistLatitude,
    required this.pharmacistLongitude,
    required this.customerLatitude,
    required this.customerLongitude,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    print('Parsing ResponseData: $json'); // Debugging print statement

    return ResponseData(
      id: json['id'],
      pharmacistName: json['pharmacistName'] ,  // Cast to nullable String
      invoiceNumber: json['invoiceNumber'],    // Cast to nullable String
      medications: (json['medications'] as List)
          .map((med) => Medication.fromJson(med))
          .toList(),
      distance: json['distance'].toDouble(),
      total: json['total']?.toDouble(),  // Nullable Double
      pharmacistId: json['pharmacistId'] as int?, // Nullable Integer
      prescriptionId: json['prescriptionId'] , // Nullable Integer
      pharmacistLatitude: json['pharmacistLatitude'].toDouble(),
      pharmacistLongitude: json['pharmacistLongitude'].toDouble(),
      customerLatitude: json['customerLatitude'].toDouble(),
      customerLongitude: json['customerLongitude'].toDouble(),
    );
  }
}
