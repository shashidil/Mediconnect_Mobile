import 'package:flutter/material.dart';
import 'package:medi_connect/Screen/Login.dart';
import 'package:medi_connect/Screen/uploadPrescription.dart';
import 'package:medi_connect/Sevices/Auth/AuthHeader.dart';
import '../Sevices/Auth/UserSession.dart';
import 'Resposes.dart';
import '../Widget/Common/CommonAppBar.dart';
import '../Widget/Common/PatientMenu.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});


  Future<void> _logout(BuildContext context) async {
    // Clear the user session
    await AuthHeader.clearAccessToken();
    await UserSession.clearAll();

    // Navigate to the LoginScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(), // Use the updated AppBar with Builder
      drawer: PatientMenu(
        onMenuItemSelected: (String menuItem) {
          Navigator.of(context).pop(); // Close the drawer after selection

          if (menuItem == 'Response') {
            // Navigate to the ResponseScreen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResponseScreen(),
              ),
            );
          }

          if (menuItem == 'Prescription') {
            // Navigate to the ResponseScreen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UploadPrescription(),
              ),
            );
          }

          if (menuItem == 'Logout') {
            _logout(context);
          }
        },
      ),
      body: const Center(
        child: Text("Welcome to Patient Dashboard"),
      ),
    );
  }
}
