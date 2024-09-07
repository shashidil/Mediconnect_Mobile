import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/API/LoginAPI.dart';
import '../Model/LoginDto.dart';
import '../Model/LoginResponse.dart';
import '../Sevices/Auth/AuthHeader.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/WidgetHelpers.dart';
import 'PatientDashboard.dart';
import 'PatientSignup.dart';
import 'PharmacistDashboard.dart';
import 'PharmacistSignup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

void _showRoleSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Your Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Sign up as Patient'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PatientSignup()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Sign up as Pharmacist'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PharmacistSignup()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginAPI _loginAPI = LoginAPI();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final loginDto = LoginDto(username, password);

      try {
        final response = await _loginAPI.login(loginDto);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final loginResponse = LoginResponse.fromJson(jsonResponse);

          await AuthHeader.storeAccessToken(loginResponse.token);
          dynamic userIdDynamic = loginResponse.id;
          String userId = userIdDynamic.toString();
          await UserSession.storeUserId(userId);
          await UserSession.storeUserName(loginResponse.username);
          await UserSession.storeUserEmail(loginResponse.email);


          await _loginAPI.saveTokenToBackend();

          final roles = loginResponse.roles;

          if (roles.contains("ROLE_PHARMACIST")) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PharmacistDashboard(),
              ),
            );
          } else if (roles.contains("ROLE_CUSTOMER")) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PatientDashboard(),
              ),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
        } else {
          final errorMessage = response.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login_cover.jpg',
                  height: 250,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E384D),
                  ),
                ),
                const SizedBox(height: 30),
                WidgetHelpers.buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person,
                ),
                WidgetHelpers.buildPasswordTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 20),
                WidgetHelpers.buildCommonButton(
                  text: 'Login',
                  onPressed: _login,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  borderRadius: 10.0,
                  paddingVertical: 16.0,
                  paddingHorizontal: 5,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => _showRoleSelectionDialog(context),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
