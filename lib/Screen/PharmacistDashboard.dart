import 'package:flutter/material.dart';
import 'package:medi_connect/Screen/OverviewPage.dart';
import 'package:medi_connect/Screen/PrescriptionListScreen.dart';
import 'package:medi_connect/Screen/SendInquiryPage.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';
import 'package:medi_connect/Widget/Common/PharmacistMenu.dart';
import '../Sevices/API/UploadPriscriptionAPI.dart';
import '../Sevices/Auth/AuthHeader.dart';
 // Ensure you have this path correct
import '../Model/PrescriptionDTO.dart';
import 'ChatListScreen.dart';
import 'Login.dart';
import '../Widget/Common/CommonAppBar.dart';
import 'OrderHistoryScreen.dart';
import 'SettingsPage.dart';

class PharmacistDashboard extends StatelessWidget {
  const PharmacistDashboard({super.key});

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

  Future<void> _fetchAndNavigateToPrescriptions(BuildContext context) async {
    try {
      // Get pharmacist ID from the user session or any other appropriate source
      String? pharmacistId = await UserSession.getUserId(); // Assuming you store the user ID in the session

      if (pharmacistId != null) {
        // Fetch prescriptions based on the pharmacist's ID
        List<Map<String, dynamic>> prescriptionData = await UploadPrescriptionAPI().fetchPrescriptions(int.parse(pharmacistId));

        // Convert the fetched data to a list of PrescriptionDTO objects
        List<PrescriptionDTO> prescriptions = prescriptionData.map((e) => PrescriptionDTO.fromJson(e)).toList();

        // Navigate to PrescriptionListScreen with the fetched data
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PrescriptionListScreen(prescriptions: prescriptions),
          ),
        );
      } else {
        throw Exception('Pharmacist ID not found.');
      }
    } catch (e) {
      // Handle errors here, maybe show a Snackbar or some other UI indication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load prescriptions. Please try again later.')),
      );
    }
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
        SnackBar(content: Text('Error: User ID not found.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: PharmacistMenu(
        onMenuItemSelected: (String menuItem) {
          Navigator.of(context).pop(); // Close the drawer after selection

          if (menuItem == 'Request') {
            _fetchAndNavigateToPrescriptions(context);
          }

          if (menuItem == 'Logout') {
            _logout(context);
          }
          if (menuItem == 'Chats') {
            // Navigate to the OrderHistoryScreen for patients
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatListScreen(),
              ),
            );
          }
          if (menuItem == 'Orders') {
            // Navigate to the OrderHistoryScreen for patients
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrderHistoryScreen(isPharmacist: true),
              ),
            );
          }
          if (menuItem == 'Overview') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  OverviewPage(),
              ),
            );
          }
          if (menuItem == 'Settings') {
            _setting(context);
          }
          if (menuItem == 'Support') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  SendInquiryPage(),
              ),
            );
          }

        },

      ),
      body: OverviewPage(),
    );
  }
}
