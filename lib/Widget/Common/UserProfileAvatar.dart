import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  final VoidCallback onTap; // Callback when the avatar is tapped

  const UserProfileAvatar({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade200, // Optional background color
        child: Icon(
          Icons.person, // Use a Flutter icon for the avatar
          size: 30, // Adjust size as needed
          color: Colors.grey.shade600, // Icon color
        ),
      ),
    );
  }
}
