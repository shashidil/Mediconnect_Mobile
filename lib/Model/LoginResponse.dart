class LoginResponse {
  final int id;
  final String username;
  final String email;
  final List<String> roles;
  final String type;
  final String token;

  // Constructor
  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.type,
    required this.token,
  });

  // Factory method to create an instance from a map (for JSON parsing)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: List<String>.from(json['roles']), // Convert list to List<String>
      type: json['type'],
      token: json['token'],
    );
  }

  // Method to convert instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
      'type': type,
      'token': token,
    };
  }
}
