class UserDTO {
  final int id;
  final String name;
  final String email;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}