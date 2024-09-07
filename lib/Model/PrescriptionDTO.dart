import 'UserDTO.dart';

class PrescriptionDTO {
  final int id;
  final String? fileName; // Nullable
  final String? filePath; // Nullable
  final UserDTO user;
  final String? medicationName; // Nullable
  final int? medicationQuantity; // Nullable
  final String? imageData; // Nullable

  PrescriptionDTO({
    required this.id,
    this.fileName,
    this.filePath,
    required this.user,
    this.medicationName,
    this.medicationQuantity,
    this.imageData,
  });

  factory PrescriptionDTO.fromJson(Map<String, dynamic> json) {
    return PrescriptionDTO(
      id: json['id'],
      fileName: json['fileName'], // Can be null
      filePath: json['filePath'], // Can be null
      user: UserDTO.fromJson(json['user']),
      medicationName: json['medicationName'], // Can be null
      medicationQuantity: json['medicationQuantity'], // Can be null
      imageData: json['imageData'], // Can be null
    );
  }
}
