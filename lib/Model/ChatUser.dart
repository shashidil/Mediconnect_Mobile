class ChatUser {
  final int id;
  final String name;

  ChatUser({required this.id, required this.name});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
    );
  }
}