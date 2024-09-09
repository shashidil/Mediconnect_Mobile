import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:medi_connect/Sevices/Auth/UserSession.dart';
import 'package:medi_connect/Widget/Common/PurchaseSuccess.dart';
import '../Model/ResponseData.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Widget/WidgetHelpers.dart';

class PaymentScreen extends StatefulWidget {
  final ResponseData data;

  const PaymentScreen({super.key, required this.data});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  late String _orderNumber;

  String generateOrderNumber() {
    final random = Random();
    final orderNumber = random.nextInt(9000) + 1000; // Generates a number between 1000 and 9999
    return 'ORD#$orderNumber';
  }

  Future<void> initPaymentSheet() async {
    try {
      setState(() {
        _isLoading = true;
        _orderNumber = generateOrderNumber();
      });

      // 1. Create payment intent by calling the backend API via OrderAPI
      final paymentData = await OrderAPI.createPaymentIntent(
        widget.data.id,
        widget.data.total,
      );

      // 2. Initialize the payment sheet with the client secret from the backend
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentData['client_secret'], // Client secret from the backend
          merchantDisplayName: 'MediConnect Pharmacy',
          style: ThemeMode.system,
          customerId: paymentData['customer'], // Optional: if you are managing customers
          customerEphemeralKeySecret: paymentData['ephemeralKey'], // Optional: if you are managing customers
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error initializing payment: $e')));
      print(e);
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      final userId = int.parse(await UserSession.getUserId() ?? '0');
      // 3. Present the payment sheet
      await stripe.Stripe.instance.presentPaymentSheet();

      //  4. Confirm the payment by calling the backend's processOrderPayment API
      await OrderAPI.processOrderPayment(
        widget.data.id,
        _orderNumber,
        widget.data.pharmacistId,
        userId,
        'card',
        widget.data.total,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseSuccess(orderNumber: _orderNumber),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment successful!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildOrderSummary(),
            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
              child: WidgetHelpers.buildCommonButton(
                text: 'Checkout',
                onPressed: () async {
                  await initPaymentSheet(); // Initialize the payment sheet
                  await presentPaymentSheet(); // Present the payment sheet
                },
                backgroundColor: Colors.blue, // Your desired button color
                textColor: Colors.white, // White text color
                paddingVertical: 16.0, // Custom padding for better button design
                borderRadius: 8.0,
                paddingHorizontal: 80.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Order Summary widget
  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.shopping_cart, color: Colors.orange),
                SizedBox(width: 8),
                Text('Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Pharmacist', widget.data.pharmacistName),
            const SizedBox(height: 16),
            const Divider(),
            ..._buildMedicationDetails(),
            const Divider(),
            _buildSummaryRow('Total', '\$${widget.data.total?.toStringAsFixed(2) ?? 'N/A'}', isBold: true),
          ],
        ),
      ),
    );
  }

  // Build summary row for labels and values
  Widget _buildSummaryRow(String label, String? value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value ?? 'N/A',
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  // Build medication details in the summary
  List<Widget> _buildMedicationDetails() {
    return widget.data.medications
        .map(
          (med) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildSummaryRow('${med.medicationName} - ${med.medicationDosage} units', '\$${med.amount.toStringAsFixed(2)}'),
      ),
    )
        .toList();
  }
}
