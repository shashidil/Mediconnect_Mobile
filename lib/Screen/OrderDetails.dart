import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/WidgetHelpers.dart';
import '../Widget/updateOrderModal.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final bool isPharmacist;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.isPharmacist,
  });

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
      final updatedOrders = await OrderAPI.fetchOrderHistory(userId, widget.isPharmacist);
      setState(() {
        order = updatedOrders.firstWhere((o) => o.id == order.id, orElse: () => order);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh order details: $e')),
      );
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
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }
  Future<void> _trackOrder() async {
//    String trackingUrl = 'https://track.aftership.com/${order.trackingNumber}'; // Generic tracking website
    String trackingUrl = 'https://track24.net/service/lkpost/tracking/${order.trackingNumber}'; // Generic tracking website
    if (await canLaunchUrl(Uri.parse(trackingUrl))) {
      await launchUrl(Uri.parse(trackingUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch tracking URL')),
      );
    }
  }

  Widget _buildOrderProgressBar() {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.watch_later,
            color: order.orderStatus == 'Awaiting Shipment'
                ? Colors.orange
                : Colors.grey,
          ),
          title: const Text('Awaiting Shipment'),
          subtitle: const Text('Your order is awaiting shipment.'),
        ),
        ListTile(
          leading: Icon(
            Icons.local_shipping,
            color: order.orderStatus == 'Shipped' ? Colors.blue : Colors.grey,
          ),
          title: const Text('Order Shipped'),
          subtitle: const Text('Your order has been shipped.'),
        ),
        ListTile(
          leading: Icon(
            Icons.assignment_turned_in,
            color: order.orderStatus == 'Complete' ? Colors.green : Colors.grey,
          ),
          title: const Text('Order Complete'),
          subtitle: const Text('Your order has been completed.'),
        ),
        ListTile(
          leading: Icon(
            Icons.cancel,
            color: order.orderStatus == 'Cancelled' ? Colors.red : Colors.grey,
          ),
          title: const Text('Order Cancelled'),
          subtitle: const Text('Your order has been cancelled.'),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Order Number:', order.orderNumber, Colors.blue),
            const SizedBox(height: 8),
            _buildDetailRow('Order Date:', order.orderDate, Colors.black),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Total Amount:',
              '\$${order.totalAmount.toStringAsFixed(2)}',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Payment Status:', order.paymentStatus, Colors.black),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Order Status:',
              order.orderStatus,
              order.orderStatus == 'Complete'
                  ? Colors.green
                  : (order.orderStatus == 'Cancelled'
                  ? Colors.red
                  : Colors.orange),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Tracking Number:',
              order.trackingNumber ?? 'N/A',
              Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          if (widget.isPharmacist)
            WidgetHelpers.buildCommonButton(
              text: 'Update Order',
              onPressed: () => _showUpdateOrderModal(context),
              backgroundColor: Colors.green,
              textColor: Colors.white,
              borderRadius: 8.0,
              paddingVertical: 12.0,
              paddingHorizontal: 24.0,
            )
          else ...[
            // WidgetHelpers.buildCommonButton(
            //   text: 'View Details',
            //   onPressed: () {},
            //   backgroundColor: Colors.blue,
            //   textColor: Colors.white,
            //   borderRadius: 8.0,
            //   paddingVertical: 12.0,
            //   paddingHorizontal: 24.0,
            // ),
            const SizedBox(height: 10),
            if (order.orderStatus == 'Shipped' || order.orderStatus == 'Complete')
              WidgetHelpers.buildCommonButton(
                text: 'Track Order',
                onPressed:  _trackOrder,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                borderRadius: 8.0,
                paddingVertical: 12.0,
                paddingHorizontal: 24.0,
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildOrderDetailsCard(),
              _buildOrderProgressBar(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
