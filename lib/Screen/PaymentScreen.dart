// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe; // Alias the Stripe package
// import '../Model/ResponseData.dart';
// import '../Sevices/API/OrderAPI.dart';
// import '../Sevices/Auth/UserSession.dart';
// import '../Widget/Common/PurchaseSuccess.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final ResponseData data;
//
//   const PaymentScreen({Key? key, required this.data}) : super(key: key);
//
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late String orderNumber;
//   bool isOrderCompleted = false;
//   stripe.CardFieldInputDetails? cardDetails;
//   TextEditingController _cardHolderNameController = TextEditingController();
//   String cardType = 'Visa';
//   String orderType = 'Pickup';
//
//   @override
//   void initState() {
//     super.initState();
//     orderNumber = 'ORD#${DateTime.now().millisecondsSinceEpoch}';
//   }
//
//   Future<void> handleOrderCompletion() async {
//     setState(() {
//       isOrderCompleted = true;
//     });
//   }
//
//   Future<void> handlePayment() async {
//     if (cardDetails == null || !cardDetails!.complete) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter your card details')),
//       );
//       return;
//     }
//
//     if (_cardHolderNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter the card holder\'s name')),
//       );
//       return;
//     }
//
//     try {
//       final paymentMethod = await stripe.Stripe.instance.createPaymentMethod(
//         params: stripe.PaymentMethodParams.card(
//           paymentMethodData: stripe.PaymentMethodData(
//             billingDetails: stripe.BillingDetails(
//               name: _cardHolderNameController.text, // Card holder's name
//             ),
//           ),
//         ),
//       );
//
//       final response = await OrderAPI.processOrderPayment(
//         widget.data.id,
//         orderNumber,
//         widget.data.pharmacistId ?? 0, // Provide a fallback if pharmacistId is null
//         int.parse(await UserSession.getUserId() ?? '0'), // Handle userId as nullable
//         cardType, // Payment method type
//         widget.data.total,
//         paymentMethod.id, // Pass the PaymentMethod ID to the backend
//       );
//
//       if (response['success']) {
//         handleOrderCompletion();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment processing error: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment')),
//       body: isOrderCompleted
//           ? PurchaseSuccess(orderNumber: orderNumber)
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order Summary',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Pharmacist Name: ${widget.data.pharmacistName}'),
//                     Text('Order Number: $orderNumber'),
//                     Text('Invoice Number: ${widget.data.invoiceNumber}'),
//                     Text('Total: \$${widget.data.total?.toStringAsFixed(2)}'),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Payment Method',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _cardHolderNameController,
//                       decoration: InputDecoration(
//                         labelText: 'Card Holder Name',
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     stripe.CardField(
//                       onCardChanged: (card) {
//                         setState(() {
//                           cardDetails = card;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Card Information',
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             value: cardType,
//                             decoration: InputDecoration(
//                               labelText: 'Card Type',
//                               border: OutlineInputBorder(),
//                             ),
//                             items: ['Visa', 'MasterCard'].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (newValue) {
//                               setState(() {
//                                 cardType = newValue!;
//                               });
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             value: orderType,
//                             decoration: InputDecoration(
//                               labelText: 'Order Type',
//                               border: OutlineInputBorder(),
//                             ),
//                             items: ['Pickup', 'Delivery'].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (newValue) {
//                               setState(() {
//                                 orderType = newValue!;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: handlePayment,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Pay Now'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
