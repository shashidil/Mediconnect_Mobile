import 'package:flutter/material.dart';
import 'package:medi_connect/Widget/WidgetHelpers.dart';
import '../Model/PatientSignupDto.dart';
import '../Model/SignupDto.dart';
import '../Sevices/API/PatientSignupAPI.dart';
import '../Widget/Common/CommonAppBar.dart';
import 'Login.dart';

class PatientSignup extends StatefulWidget {
  const PatientSignup({super.key});

  @override
  _PatientSignupState createState() => _PatientSignupState();
}

class _PatientSignupState extends State<PatientSignup> {
  final _formKey = GlobalKey<FormState>(); // Key to validate the form
  final SignupAPI _signupAPI = SignupAPI();

  // Controllers to capture form input
  final _usernameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _usernameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final patientSignupDto = PatientSignupDto(
        username: _usernameController.text,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text,
        addressLine1: _addressController.text,
        city: _cityController.text,
        states: _stateController.text,
        postalCode: _postalCodeController.text,
      );

      final signupDto = SignupDto(signupRequestPatient: patientSignupDto.toJson());
      try {
        final response = await _signupAPI.signupPatient(signupDto);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful')),
          );
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-up failed: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-up error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E384D),
                  ),
                ),
                const SizedBox(height: 16),
                // Username Field
                WidgetHelpers.buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // First Name and Last Name in the same row
                Row(
                  children: [
                    Expanded(
                      child: WidgetHelpers.buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: WidgetHelpers.buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Email Field
                WidgetHelpers.buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Password Field
                WidgetHelpers.buildPasswordTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscureText,
                  toggleVisibility: _togglePasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Phone Number Field
                WidgetHelpers.buildTextField(
                  controller: _phoneNumberController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Address Line 1 Field
                WidgetHelpers.buildTextField(
                  controller: _addressController,
                  label: 'Address Line 1',
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // City and State in the same row
                Row(
                  children: [
                    Expanded(
                      child: WidgetHelpers.buildTextField(
                        controller: _cityController,
                        label: 'City',
                        icon: Icons.location_city,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: WidgetHelpers.buildTextField(
                        controller: _stateController,
                        label: 'State',
                        icon: Icons.map,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your state';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Postal Code Field
                WidgetHelpers.buildTextField(
                  controller: _postalCodeController,
                  label: 'Postal Code',
                  icon: Icons.mail_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your postal code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Sign-up button using buildCommonButton
                WidgetHelpers.buildCommonButton(
                  text: 'Sign Up',
                  onPressed: _signup,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  borderRadius: 10.0,
                  paddingVertical: 16.0,
                  paddingHorizontal: 32.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
