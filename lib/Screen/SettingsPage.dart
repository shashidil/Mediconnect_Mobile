import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/API/LoginAPI.dart';
import '../Model/UserDetailsDto.dart';
import '../Model/UserUpdateRequest.dart';
import '../Widget/WidgetHelpers.dart';

class SettingsPage extends StatefulWidget {
  final String userId;

  SettingsPage({required this.userId});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<UserDetailsDto> userDetails;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _statesController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pharmacyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userDetails = LoginAPI().getUserDetails(widget.userId);
    userDetails.then((details) {
      _usernameController.text = details.username ?? '';
      _emailController.text = details.email ?? '';
      _addressLine1Controller.text = details.addressLine1 ?? '';
      _cityController.text = details.city ?? '';
      _statesController.text = details.states ?? '';
      _postalCodeController.text = details.postalCode ?? '';
      _firstNameController.text = details.firstName ?? '';
      _lastNameController.text = details.lastName ?? '';
      _phoneNumberController.text = details.phoneNumber ?? '';
      _pharmacyNameController.text = details.pharmacyName ?? '';
    });
  }

  void _updateUser() {
    if (_formKey.currentState?.validate() ?? false) {
      UserUpdateRequest updateRequest = UserUpdateRequest(
        username: _usernameController.text,
        email: _emailController.text,
        addressLine1: _addressLine1Controller.text,
        city: _cityController.text,
        states: _statesController.text,
        postalCode: _postalCodeController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        pharmacyName: _pharmacyNameController.text,
      );

      LoginAPI().updateUser(widget.userId, updateRequest).then((response) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response ? 'User updated successfully' : 'Failed to update user'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<UserDetailsDto>(
        future: userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            UserDetailsDto userDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    Text(
                      _usernameController.text,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Divider(height: 30),

                    WidgetHelpers.buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _addressLine1Controller,
                      label: 'Address Line 1',
                      icon: Icons.home,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: Icons.location_city,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _statesController,
                      label: 'State',
                      icon: Icons.map,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      icon: Icons.mail_outline,
                    ),

                    if (userDetails.role == 'Patient') ...[
                      WidgetHelpers.buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person_outline,
                      ),
                      WidgetHelpers.buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person_outline,
                      ),
                      WidgetHelpers.buildTextField(
                        controller: _phoneNumberController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                      ),
                    ],

                    if (userDetails.role == 'Pharmacist') ...[
                      WidgetHelpers.buildTextField(
                        controller: _pharmacyNameController,
                        label: 'Pharmacy Name',
                        icon: Icons.local_pharmacy,
                      ),
                    ],

                    SizedBox(height: 20),

                    WidgetHelpers.buildCommonButton(
                      text: 'Save',
                      onPressed: _updateUser,
                      backgroundColor: Colors.white,
                      textColor: Colors.blue,
                      borderRadius: 10.0,
                      paddingVertical: 16.0,
                    ),

                    SizedBox(height: 20),

                    WidgetHelpers.buildCommonButton(
                      text: 'Change Password',
                      onPressed: _updateUser,
                      backgroundColor: Colors.white,
                      textColor: Colors.blue,
                      borderRadius: 10.0,
                      paddingVertical: 16.0,
                      paddingHorizontal: 10,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
