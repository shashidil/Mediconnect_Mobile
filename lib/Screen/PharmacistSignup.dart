import 'dart:async';
import 'package:flutter/material.dart';
import '../Model/PharmacistSignupDto.dart';
import '../Model/SignupDto.dart';
import '../Sevices/API/PharmacistSignupAPI.dart';
import '../Sevices/API/RegNumberAPI.dart';
import '../Widget/Common/CommonAppBar.dart';
import '../Widget/WidgetHelpers.dart';
import 'Login.dart';

class PharmacistSignup extends StatefulWidget {
  const PharmacistSignup({super.key});

  @override
  _PharmacistSignupState createState() => _PharmacistSignupState();
}

class _PharmacistSignupState extends State<PharmacistSignup> {
  final _formKey = GlobalKey<FormState>();
  final PharmacistSignupAPI _signupAPI = PharmacistSignupAPI();
  final RegNumberAPI _regNumberAPI = RegNumberAPI();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pharmacyNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  bool isRegNumberValid = false;
  bool isCheckingRegNumber = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pharmacyNameController.dispose();
    _regNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkRegNumber() async {
    final regNumber = _regNumberController.text;
    if (regNumber.isNotEmpty) {
      setState(() {
        isCheckingRegNumber = true;
      });

      try {
        isRegNumberValid = await _regNumberAPI.checkRegNumber(regNumber);
      } catch (e) {
        isRegNumberValid = false;
      }

      setState(() {
        isCheckingRegNumber = false;
      });
    }
  }

  void _onRegNumberChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkRegNumber();
    });
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final pharmacistSignupDto = PharmacistSignupDto(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        pharmacyName: _pharmacyNameController.text,
        regNumber: _regNumberController.text,
        addressLine1: _addressController.text,
        city: _cityController.text,
        states: _stateController.text,
        postalCode: _postalCodeController.text,
      );

      final signupDto = SignupDto(signupRequestPharmacist: pharmacistSignupDto.toJson());

      try {
        final response = await _signupAPI.signup(signupDto);

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
      appBar: const CommonAppBar(),
      backgroundColor: Colors.white,
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
                // Form fields using buildTextField
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
                WidgetHelpers.buildPasswordTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  toggleVisibility: () {
                    setState(() {
                      _passwordController.text =
                          _passwordController.text; // Just to trigger a rebuild
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                WidgetHelpers.buildTextField(
                  controller: _pharmacyNameController,
                  label: 'Pharmacy Name',
                  icon: Icons.local_pharmacy,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pharmacy name';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _regNumberController,
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      prefixIcon: const Icon(Icons.assignment_ind),
                      suffixIcon: isCheckingRegNumber
                          ? const CircularProgressIndicator()
                          : isRegNumberValid
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _onRegNumberChanged,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your registration number';
                      }
                      if (!isRegNumberValid) {
                        return 'Invalid registration number';
                      }
                      return null;
                    },
                  ),
                ),
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
