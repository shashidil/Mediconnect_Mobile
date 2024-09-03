import 'package:flutter/material.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/updateOrderModal.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final bool isPharmacist;

  const OrderDetailsScreen({Key? key, required this.order, required this.isPharmacist}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order; // Initialize with the order passed in
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final userId = int.parse(await UserSession.getUserId() ?? '0');
      final updatedOrder = await OrderAPI.fetchOrderHistory(userId, true);
      setState(() {
        order = updatedOrder.firstWhere((o) => o.id == order.id); // Assuming API returns a list
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh order details: $e')));
    }
  }

  void _showUpdateOrderModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateOrderModal(
          order: order,
          onUpdate: () {
            _fetchOrderDetails();
            Navigator.of(context).pop(true); // Return true to indicate the order was updated
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Number: ${order.orderNumber}', style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Order Date: ${order.orderDate}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Payment Status: ${order.paymentStatus}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Order Status: ${order.orderStatus}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Tracking Number: ${order.trackingNumber ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              _buildOrderProgressBar(), // Display the progress bar
              const SizedBox(height: 20),
              if (widget.isPharmacist)
                ElevatedButton(
                  onPressed: () => _showUpdateOrderModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Update Order'),
                ),
              if (!widget.isPharmacist && order.orderStatus == 'Shipped')
                ElevatedButton(
                  onPressed: () {
                    // Implement tracking logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Track Order'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderProgressBar() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.assignment_turned_in,
              color: order.orderStatus == 'Complete' ? Colors.green : Colors
                  .grey),
          title: Text('Order Complete'),
          subtitle: Text('Your order has been completed.'),
        ),
        ListTile(
          leading: Icon(Icons.local_shipping,
              color: order.orderStatus == 'Shipped' ? Colors.blue : Colors
                  .grey),
          title: Text('Order Shipped'),
          subtitle: Text('Your order has been shipped.'),
        ),
        ListTile(
          leading: Icon(Icons.watch_later,
              color: order.orderStatus == 'Awaiting Shipment'
                  ? Colors.orange
                  : Colors.grey),
          title: Text('Awaiting Shipment'),
          subtitle: Text('Your order is awaiting shipment.'),
        ),
        ListTile(
          leading: Icon(Icons.cancel,
              color: order.orderStatus == 'Cancelled' ? Colors.red : Colors
                  .grey),
          title: Text('Order Cancelled'),
          subtitle: Text('Your order has been cancelled.'),
        ),
      ],
    );
  }
}
