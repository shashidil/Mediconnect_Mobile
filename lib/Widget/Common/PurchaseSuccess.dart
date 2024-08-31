import 'package:flutter/material.dart';

class PurchaseSuccess extends StatelessWidget {
  final String orderNumber;

  const PurchaseSuccess({Key? key, required this.orderNumber}) : super(key: key);

  void backToDashboard(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst); // Replace with actual navigation logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase Success')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text(
                'Successfully Purchased Your Order!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Order number: $orderNumber\nYour purchase is being processed.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => backToDashboard(context),
                child: Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
