class UserDetailsDto {
  final String? username;
  final String? email;
  final String? addressLine1;
  final String? city;
  final String? states;
  final String? postalCode;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? pharmacyName;
  final String? role;

  UserDetailsDto({
    this.username,
    this.email,
    this.addressLine1,
    this.city,
    this.states,
    this.postalCode,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.pharmacyName,
    this.role,
  });

  factory UserDetailsDto.fromJson(Map<String, dynamic> json) {
    return UserDetailsDto(
      username: json['username'],
      email: json['email'],
      addressLine1: json['addressLine1'],
      city: json['city'],
      states: json['states'],
      postalCode: json['postalCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      pharmacyName: json['pharmacyName'],
      role: json['role'],
    );
  }

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
      'role': role,
    };
  }
}