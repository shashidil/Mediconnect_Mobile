import 'package:flutter/material.dart';
import 'package:medi_connect/Screen/ChatListScreen.dart';
import 'package:medi_connect/Screen/Login.dart';
import 'package:medi_connect/Screen/OrderHistoryScreen.dart';
import 'package:medi_connect/Screen/SettingsPage.dart';
import 'package:medi_connect/Screen/uploadPrescription.dart';
import 'package:medi_connect/Sevices/Auth/AuthHeader.dart';
import '../Sevices/Auth/UserSession.dart';
import 'PatientOverview.dart';
import 'Resposes.dart';
import '../Widget/Common/CommonAppBar.dart';
import '../Widget/Common/PatientMenu.dart';
import 'SendInquiryPage.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});


  Future<void> _logout(BuildContext context) async {
    // Clear the user session
    await AuthHeader.clearAccessToken();
    await UserSession.clearAll();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _setting(BuildContext context) async {
    String? userId = await UserSession.getUserId();

    if (userId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SettingsPage(userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID not found.')),
      );
    }
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
          if (menuItem == 'Orders') {
            // Navigate to the OrderHistoryScreen for patients
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrderHistoryScreen(isPharmacist: false),
              ),
            );
          }

          if (menuItem == 'Chats') {
            // Navigate to the OrderHistoryScreen for patients
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChatListScreen(),
              ),
            );
          }
          if (menuItem == 'Settings') {
            _setting(context);
          }
          if (menuItem == 'Support') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  const SendInquiryPage(),
              ),
            );
          }
          if (menuItem == 'Logout') {
            _logout(context);
          }
        },
      ),
      body: const PatientOverviewPage()
    );
  }
}
