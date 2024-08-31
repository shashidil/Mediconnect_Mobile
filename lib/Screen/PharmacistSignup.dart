import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medi_connect/Widget/Common/CommonAppBar.dart';

import '../Model/PharmacistSignupDto.dart';
import '../Model/SignupDto.dart';
import '../Sevices/API/PharmacistSignupAPI.dart';
import '../Sevices/API/RegNumberAPI.dart';
import 'Login.dart';

class PharmacistSignup extends StatefulWidget {
  const PharmacistSignup({super.key});

  @override
  _PharmacistSignupState createState() => _PharmacistSignupState();
}

class _PharmacistSignupState extends State<PharmacistSignup> {
  final _formKey = GlobalKey<FormState>(); // Key to validate the form
  final PharmacistSignupAPI _signupAPI = PharmacistSignupAPI(); // Instance of SignupAPI
  final RegNumberAPI _regNumberAPI = RegNumberAPI();


  // Controllers for capturing form input
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    // Clean up controllers when the widget is disposed
    _debounce?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        isRegNumberValid = false; //

      }

      setState(() {
        isCheckingRegNumber = false; // Stop checking
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

     // await _checkRegNumber();
      // if (isRegNumberValid) {
          final response = await _signupAPI.signup(signupDto);

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign-up successful')),
            );
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen())
            );
            // Navigate to another screen or handle success logic
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign-up failed: ${response.body}')),
            );
          }
       // }
       //  else {
       //    ScaffoldMessenger.of(context).showSnackBar(
       //      const SnackBar(content: Text('Invalid registration number')),
       //    );
       // }
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
      appBar:const CommonAppBar(),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach the form key for validation
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
                // Form fields with validation
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Password and Confirm Password do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pharmacyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pharmacy Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pharmacy name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _regNumberController,
                  decoration:InputDecoration(
                    labelText: 'Registration Number',
                    suffixIcon:isCheckingRegNumber
                        ? const CircularProgressIndicator()
                        : isRegNumberValid
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                  onChanged: _onRegNumberChanged,
                  // onFieldSubmitted: (value) async {
                  //   await _checkRegNumber();
                  // },
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address Line 1',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Postal Code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your postal code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF2E384D)),
                    fixedSize: MaterialStateProperty.all(const Size(300, 20)),
                  ),
                  onPressed: _signup,
                  child: const Text("Sign Up",
                    style:TextStyle(
                      color:Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
