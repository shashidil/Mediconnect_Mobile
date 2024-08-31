import 'UserDTO.dart';

class PrescriptionDTO {
  final int id;
  final String fileName;
  final String filePath;
  final UserDTO user;
  final String imageData;

  PrescriptionDTO({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.user,
    required this.imageData,
  });

  factory PrescriptionDTO.fromJson(Map<String, dynamic> json) {
    return PrescriptionDTO(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      user: UserDTO.fromJson(json['user']),
      imageData: json['imageData'],
    );
  }
}