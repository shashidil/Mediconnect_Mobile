import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../Model/ResponseData.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/Common/PurchaseSuccess.dart';

class PaymentScreen extends StatefulWidget {
  final ResponseData data;

  const PaymentScreen({Key? key, required this.data}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String orderNumber;
  bool isOrderCompleted = false;
  CardFieldInputDetails? cardDetails;

  @override
  void initState() {
    super.initState();
    orderNumber = 'ORD#${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> handleOrderCompletion() async {
    setState(() {
      isOrderCompleted = true;
    });
  }

  Future<void> handlePayment() async {
    if (cardDetails == null || !cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your card details')));
      return;
    }

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: 'Card Holder Name', // Replace with a real name from your form
            ),
          ),
        ),
      );

      final response = await OrderAPI.processOrderPayment(
        widget.data.id,
        orderNumber,
        widget.data.pharmacistId ?? 0, // Provide a fallback if pharmacistId is null
        int.parse(await UserSession.getUserId() ?? '0'), // Handle userId as nullable
        'Card', // Payment method type
        widget.data.total,
        paymentMethod.id, // Pass the PaymentMethod ID to the backend
      );

      if (response['success']) {
        handleOrderCompletion();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment processing error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: isOrderCompleted
          ? PurchaseSuccess(orderNumber: orderNumber)
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Pharmacist Name: ${widget.data.pharmacistName}'),
            Text('Order Number: $orderNumber'),
            Text('Invoice Number: ${widget.data.invoiceNumber}'),
            Text('Total: \$${widget.data.total?.toStringAsFixed(2)}'),
            Divider(),
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CardField(
              onCardChanged: (card) {
                setState(() {
                  cardDetails = card;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handlePayment,
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
