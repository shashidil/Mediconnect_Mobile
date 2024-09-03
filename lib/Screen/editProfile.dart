import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // Load user data from backend or local storage
    // and set it to the controllers. For now, we'll
    // use placeholder data.
    _fullNameController.text = "Parves Ahamad";
    _genderController.text = "Male";
    _birthdayController.text = "05-01-2001";
    _phoneNumberController.text = "(+880) 1759263000";
    _emailController.text = "nirobparvesahammad@gmail.com";
    _usernameController.text = "@parvesahamad";
  }

  void _saveProfile() {
    // Save the updated profile information
    // Typically involves making an API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved successfully')),
    );
  }

  void _changePassword() {
    // Navigate to the change password screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to change password screen')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with user's image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: () {
                        // Implement image change functionality
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Full Name
            Text(
              _fullNameController.text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              _usernameController.text,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Divider(height: 30),
            // Form Fields
            _buildTextField(_fullNameController, 'Full name', Icons.person),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_genderController, 'Gender', Icons.person_outline),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(_birthdayController, 'Birthday', Icons.calendar_today),
                ),
              ],
            ),
            _buildTextField(_phoneNumberController, 'Phone number', Icons.phone),
            _buildTextField(_emailController, 'Email', Icons.email),
            _buildTextField(_usernameController, 'Username', Icons.account_circle),
            SizedBox(height: 20),
            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue, backgroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            // Change Password Button
            TextButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: EditProfilePage(userId: '123'), // Replace with the actual user ID
));
