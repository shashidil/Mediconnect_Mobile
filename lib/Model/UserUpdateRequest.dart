class UserUpdateRequest {
  final String username;
  final String email;
  final String addressLine1;
  final String city;
  final String states;
  final String postalCode;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? pharmacyName;

  UserUpdateRequest({
    required this.username,
    required this.email,
    required this.addressLine1,
    required this.city,
    required this.states,
    required this.postalCode,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.pharmacyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'addressLine1': addressLine1,
      'city': city,
      'states': states,
      'postalCode': postalCode,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'pharmacyName': pharmacyName,
    };
  }
}
