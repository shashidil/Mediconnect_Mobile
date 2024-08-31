class PatientSignupDto {
  final String username;
  final String lastName;
  final String firstName;
  final String email;
  final String password;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String states;
  final String postalCode;
  final Set<String> role; // Set the default role to "Patient"

  // Constructor
  PatientSignupDto({
    required this.username,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.addressLine1,
    required this.city,
    required this.states,
    required this.postalCode,
    this.role = const {"customer"}, // Default role
  });

  // Factory method for creating a Patient instance from a JSON map
  factory PatientSignupDto.fromJson(Map<String, dynamic> json) {
    return PatientSignupDto(
      username: json['username'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      addressLine1: json['addressLine1'],
      city: json['city'],
      states: json['states'],
      postalCode: json['postalCode'],
      role: Set<String>.from(json['role'] ?? ["customer"]), // Handle role
    );
  }

  // Convert a Patient instance to a JSON map (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'city': city,
      'states': states,
      'postalCode': postalCode,
      'role': role.toList(), // Convert Set to List for JSON
    };
  }
}
