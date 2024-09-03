import 'package:flutter/material.dart';

import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Widget/updateOrderModal.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final bool isPharmacist;
  final VoidCallback refreshOrders;

  const OrderCard({
    Key? key,
    required this.order,
    required this.isPharmacist,
    required this.refreshOrders,
  }) : super(key: key);

  void _showInvoice(BuildContext context, String invoiceNumber) async {
    // try {
    //   final invoiceData = await OrderAPI.getInvoiceByInvoiceNumber(invoiceNumber);
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (_) => InvoiceDetailsModal(invoiceData: invoiceData),
    //   );
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to load invoice details')),
    //   );
    // }
  }

  void _editOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => UpdateOrderModal(
        order: order,
        onUpdate: refreshOrders,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number: ${order.orderNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Order Date: ${order.orderDate}'),
            Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
            Text('Payment Status: ${order.paymentStatus}'),
            Text('Order Status: ${order.orderStatus}'),
            Text('Tracking Number: ${order.trackingNumber ?? 'N/A'}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _showInvoice(context, order.invoiceNumber),
                  child: Text('View Details'),
                ),
                if (isPharmacist)
                  ElevatedButton(
                    onPressed: () => _editOrder(context),
                    child: Text('Edit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}