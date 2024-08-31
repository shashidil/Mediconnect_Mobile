class PharmacistSignupDto{

  final String username;
  final String email;
  final String password;
  final String pharmacyName;
  final String regNumber;
  final String addressLine1;
  final String city;
  final String states;
  final String postalCode;
  final Set<String> role; // Default role as "Pharmacist"

  // Constructor with required parameters
  PharmacistSignupDto({
  required this.username,
  required this.email,
  required this.password,
  required this.pharmacyName,
  required this.regNumber,
  required this.addressLine1,
  required this.city,
  required this.states,
  required this.postalCode,
  this.role = const {"Pharmacist"}, // Set default role to "Pharmacist"
  });

  // Factory method for creating a Pharmacist instance from JSON
  factory PharmacistSignupDto.fromJson(Map<String, dynamic> json) {
  return PharmacistSignupDto(
  username: json['username'],
  email: json['email'],
  password: json['password'],
  pharmacyName: json['pharmacyName'],
  regNumber: json['regNumber'],
  addressLine1: json['addressLine1'],
  city: json['city'],
  states: json['states'],
  postalCode: json['postalCode'],
  role: Set<String>.from(json['role'] ?? ["Pharmacist"]), // Handle role
  );
  }

  // Convert a Pharmacist instance to JSON
  Map<String, dynamic> toJson() {
  return {
  'username': username,
  'email': email,
  'password': password,
  'pharmacyName': pharmacyName,
  'regNumber': regNumber,
  'addressLine1': addressLine1,
  'city': city,
  'states': states,
  'postalCode': postalCode,
  'role': role.toList(), // Convert Set to List for JSON serialization
  };
  }
  }

