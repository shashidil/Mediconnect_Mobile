import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medi_connect/Screen/PatientSignup.dart';
import 'package:medi_connect/Screen/PharmacistSignup.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';
import '../Model/LoginDto.dart';
import '../Model/LoginResponse.dart';
import '../Sevices/API/LoginAPI.dart';
import '../Sevices/Auth/AuthHeader.dart';
import '../Widget/Common/CommonAppBar.dart';
import 'PatientDashboard.dart';
import 'PharmacistDashboard.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginAPI _loginAPI = LoginAPI(); // Initialize the LoginAPI

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

          // Store the access token securely
          await AuthHeader.storeAccessToken(loginResponse.token);
          dynamic userIdDynamic = loginResponse.id;
          String userId = userIdDynamic.toString();
          await UserSession.storeUserId(userId);
          await UserSession.storeUserName(loginResponse.username);
          await UserSession.storeUserEmail(loginResponse.email);

          // Check if user ID is stored
          String? storedUserId = await UserSession.getUserId();
          if (storedUserId != null) {
            print('User ID stored successfully: $storedUserId');
          } else {
            print('Failed to store user ID');
          }
          // Determine the role and navigate to the appropriate dashboard
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
          print(errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      } catch (e) {
        print(e);
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
      appBar:const CommonAppBar(),
        backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Image(
                image: AssetImage('assets/images/login.jpg'),
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                "SIGN IN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E384D),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle "Forgot Password?" logic
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login, // Call the login function
                child: const Text("Login"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder:(context) => PatientSignup()),
                      );
                    },
                    child: const Text("Sign Up as Patient"),
                  ),

                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder:(context) => PharmacistSignup()),
                  );
                },
                child: const Text("Sign Up as Pharmacist"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
