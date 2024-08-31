import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medi_connect/Screen/Login.dart';
import 'package:medi_connect/Screen/PatientDashboard.dart';
import 'package:medi_connect/Screen/PharmacistSignup.dart';
import 'package:medi_connect/Screen/Resposes.dart';
import 'package:medi_connect/Screen/uploadPrescription.dart';


void main() {
  Stripe.publishableKey = 'pk_test_51PlqqoBk6PYt3LyQFjp7Fgafw2HQtEYKLFw4BO5JbOhN5KMKM7BmWA9BUW3WENzPkq4NdiqaH6QKHGxWGNi7KbAL00XSGnPogD';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }


}



