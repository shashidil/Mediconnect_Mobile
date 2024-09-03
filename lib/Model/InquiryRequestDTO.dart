

class InquiryRequestDTO {
  final String subject;
  final String message;
  final String status;
  final int senderId;

  InquiryRequestDTO({
    required this.subject,
    required this.message,
    required this.status,
    required this.senderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
      'status': status,
      'senderId': senderId,
    };
  }
}


